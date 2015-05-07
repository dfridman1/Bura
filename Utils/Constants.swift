//
//  Constants.swift
//  TrustNotTrust
//
//  Created by Denys FRIDMAN on 3/19/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//


import UIKit



// UI
let WIDTH: CGFloat = UIScreen.mainScreen().bounds.size.width;
let HEIGHT: CGFloat = UIScreen.mainScreen().bounds.size.height;
let BACKGROUND_IMG: UIImage = resizeImage(UIImage(named: "green_back.png")!, CGSizeMake(0.5 * WIDTH, 0.5 * HEIGHT));
let SHIRT_IMG: UIImage = UIImage(named: "shirt.png")!;

// Game UI
let CARDBUTTON_WIDTH: CGFloat = 0.1 * WIDTH;
let CARDBUTTON_HEIGHT: CGFloat = 0.256 * HEIGHT;
let CARDS_ANIMATION_DURATION: NSTimeInterval = 0.375;


// Game
let MAX_NUMBER_OF_PLAYERS = 1;
let MESSAGE = "MESSAGE";
//let GAME_INITIALIZATION = "INITIALIZATION";
//let GAME_STARTED = "GAME STARTED";
let SUITS = "SUITS";
let RANKS = "RANKS";
let RESPOND = "RESPOND";
let HAND_DID_FINISH = "HAND_DID_FINISH";
let PLAY_AGAIN_REQUEST = "PLAY_AGAIN_REQUEST";
let SERVER_NAME = "SERVER_NAME";
let CONFIRM_PLAY_AGAIN = "CONFIRM_PLAY_AGAIN";
let START_ANOTHER_MATCH = "START_ANOTHER_MATCH";


// Networking
let SERVICE_TYPE = "BURA";
let DID_NOT_START_BROWSING = "MPC_didNotStartBrowsing";
let DID_NOT_START_ADVERTISING = "MPC_didNotStartAdvertising";
let FOUND_PEER = "MPC_foundPeer";
let LOST_PEER = "MPC_lostPeer";
let CHANGED_STATE = "MPC_didChangeStateNotification";
let RECEIVED_DATA = "MPC_didReceiveData";
let RECEIVED_INVITATION = "MPC_ReceivedInvitation";


// General
let ENTERED_BACKGROUND = "ENTERED_BACKGROUND";