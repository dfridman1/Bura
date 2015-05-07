//
//  ConnectionViewControllerExtension.swift
//  TrustNotTrust
//
//  Created by Denys FRIDMAN on 3/21/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import Foundation
import MultipeerConnectivity




/* ConnectionViewController extension is responsible for listening to networking notifications and
 * handling the disconnection appropriately */


extension ConnectionViewController {
    
    // Starts listening to networking notifications
    func listenToNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didChangeState:", name: CHANGED_STATE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedData:", name: RECEIVED_DATA, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "failedBrowsing", name: DID_NOT_START_BROWSING, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "failedAdvertising", name: DID_NOT_START_ADVERTISING, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "foundPeer:", name: FOUND_PEER, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "lostPeer:", name: LOST_PEER, object: nil)
    }
    
    
    
    // Stops advertising/browsing and disconnects from the session (if connected)
    func breakConnection() {
        self.appDelegate.mpcHandler.session?.disconnect();
        self.appDelegate.mpcHandler.advertiseSelf(false);
        self.appDelegate.mpcHandler.stopBrowsing();
        self.appDelegate.mpcHandler.session = nil;
    }
    
    
    
    // Abstract method. Implements behaviour when state of connection changes.
    func didChangeState(notification: NSNotification) {}
    
    
    
    // Removes a peer id from the available_peers list.
    func removePeerID(peerID: MCPeerID) {
        if let index = find(self.players, peerID) {
            self.players.removeAtIndex(index);
        }
    }
    
    
    
    func connectedWithPeer(peer: MCPeerID) {
        self.connection_state = ConnectionState.CONNECTED;
    }
    
    
    
    func connectingToPeer(peer: MCPeerID) {
        self.connection_state = ConnectionState.CONNECTING;
    }
    
    
    
    func disconnectedWithPeer(peer: MCPeerID) {
        self.connection_state = ConnectionState.NOT_CONNECTED;
    }
    
    
    
    // Sends data (passed-in as a NSDictionary) to the specified peers.
    func sendData(dict: NSDictionary, peers: [MCPeerID]) {
        //sends dictionary to the connected peers
        var dataToSend: NSData! = NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted, error: nil);
        var error: NSError?;
        self.appDelegate.mpcHandler.session.sendData(dataToSend, toPeers: peers, withMode: MCSessionSendDataMode.Reliable, error: &error);
        
        if (error != nil) {
        }
    }
    
    
    
    // Receives data and returns it as NSDictionary.
    func receiveData(notification: NSNotification) -> NSDictionary {
        //turns received data ("userInfo") into a readable object NSDictionary.
        var info: NSDictionary = notification.userInfo! as NSDictionary;
        var data: NSData = info["data"] as! NSData;
        var jsonData: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary;
        
        return jsonData;
    }
}