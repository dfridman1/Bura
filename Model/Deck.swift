//
//  Deck.swift
//  Bura
//
//  Created by Denys FRIDMAN on 4/3/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import Foundation




// Abstract Deck class
class Deck : NSObject {
    
    var cards: [Card]!;
    
    var card_index: [Card : Int]!;  /* pairs of type (Card : Index of Card in cards) */
    
    var index_card: [Int : Card]!;  /* pairs of type (Index of Card in cards : Card) */
    
    var deckSize: Int!;  /* initial cardsCount */
    
    /* Returns the number of cards left in the deck. */
    var cardsCount: Int {
        get {
            return self.cards.count;
        }
    }
    
    
    
    /* Adds card on top of the deck. */
    func addCard(card: Card) {
        self.cards.append(card);
    }
    
    
    
    /* Draws the top card. */
    func drawCard() -> Card? {
        return self.isEmpty ? nil : self.cards.removeLast();
    }
    
    
    
    /* Tests whether the deck is empty. */
    var isEmpty: Bool {
        get {
            return self.cards.isEmpty;
        }
    }
    
    
    
    /* Returns card at index. */
    func cardAtIndex(index: Int) -> Card? {
        return self.index_card[index];
    }
    
    
    
    /* Returns index of card. If not found, return -1. */
    func indexOfCard(card: Card) -> Int {
        for (other_card, index) in self.card_index {
            if (other_card == card) { return index; }
        }
        return -1;
    }
}