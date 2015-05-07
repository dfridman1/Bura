//
//  MultiplayerViewControllerExtension.swift
//  Bura
//
//  Created by Denys FRIDMAN on 4/18/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import Foundation
import MultipeerConnectivity




extension MultiplayerGameViewController {
    
    // Starts listening to notifications
    override func listenToNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didChangeState:", name: CHANGED_STATE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedData:", name: RECEIVED_DATA, object: nil)
    }
    
    
    
    func breakConnection() {
        self.appDelegate.mpcHandler.session?.disconnect();
        self.appDelegate.mpcHandler.session = nil;
    }
    
    
    
    
    func didChangeState(notification: NSNotification) {
        let info: Dictionary = notification.userInfo! as Dictionary
        let state: Int = info["state"]! as! Int
        let peer_id: MCPeerID = info["peerID"] as! MCPeerID;
        
        switch (state) {
        case 2:
            break;
        case 1:
            break;
        case 0:
            self.delegate.dismissMultiplayerGameViewController(self, reason: QuitReason.CONNECTION_LOST);
        default:
            return;
        }
    }
    
    
    
    func receivedData(notification: NSNotification) {
        let data: NSDictionary =  self.receiveData(notification);
        let message: String = data[MESSAGE] as! String;
        
        switch (message) {
        case RESPOND:
            self.respond(data);
            break;
        case HAND_DID_FINISH:
            self.opponentHasResponded(data);
            break;
        case PLAY_AGAIN_REQUEST:
            let server_name = data[SERVER_NAME] as! String;
            self.showPlayAgainRequestAlert(server_name);
            break;
        case CONFIRM_PLAY_AGAIN:
            self.sendAnotherMatchMessage();
            self.startNewGame(2);
            break;
        case START_ANOTHER_MATCH:
            self.buildGameObject(data);
            self.startNewGame(2);
            break;
        default:
            break;
        }
    }
    
    
    
    func respond(data: NSDictionary) {
        self.waiting_label.hidden = true;
        
        self.updateCardsInPlay(data);
        
        var timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(2 * CARDS_ANIMATION_DURATION, target: self, selector: "unblockHand", userInfo: nil, repeats: false);
    }
    
    
    
    func opponentHasResponded(data: NSDictionary) {
        self.updateCardsInPlay(data);
        
        var timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(4 * CARDS_ANIMATION_DURATION, target: self, selector: "handDidFinish", userInfo: nil, repeats: false);
    }
    
    
    
    func updateCardsInPlay(data: NSDictionary) {
        let suits = data[SUITS] as! [Int];
        let ranks = data[RANKS] as! [Int];
        
        var raw_cards = [(Int, Int)]();
        for i in 0..<suits.count { raw_cards.append((ranks[i], suits[i])); }
        
        var cards = Map({ raw_card in PlayingCard.fromRaw(raw_card) }, raw_cards);
        
        for card in cards {
            card.is_trump = (card.suit == self.game.deck.trump_card.suit);
            
            // add to cards_in_play
            self.game.players[1].addToCardsInPlay(card);
            
            let card_button = self.getButtonForCard(card);
            card_button.setFace(card);
            self.makeCardMove(card_button, moveUp: true, isOpponent: true);
        }
    }
    
    
    
    /* Builds a NEW game object from the info passed by the server */
    func  buildGameObject(data: NSDictionary) {
        let ranks = data[RANKS] as! [Int];
        let suits = data[SUITS] as! [Int];
        
        var cards = [(Int, Int)]();
        for i in 0..<ranks.count { cards.append((ranks[i], suits[i])); }
        
        var deck = PlayingDeck(cards: cards);
        self.game = Game(deck: deck, numberOfPlayers: 2);
        self.game.game_turn = 1 - self.game.game_turn;
    }
    
    
    
    func sendHandDidFinishMessage() {
        // inform opponent that we have responded to the move initiated by him
        
        let cards_in_play: [(Int, Int)] = Map({ card in PlayingCard.toRaw(card) }, self.game.players[0].cards_in_play);
        let suits: [Int] = Map({ card in card.1 }, cards_in_play);
        let ranks: [Int] = Map({ card in card.0 }, cards_in_play);
        
        let data_to_send = [MESSAGE : HAND_DID_FINISH, SUITS : suits, RANKS : ranks];
        let connected_peers = self.appDelegate.mpcHandler.session.connectedPeers as! [MCPeerID];
                
        self.sendData(data_to_send as NSDictionary, peers: connected_peers);
    }
    
    
    
    /* Server sends to its peers request to play again */
    func sendPlayAgainRequest() {
        let data_to_send = [MESSAGE : PLAY_AGAIN_REQUEST, SERVER_NAME : UIDevice.currentDevice().name];
        let connected_peers = self.appDelegate.mpcHandler.session.connectedPeers as! [MCPeerID];
        
        self.sendData(data_to_send, peers: connected_peers);
    }
    
    
    /* Player (Non-server) sends a confirmation to the server regarding another match */
    func sendConfirmPlayAgain() {
        let data_to_send = [MESSAGE : CONFIRM_PLAY_AGAIN];
        let connected_peers = self.appDelegate.mpcHandler.session.connectedPeers as! [MCPeerID];
        
        self.sendData(data_to_send, peers: connected_peers);
    }
    
    
    
    /* Initializes a Game object and sends message about the start of the new match to connected peers */
    func sendAnotherMatchMessage() {
        self.game = Game();
        var raw_deck: [(Int, Int)] = PlayingDeck.rawDeck(self.game.deck);
        
        var ranks = Map({ raw_card in raw_card.0 }, raw_deck);
        var suits = Map({ raw_card in raw_card.1 }, raw_deck);
        
        let data_to_send = [MESSAGE : START_ANOTHER_MATCH, SUITS : suits, RANKS : ranks];
        let connected_peers = self.appDelegate.mpcHandler.session.connectedPeers as! [MCPeerID];
        
        self.sendData(data_to_send, peers: connected_peers);
    }
    
    
    
    /* Sends data (passed-in as a NSDictionary) to the specified peers. */
    func sendData(dict: NSDictionary, peers: [MCPeerID]) {
        //sends dictionary to the connected peers
        var dataToSend: NSData! = NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted, error: nil);
        var error: NSError?;
        self.appDelegate.mpcHandler.session.sendData(dataToSend, toPeers: peers, withMode: MCSessionSendDataMode.Reliable, error: &error);
        
        if (error != nil) {
        }
    }
    
    
    
    /* Receives data and returns it as NSDictionary. */
    func receiveData(notification: NSNotification) -> NSDictionary {
        //turns received data ("userInfo") into a readable object NSDictionary.
        var info: NSDictionary = notification.userInfo! as NSDictionary;
        var data: NSData = info["data"] as! NSData;
        var jsonData: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary;
        
        return jsonData;
    }
}