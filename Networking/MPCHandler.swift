//
//  MPCHandler.swift
//  TrustNotTrust
//
//  Created by Denys FRIDMAN on 3/19/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import UIKit
import MultipeerConnectivity







class MPCHandler: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
    
    var peerID: MCPeerID!;
    
    var session: MCSession!;
    
    var browser: MCNearbyServiceBrowser?;
    
    var advertiser: MCNearbyServiceAdvertiser?;
    
    /* Keeps track of the number of connected players to the game.
     * Applicable to the advertiser only. */
    var num_of_connected_peers: Int = 0;
    
    
    
    func setupPeerIDwithDisplayName(displayName: String) {
        self.peerID = MCPeerID(displayName: displayName);
    }
    
    
    
    func setupSessionWithPeerID(peerID: MCPeerID) {
        self.session = MCSession(peer: peerID);
        self.session.delegate = self;
    }
    
    
    
    func startBrowsing() {
        self.browser = MCNearbyServiceBrowser(peer: self.peerID!, serviceType: SERVICE_TYPE);
        self.browser?.delegate = self;
        self.browser?.startBrowsingForPeers();
    }
    
    
    
    func stopBrowsing() {
        self.browser?.stopBrowsingForPeers();
        self.browser = nil;
    }
    
    
    
    func advertiseSelf(advertise: Bool) {
        if advertise {
            self.advertiser = MCNearbyServiceAdvertiser(peer: self.peerID!, discoveryInfo: nil, serviceType: SERVICE_TYPE);
            self.advertiser!.delegate = self;
            self.advertiser!.startAdvertisingPeer();
        }
        else {
            self.advertiser?.stopAdvertisingPeer();
            self.advertiser = nil;
        }
    }
    
    
    
    
    
// mark: MCNearbyServiceAdvertiserDelegate
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didNotStartAdvertisingPeer error: NSError!) {
        NSNotificationCenter.defaultCenter().postNotificationName(DID_NOT_START_ADVERTISING, object: nil);
    }
    
    
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        
        if self.session == nil {
            self.setupSessionWithPeerID(self.peerID)
        }
        invitationHandler(self.num_of_connected_peers < MAX_NUMBER_OF_PLAYERS, self.session)
    }
    
    
    
    
    
// mark: MCNearbyServiceBrowserDelegate
    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        NSNotificationCenter.defaultCenter().postNotificationName(DID_NOT_START_BROWSING, object: nil)
    }
    
    
    
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        var userInfo = ["peerID": peerID]
        
        NSNotificationCenter.defaultCenter().postNotificationName(FOUND_PEER, object: nil, userInfo: userInfo)
    }
    
    
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        var userInfo = ["peerID": peerID]
        
        NSNotificationCenter.defaultCenter().postNotificationName(LOST_PEER, object: nil, userInfo: userInfo)
    }
    
    

    
    
// mark: MCSessionDelegate
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        var userInfo = ["peerID": peerID, "state": state.rawValue]
        dispatch_sync(dispatch_get_main_queue(), { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName(CHANGED_STATE, object: nil, userInfo: userInfo)
        })
    }
    
    
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        var userInfo = ["peerID": peerID, "data": data]
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName(RECEIVED_DATA, object: nil, userInfo: userInfo)
        })
    }
    
    
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        
    }
    
    
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        
    }
    
    
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        
    }
}