//
//  Player.swift
//  Bura
//
//  Created by Denys FRIDMAN on 4/4/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import Foundation


class Player {
    
    var hand: [Card] = [Card]();
    
    var player_id: Int = 0;  /* player's id in the game */
    
    var num_cards: Int {  /* returns the number of cards in hand */
        get {
            return self.hand.count;
        }
    }
    
    var isEmpty: Bool {
        get {
            return self.num_cards == 0;
        }
    }
    
    
    
    /* Adds card to hand. */
    func addCard(card: Card) {
        self.hand.append(card);
    }
    
    
    
    /* Removes card from hand and returns it. */
    func removeCard(card: Card) -> Card? {
        var removed_card: Card?;
        for i in reverse(0..<self.num_cards) {
            if (card == self.hand[i]) {
                removed_card = self.hand.removeAtIndex(i);
                break;
            }
        }
        return removed_card;
    }
    
    
    
    /* Removes cards from hand and returns them as an array. */
    func removeCards(cards: [Card]) -> [Card?] {
        var res = [Card?]();
        for card in cards {
            res.append(self.removeCard(card));
        }
        return res;
    }
    
    
    
    /* Returns the card at the specified index. */
    func cardAtIndex(index: Int) -> Card? {
        return (index >= 0 && index < self.num_cards) ? self.hand[index] : nil;
    }
    
    
    
    /* Removes and returns the card at index. */
    func removeCardAtIndex(index: Int) -> Card? {
        return (index >= 0 && index < self.num_cards) ? self.hand.removeAtIndex(index) : nil;
    }
}