//
//  HostViewControllerExtension.swift
//  TrustNotTrust
//
//  Created by Denys FRIDMAN on 3/21/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import Foundation
import MultipeerConnectivity




extension HostGameViewController {
    
    override func didChangeState(notification: NSNotification) {
        let info: Dictionary = notification.userInfo! as Dictionary
        let state: Int = info["state"]! as! Int
        let peer_id: MCPeerID = info["peerID"] as! MCPeerID;
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
            // disconnected
            self.disconnectedWithPeer(peer_id);
            break;
        default:
            break;
        }
    }
    
    
    
    override func connectedWithPeer(peer: MCPeerID) {
        super.connectedWithPeer(peer);
        self.players.append(peer);
        self.available_players_table.reloadData();
    }
    
    
    
    override func connectingToPeer(peer: MCPeerID) {
        super.connectingToPeer(peer);
    }
    
    
    
    override func disconnectedWithPeer(peer: MCPeerID) {
        super.disconnectedWithPeer(peer);
        self.removePeerID(peer);
        if (self.game_state == GameState.GAME_STARTED) {
            self.delegate?.ConnectionViewControllerDismissWithInfo(self, reason: QuitReason.CONNECTION_LOST);
        }
        if (self.players.isEmpty) {
            self.connection_state = ConnectionState.NOT_CONNECTED;
        }
        self.available_players_table.reloadData();
    }
}