//
//  JoinGameViewControllerExtension.swift
//  TrustNotTrust
//
//  Created by Denys FRIDMAN on 3/21/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import Foundation
import MultipeerConnectivity


extension JoinGameViewController {
    
    func foundPeer(notification: NSNotification) {
        let info = notification.userInfo as! [String : MCPeerID];
        let peer_id = info["peerID"]!;
        self.players.append(peer_id);
        self.available_players_table.reloadData();
    }
    
    
    
    func lostPeer(notification: NSNotification) {
        let info = notification.userInfo as! [String : MCPeerID];
        let peer_id = info["peerID"]!;
        self.removePeerID(peer_id);
        self.available_players_table.reloadData();
    }
    
    
    
    func failedBrowsing() {}
    
    
    
    override func didChangeState(notification: NSNotification) {
        let info = notification.userInfo! as Dictionary;
        let state = info["state"] as! Int;
        let peer_id = info["peerID"] as! MCPeerID;
        switch (state) {
        case 2:
            // connected
            self.connectedWithPeer(peer_id);
            break;
        case 1:
            // connecting
            self.connectingToPeer(peer_id);
            break;
        case 0:
            // disconnecting
            self.disconnectedWithPeer(peer_id);
            break;
        default:
            println("Error in didChangeState: unknown state encountered!");
            break;
        }
    }
    
    
    
    /* Receives a message from a 'host' player regarding the start of the game */
    func receivedData(notification: NSNotification) {
        let data: NSDictionary =  self.receiveData(notification);
        // In JoinViewController this method is only used for building a Game object
        let ranks: [Int] = data[RANKS] as! [Int];
        let suits: [Int] = data[SUITS] as! [Int];
        
        var cards = [(Int, Int)]();
        for i in 0..<ranks.count { cards.append((ranks[i], suits[i])); }
        
        var deck: PlayingDeck = PlayingDeck(cards: cards);
        var game: Game = Game(deck: deck, numberOfPlayers: 2);
        
        game.game_turn = 1 - game.game_turn;
        
        self.delegate?.dismissAndStartGameWithAppDelegate(self, game: game, appDelegate: self.appDelegate, isServer: false);
    }
    
    
    
    override func connectedWithPeer(peer: MCPeerID) {
        super.connectedWithPeer(peer);
        self.appDelegate.mpcHandler.stopBrowsing();
        self.prepareForGameStart();
    }
    
    
    
    override func connectingToPeer(peer: MCPeerID) {
        super.connectingToPeer(peer);
    }
    
    
    
    override func disconnectedWithPeer(peer: MCPeerID) {
        super.disconnectedWithPeer(peer);
        self.delegate?.ConnectionViewControllerDismissWithInfo(self, reason: QuitReason.CONNECTION_LOST);
    }
}