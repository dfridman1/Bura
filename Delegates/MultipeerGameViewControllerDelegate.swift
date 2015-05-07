//
//  MultipeerGameViewControllerDelegate.swift
//  Bura
//
//  Created by Denys FRIDMAN on 4/19/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import Foundation



protocol MultiplayerGameViewControllerDelegate {
    
    /* Handles the dismissing of the MultiplayerGameViewController and possible disconnection alerts */
    func dismissMultiplayerGameViewController(controller: MultiplayerGameViewController, reason: QuitReason);
}