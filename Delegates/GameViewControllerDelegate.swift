//
//  GameViewControllerDelegate.swift
//  Bura
//
//  Created by Denys FRIDMAN on 4/8/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import Foundation


protocol SingleGameViewControllerDelegate {
    
    /* Handles the dismissing of the SingleGameViewController. NOTE: the game object is
     * passed back on to the ViewController to allow the user to resume the game */
    func SingleGameViewControllerDismiss(controller: GameViewController, game: Game?);
}