//
//  ConnectionViewControllerDelegate.swift
//  TrustNotTrust
//
//  Created by Denys FRIDMAN on 3/19/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import Foundation




protocol ConnectionViewControllerDelegate {
    
    /* Handles the dismissing of the ConnectionViewController */
    func ConnectionViewControllerDismissWithInfo(controller: ConnectionViewController, reason: QuitReason);
    
    /* Handles the dismissing of the ConnectionViewController and starting a new game */
    func dismissAndStartGameWithAppDelegate(controller: ConnectionViewController, game: Game, appDelegate: AppDelegate, isServer: Bool);
}