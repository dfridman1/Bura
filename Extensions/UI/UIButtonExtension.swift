//
//  UIButtonExtension.swift
//  TrustNotTrust
//
//  Created by Denys FRIDMAN on 3/21/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import UIKit

extension UIButton {
    
    // Moves button so that its center is at (x, y).
    func moveTo(x: CGFloat, y: CGFloat) {
        self.center = CGPointMake(x, y);
    }
    
    
    
    func moveToAnimate(x: CGFloat, y: CGFloat, animation_duration: NSTimeInterval, completion: ((Bool) -> Void)? = nil) {
        UIView.animateWithDuration(animation_duration, animations: { self.moveTo(x, y: y) }, completion: completion);
    }
    
    
    
    /* Moves button by dx in x-direction and dy in y-direction. */
    func moveBy(dx: CGFloat, dy: CGFloat) {
        let x: CGFloat = self.center.x;
        let y: CGFloat = self.center.y;
        self.center = CGPointMake(x + dx, y + dy);
    }
    
    
    
    /* Rotates button by the specified degree. */
    func rotate(degrees: CGFloat) {
        self.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) * degrees / 180);
    }
    
    
    
    /* Rotates button by the random degree whose absolute value does not exceed max_degree. */
    func rotateByRandomDegree(max_degree: CGFloat) {
        var random_sign: Int = Int(randomFloat() + 0.5);   // randomFloat is defined in Utils.swift
        var random_degree: CGFloat = randomFloat() * max_degree;
        if (random_sign == 0) {
            random_degree *= -1;
        }
        self.rotate(random_degree);
    }
    
    
    
    /* Rotation animation. */
    func rotateAndAnimate(max_degree: CGFloat, animation_duration: NSTimeInterval) {
        UIView.animateWithDuration(animation_duration, animations: { () -> Void in
            self.rotateByRandomDegree(max_degree);
        })
    }
    
    
    
    /* Sets shirt as a background image. */
    func setShirt() {
        self.setBackgroundImage(SHIRT_IMG, forState: UIControlState.Normal);
    }
    
    
    
    /* Sets face of the card to be its background image. */
    func setFace(card: Card) {
        let image: UIImage! = UIImage(named: PlayingCard.getCardImgName(card));
        self.setBackgroundImage(image, forState: UIControlState.Normal);
    }
    
    
    
    /* Enables button. */
    func enable() {
        self.enabled = true;
    }
    
    
    
    /* Disables button. */
    func disable() {
        self.enabled = false;
    }
    
    
    
    /* Creates a card button. */
    class func makeCardButton() -> UIButton {
        var res: UIButton = UIButton(frame: CGRectMake(0, 0, CARDBUTTON_WIDTH, CARDBUTTON_HEIGHT));
        res.setShirt();
        res.layer.borderWidth = 0.25;
        res.layer.borderColor = UIColor.lightGrayColor().CGColor;
        res.adjustsImageWhenHighlighted = false;
        res.adjustsImageWhenDisabled = false;
        return res;
    }
}