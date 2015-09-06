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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch:UITouch = touches.first as? UITouch {
            
            var touchPosition = touch.locationInView(self.view)
            
            // Gets the eye's center
            let currentPositionL = leftPupil.frame.origin
            let currentPositionR = rightPupil.frame.origin
            
            // Calculates angle between touch position and the eyes
            var angleL = atan2(currentPositionL.y - touchPosition.y, currentPositionL.x - touchPosition.x)
            var angleR = atan2(currentPositionR.y - touchPosition.y, currentPositionR.x - touchPosition.x)
            
            let duration : NSTimeInterval = 1.0
            let delay :NSTimeInterval = 1.0
            let damping : CGFloat = 0.3
            let animationVelocity : CGFloat = 0.5
            
            // usingSpringWithDamping
            UIView.animateWithDuration(duration,
                delay: 0.0,
                usingSpringWithDamping: damping,
                initialSpringVelocity: animationVelocity,
                options: .CurveEaseInOut, 
                animations: {
                    self.leftPupil.transform = CGAffineTransformMakeRotation(angleL + CGFloat(M_PI/2))
                    self.rightPupil.transform = CGAffineTransformMakeRotation(angleR + CGFloat(M_PI/2))
                },
                completion: {success in })
            
            
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch:UITouch = touches.first as? UITouch {
            
            var touchPosition = touch.locationInView(self.view)
            
            let currentPositionL = leftPupil.frame.origin
            let currentPositionR = rightPupil.frame.origin
            
            var angleL = atan2(currentPositionL.y - touchPosition.y, currentPositionL.x - touchPosition.x)
            var angleR = atan2(currentPositionR.y - touchPosition.y, currentPositionR.x - touchPosition.x)
            
            leftPupil.transform = CGAffineTransformMakeRotation(angleL + CGFloat(M_PI/2))
            rightPupil.transform = CGAffineTransformMakeRotation(angleR + CGFloat(M_PI/2))
            
            
        }
    }


}

