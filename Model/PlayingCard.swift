//
//  PlayingCard.swift
//  Bura
//
//  Created by Denys FRIDMAN on 4/3/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import Foundation




class PlayingCard : Card {
    
    class var max_rank: Int {   /* Corresponding to an Ace. */
        get {
            return 8;
        }
    }
    
    var is_trump: Bool!;
    
    /* Returns the card's score in the game of Bura. */
    var score: Int {
        get {
            switch (PlayingCard.rankToString(self.rank)) {
            case "A": return 11;
            case "10": return 10;
            case "K": return 4;
            case "Q": return 3;
            case "J": return 2;
            default: return 0;
            }
        }
    }
    
    /* Returns the score required to rank the cards in hand by their game value. */
    var importance_score: Int {
        get {
            let mult: [Bool : Int] = [true : 8, false : 1];
            var result: Int;
            switch (PlayingCard.rankToString(self.rank)) {
            case "A": result = 70;
            case "10": result = 60;
            case "K": result = 7;
            case "Q": result = 6;
            case "J": result = 5;
            case "9": result = 4;
            case "8": result = 3;
            case "7": result = 2;
            case "6": result = 1;
            default: result = 0;
            }
            return result * mult[self.is_trump]!;
        }
    }
    
    
    
    init(rank: Int, suit: Suit) {
        super.init();
        
        if (rank < 0 || rank > 8) {
            fatalError("Rank must range from 0 to max_rank (inclusive)");
        }
        
        self.rank = rank;
        self.suit = suit;
    }
    
    
    
    override var contents: String {
        get {
            return PlayingCard.rankToString(self.rank) + PlayingCard.suitToString(self.suit);
        }
    }
    
    
    
    override class func rankToString(rank: Int) -> String {
        let rank_strings: [String] = ["6", "7", "8", "9", "J", "Q", "K", "10", "A"];
        return rank_strings[rank];
    }
    
    
    
    override class func suitToString(suit: Suit) -> String {
        let suit_strings: [Suit : String] = [Suit.CLUB : "♣︎",
                                             Suit.SPADE : "♠︎",
                                             Suit.DIAMOND : "♦︎",
                                             Suit.HEART : "♥︎"];
        return suit_strings[suit]!;
    }
    
    
    
    override class func getCardImgName(card: Card, format: String = "jpg") -> String {
        let suit_to_char: [Suit : String] = [Suit.CLUB : "C", Suit.DIAMOND : "D", Suit.HEART : "H", Suit.SPADE : "S"];
        let playing_card = card as! PlayingCard;
        return PlayingCard.rankToString(playing_card.rank) + suit_to_char[playing_card.suit]! + "." + format;
    }
    
    
    
    /* Returns true if the card can 'beat' the other card. */
    func canBeat(otherCard: PlayingCard) -> Bool {
        if self.is_trump! {
            if (otherCard.is_trump!) { return self.rank > otherCard.rank; }
            return true;
        } else {
            return self.suit == otherCard.suit && self.rank > otherCard.rank;
        }
    }
    
    
    
    class func toRaw(card: PlayingCard) -> (Int, Int) {
        return (card.rank, Suit.toRaw(card.suit));
    }
    
    
    
    class func fromRaw(raw_card: (Int, Int)) -> PlayingCard {
        let (rank, suit_index) = raw_card;
        return PlayingCard(rank: rank, suit: Suit.fromRaw(suit_index));
    }
}