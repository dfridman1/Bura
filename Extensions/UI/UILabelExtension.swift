//
//  UILabelExtension.swift
//  Bura
//
//  Created by Denys FRIDMAN on 4/13/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import UIKit




extension UILabel {
    
    func moveTo(#x: CGFloat, y: CGFloat) {
        let loc = CGPointMake(x, y);
        
        self.center = loc;
    }
    
    
    
    func rotate(#angle: CGFloat) {
        self.transform = CGAffineTransformMakeRotation(angle);
    }
}