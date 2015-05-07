//
//  PlayingPlayer.swift
//  Bura
//
//  Created by Denys FRIDMAN on 4/4/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import Foundation


class PlayingPlayer : Player {
    
    var pile: [PlayingCard] = [PlayingCard]();  /* cards in player's pile (point cards) */
    
    var cards_in_play: [PlayingCard] = [PlayingCard]();  /* cards in play, ie the player initiated a move */
                                                         /* with these cards or responded with them */
    
    
    init(player_id: Int) {
        super.init();
        self.hand = [PlayingCard]();
        self.player_id = player_id;
    }
    
    
    
    /* Tests whether a player has a Bura (3 cards of trump suit). */
    func hasBura() -> Bool {
        return PlayingPlayer.hasBura(self.hand as! [PlayingCard]);
    }
    
    
    
    /* Tests whether an array of cards constitutes a bura. */
    class func hasBura(cards: [PlayingCard]) -> Bool {
        if (cards.count < 3) { return false; }
        for card in cards {
            if (!card.is_trump) { return false; }
        }
        return true;
    }
    
    
    
    /* Tests whether a player has a Golden Bura (3 Aces, one of
     * which must be of trump suit. */
    func hasGoldenBura() -> Bool {
        return PlayingPlayer.hasGoldenBura(self.hand as! [PlayingCard]);
    }
    
    
    
    /* Tests whether an array of cards constitutes a golden bura. */
    class func hasGoldenBura(cards: [PlayingCard]) -> Bool {
        if (cards.count < 3) { return false; }
        var trump_seen: Bool = false;
        for card in cards {
            if (card.rank != PlayingCard.max_rank) { return false; }
            if (card.is_trump!) { trump_seen = true; }
        }
        return trump_seen ? true : false;
    }
    
    
    
    /* Returns player's score. */
    func getScore() -> Int {
        var scores: [Int] = Map({ card in card.score }, self.pile);
        var sum: (Int, Int) -> Int = { (x: Int, y: Int) -> Int in x + y };
        return FoldL(sum, 0, scores);
    }
    


    /* Adds a card to cards in play. */
    func addToCardsInPlay(card: PlayingCard) {
        self.cards_in_play.append(card);
    }
    
    
    
    /* Removes a card from cards in play. */
    func removeFromCardsInPlay(card: PlayingCard) {
        for i in 0..<self.cards_in_play.count {
            let other_card = self.cards_in_play[i];
            if (other_card == card) {
                self.cards_in_play.removeAtIndex(i);
                return;
            }
        }
    }
}