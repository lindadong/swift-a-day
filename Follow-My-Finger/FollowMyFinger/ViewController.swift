//
//  ViewController.swift
//  FollowMyFinger
//
//  Created by Linda Dong on 9/1/15.
//  Copyright (c) 2015 Linda Dong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var leftPupil: UIImageView!
    @IBOutlet weak var rightPupil: UIImageView!
    
    func handleTouch(touch: UITouch, animated: Bool) {
        // Get the touch position
        let touchPosition = touch.locationInView(self.view)
        
        // Gets the eye's center
        let currentPositionL = leftPupil.frame.origin
        let currentPositionR = rightPupil.frame.origin
        
        // Calculates angle between touch position and the eyes
        let angleL = atan2(currentPositionL.y - touchPosition.y, currentPositionL.x - touchPosition.x)
        let angleR = atan2(currentPositionR.y - touchPosition.y, currentPositionR.x - touchPosition.x)
        
        // Perform or animate
        let operations = {
            self.leftPupil.transform = CGAffineTransformMakeRotation(angleL + CGFloat(M_PI/2))
            self.rightPupil.transform = CGAffineTransformMakeRotation(angleR + CGFloat(M_PI/2))
        }
        
        if animated {
            let duration: NSTimeInterval = 1.0
            let delay: NSTimeInterval = 0.0
            let damping: CGFloat = 0.3
            let animationVelocity: CGFloat = 0.5
            
            UIView.animateWithDuration(duration,
                delay: delay,
                usingSpringWithDamping: damping,
                initialSpringVelocity: animationVelocity,
                options: .CurveEaseInOut,
                animations: operations,
                completion: { success in })
        } else {
            operations()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        handleTouch(touch, animated: true)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        handleTouch(touch, animated: false)
    }
    
}

