//
//  Card.swift
//  Bura
//
//  Created by Denys FRIDMAN on 4/3/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import Foundation




enum Suit {
    case HEART; case SPADE; case DIAMOND; case CLUB;
    
    /* Create Suit from raw value. */
    static func fromRaw(rawValue: Int) -> Suit {
        switch (rawValue) {
        case 0: return .HEART;
        case 1: return .SPADE;
        case 2: return .DIAMOND;
        case 3: return .CLUB;
        default: fatalError("Must not exceed 3");
        }
    }
    
    
    
    /* Convert Suit to an Int */
    static func toRaw(suit: Suit) -> Int {
        switch (suit) {
        case .HEART: return 0;
        case .SPADE: return 1;
        case .DIAMOND: return 2;
        case .CLUB: return 3;
        default: fatalError("Invalid suit passed-in.");
        }
    }
}





// Abstract Card class
class Card : NSObject {
    
    // Card's rank (ranging from zero (the lowest) to some positive integer).
    var rank: Int!;
    
    // Card's suit.
    var suit: Suit!;
    
    // Returns human-readable representation of a card.
    var contents: String {
        fatalError("Must be overridden");
    }
    
    
    
    // Returns a string representation of a card's rank.
    class func rankToString(rank: Int) -> String {
        fatalError("Must be overridden");
    }
    
    
    
    // Returns a string representation of a card's suit.
    class func suitToString(suit: Suit) -> String {
        fatalError("Must be overridden");
    }
    
    
    
    // Returns a name of the image corresponding to a card.
    class func getCardImgName(card: Card, format: String) -> String {
        fatalError("Must be overridden");
    }
}



/* Tests whether card1 and card2 are essentially the same card. */
func == (card1: Card, card2: Card) -> Bool {
    return card1.rank == card2.rank && card1.suit == card2.suit;
}