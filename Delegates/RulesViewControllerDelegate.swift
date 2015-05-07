//
//  RulesViewControllerDelegate.swift
//  Bura
//
//  Created by Denys FRIDMAN on 4/21/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import Foundation


protocol RulesViewControllerDelegate {
    
    /* Handles the dismissing of the RulesViewController */
    func rulesViewControllerDidDismiss(controller: RulesViewController);
}