//
//  Game.swift
//  Bura
//
//  Created by Denys FRIDMAN on 4/4/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import Foundation




class Game {
    
    var players: [PlayingPlayer] = [PlayingPlayer]();  /* a list of players in the game */
    
    var deck: PlayingDeck = PlayingDeck();
    
    var game_turn: Int = 0;  /* keeps track whose turn it is (index in self.players) */
    
    var number_of_players: Int {
        get {
            return self.players.count;
        }
    }
    
    var game_over: Bool {
        get {
            return self.deck.isEmpty && self.players[0].isEmpty
        }
    }
    
    
    
    /* Default game option assumes a game between 2 opponents */
    init() {
        self.initAux(PlayingDeck(), numberOfPlayers: 2);
    }
    
    
    
    /* Initializes a game with a deck */
    init(deck: PlayingDeck, numberOfPlayers: Int) {
        self.initAux(deck, numberOfPlayers: numberOfPlayers);
    }
    
    
    
    /* Initiates a game with numberOfPlayers opponents. */
    init(numberOfPlayers: Int) {
        self.initAux(PlayingDeck(), numberOfPlayers: numberOfPlayers);
    }
    
    
    
    /* Initializer helper method */
    private func initAux(deck: PlayingDeck, numberOfPlayers: Int) {
        for i in 0..<numberOfPlayers {
            self.players.append(PlayingPlayer(player_id: i));
        }
        
        self.deck = deck;
    }
    
    
    
    /* Deals the cards out to the players. */
    func deal() {
        // The cards are dealt out to each player one at a time, starting with the player
        // whose turn it is until players have 3 cards each or the deck gets empty.
        while (self.players[0].num_cards < 3 && !self.deck.isEmpty) {
            for i in 0..<self.number_of_players {
                var player = self.players[(self.game_turn + i) % self.number_of_players];
                player.addCard(self.deck.drawCard()!);
            }
        }
        
        // After the cards have been dealt out, the turn may change if
        // one of the players has a Golden Bura or Bura
        for i in 0..<self.number_of_players {
            if (self.players[i].hasGoldenBura()) { self.game_turn = i; return; }
        }
        
        for i in 0..<self.number_of_players {
            let index: Int = (self.game_turn + i) % self.number_of_players;
            let player = self.players[index];
            if (player.hasBura()) { self.game_turn = index; return; }
        }
    }
    
    
    
    /* Returns true if every ith card of hand2 can beat ith card of hand1. */
    private func canHandBeatAux(hand1: [PlayingCard], hand2: [PlayingCard]) -> Bool {
        if (hand1.count != hand2.count) { fatalError("Must be of same length."); }
        for i in 0..<hand1.count {
            if (!hand2[i].canBeat(hand1[i])) { return false; }
        }
        return true;
    }
    
    
    
    /* Returns true if hand2 can beat hand1. */
    private func canHandBeat(hand1: [PlayingCard], hand2: [PlayingCard]) -> Bool {
        var possible_hands: [[PlayingCard]] = AllPermutations(hand2);   // AllPermutations defined in helper_functions.swift
        for hand in possible_hands {
            if (self.canHandBeatAux(hand1, hand2: hand)) { return true; }
        }
        return false;
    }
    
    
    
    /* Returns the index of player who won the hand, along with the cards he won.
     * Modifies the pile of the player who has won the hand.
     * hands argument is an array of tuples where first element is the ID of the player,
     * and the second element are the cards he played */
    func handWinner() -> (Int, [PlayingCard]) {
        var index: Int = self.game_turn;
        var hand: [PlayingCard]!;
        var winner: [PlayingCard] = self.players[index].cards_in_play;  // Initially the player initiating the move is assumed to be the winner
        
        // remove cards_in_play from the player's hand
        self.players[index].removeCards(winner);
    
        var winner_index: Int = index;
        for i in 1..<self.number_of_players {
            index = (index + i) % self.number_of_players;
            hand = self.players[index].cards_in_play;
            if (self.canHandBeat(winner, hand2: hand)) {
                winner = hand;
                winner_index = index;
            }
            
            // Remove cards_in_play from player's hand
            self.players[index].removeCards(hand);
        }
        var cards_won: [PlayingCard] = [PlayingCard]();
        for h in Map({ player in player.cards_in_play }, self.players) {
            for card in h {
                self.players[winner_index].pile.append(card);
                cards_won.append(card);
            }
        }
        // update turn
        self.game_turn = winner_index;
        
        // Reset cards in play
        for i in 0..<self.number_of_players {
            self.players[i].cards_in_play = [];
        }
        return (winner_index, cards_won);
    }
    
    
    
