//
//  PlayingDeck.swift
//  Bura
//
//  Created by Denys FRIDMAN on 4/3/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import Foundation




class PlayingDeck : Deck {
    
    let min_rank: Int = 0;
    
    let max_rank: Int = 8;
    
    var trump_card: PlayingCard!;
    
    
    
    override init() {
        super.init();
        
        var cards: [(Int, Int)] = [(Int, Int)]();
        for rank in self.min_rank...self.max_rank {
            for suit_index in 0..<4 {
                cards.append((rank, suit_index));
            }
        }
        
        cards = sorted(cards, { a, b in arc4random() % 2 == 0 });  // shuffle cards
        
        self.initAux(cards);
    }
    
    
    
    /* Builds a playing deck from tuples (Rank, Suit), both represented as integers */
    init(cards: [(Int, Int)]) {
        super.init();
        
        self.initAux(cards);
    }
    
    
    
    private func initAux(cards: [(Int, Int)]) {
        self.cards = [PlayingCard]();
        self.card_index = [PlayingCard : Int]();
        self.index_card = [Int : PlayingCard]();
        
        self.deckSize = (self.max_rank - self.min_rank + 1) * 4;
        
        for (rank, suit_raw) in cards {
            self.addCard(PlayingCard(rank: rank, suit: Suit.fromRaw(suit_raw)));
        }
        
        self.trump_card = self.cards[0] as! PlayingCard;  // set trump card
        for card in self.cards as! [PlayingCard] {
            card.is_trump = (card.suit == self.trump_card.suit) ? true : false;
        }
        
        for index in 0..<self.cardsCount {
            let card = self.cards[index];
            self.card_index[card] = index;
            self.index_card[index] = card;
        }
    }
    
    
    
    /* Returns a deck as an array of tupled of the the type (Rank, Suit), both represented as integers */
    class func rawDeck(deck: PlayingDeck) -> [(Int, Int)] {
        var res = [(Int, Int)]();
        
        for card in deck.cards as! [PlayingCard] {
            res.append(PlayingCard.toRaw(card));
        }
        
        return res;
    }
}