    /* Returns true if cards in self.cards_in_play constitute a valid move.
     * NOTE: call this method only when the player initiates the move (not responds). */
    class func isValidMove(cards: [PlayingCard]) -> Bool {
        if (cards.isEmpty) { return false; }
        if (PlayingPlayer.hasBura(cards) || PlayingPlayer.hasGoldenBura(cards)) { return true; }
        let suit: Suit = cards[0].suit;
        for card in cards {
            if (card.suit != suit) { return false; }
        }
        return true;
    }
    
    

    
    /* The following methods determine the behaviour of the 'computer' players.
     * Let's first start with 'responding' methods.
    
     * Returns the cards the 'computer' opponent responds with. */
    func computerRespond(hand: [PlayingCard], player_id: Int) -> [PlayingCard] {
        var res: [PlayingCard] = [PlayingCard]();
        let computer_player: PlayingPlayer = self.players[player_id];
        
        var computer_hand: [PlayingCard] = computer_player.hand as! [PlayingCard];
        // Sort cards in computer's hands by importance (in ascending order)
        computer_hand = sorted(computer_hand, { card1, card2 in card1.importance_score < card2.importance_score });
        
        var possible_combinations = AllSubsets(computer_hand);
        possible_combinations = Filter({ list in list.count == hand.count }, possible_combinations);
        
        for h in possible_combinations {
            if (self.canHandBeat(hand, hand2: h)) {
                res = h;
                break;
            }
        }
        
        
        if (res.count == 0) {
            // If computer player cannot beat the hand, he responds with the least valuable cards
            // NOTE: cards in hand have been sorted by importance (in ascending order)
            for i in 0..<hand.count {
                res.append(computer_hand[i]);
            }
        }
        
        return res;
    }
    
    
    
    /* Returns the cards the 'computer' opponent initiated the move with. */
    func computerInitiate() -> [PlayingCard] {
        var res: [PlayingCard] = [PlayingCard]();
        switch (self.players[self.game_turn].num_cards) {
        case 3:
            res = self.computerInitiateThree();
        case 2:
            res = self.computerInitiateTwo();
        case 1:
            res = self.computerInitiateOne();
        default:
            fatalError("Number of cards must range from 1 to 3 (inclusive)");
        }
        return res;
    }
    
    
    
    private func computerInitiateOne() -> [PlayingCard] {
        // Go ahead with the least important card
        var computer_hand = self.players[self.game_turn].hand as! [PlayingCard];
        computer_hand = sorted(computer_hand, { card1, card2 in card1.importance_score < card2.importance_score });
        let card: PlayingCard = computer_hand[0];
        return [card];
    }
    
    
    
    private func computerInitiateTwo() -> [PlayingCard] {
        var res: [PlayingCard] = [PlayingCard]();
        let computer_player: PlayingPlayer = self.players[self.game_turn];
        var card1: PlayingCard;
        var card2: PlayingCard;
        
        for i in 0..<computer_player.num_cards - 1 {
            for j in (i+1)..<computer_player.num_cards {
                card1 = computer_player.cardAtIndex(i) as! PlayingCard;
                card2 = computer_player.cardAtIndex(j) as! PlayingCard;
                if (card1.suit == card2.suit) {
                    res.append(card1)
                    res.append(card2);
                    break;
                }
            }
            if (!res.isEmpty) { break; }
        }
        
        // If no combination of 2 cards is possible, we call computeInitiateOne method
        if (res.isEmpty) { return self.computerInitiateOne(); }
        
        return res;
    }
    
    
    
    private func computerInitiateThree() -> [PlayingCard] {
        var res: [PlayingCard] = [PlayingCard]();
        
        var common_suit: Suit = self.players[self.game_turn].cardAtIndex(0)!.suit;
        var all_common: Bool = true;
        
        for card in self.players[self.game_turn].hand {
            if (card.suit != common_suit) { all_common = false; break; }
        }
        
        if (all_common || self.players[self.game_turn].hasBura() || self.players[self.game_turn].hasGoldenBura()) {
            res = self.players[self.game_turn].hand as! [PlayingCard];
        } else {
            // If the cards are not of the same suit, call computerInitiateTwo
            res = self.computerInitiateTwo();
        }
        return res;
    }
}