//
//  ViewController.swift
//  Mask
//
//  Created by Linda Dong on 9/29/15.
//  Copyright (c) 2015 Linda Dong. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    @IBOutlet weak var maskedView: UIView!
    @IBOutlet weak var bacteriaView: UIView!
    
    let circleLayer = CAShapeLayer()
    var radius : CGFloat = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var frame = self.maskedView.frame
        
        //Draws Circle
        var path = UIBezierPath(roundedRect: CGRectMake(0,0, radius * 2, radius * 2), cornerRadius: radius)
        circleLayer.path = path.CGPath
        
        circleLayer.lineWidth = 20.0
        circleLayer.strokeColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).CGColor
        circleLayer.fillColor = UIColor.whiteColor().CGColor
        circleLayer.position = CGPointMake(frame.width/2 - radius, frame.height/2 - radius)
        circleLayer.transform = CATransform3DMakeScale(0, 0, 0) // Set initial scale to 0
        circleLayer.bounds = CGRectMake(0,0, radius * 2, radius * 2) // So animations scale from the center
        
        //Applies circle as mask
        maskedView.layer.mask = circleLayer
        
        //Applies wiggle to bacteria
        for bacteria in bacteriaView.subviews {
            
            let randomWiggle = CGFloat(arc4random())/CGFloat(UInt32.max) + 0.1
            let randomDuration = CGFloat(arc4random())/CGFloat(UInt32.max) + 0.1
            
            var transform:CATransform3D = CATransform3DMakeRotation(randomWiggle, 0, 0, 1.0);
            var animation:CABasicAnimation = CABasicAnimation(keyPath: "transform");
            animation.toValue = NSValue(CATransform3D: transform);
            animation.autoreverses = true;
            animation.duration = CFTimeInterval(randomDuration);
            animation.repeatCount = 10000;
            animation.delegate=self;
            bacteria.layer.addAnimation(animation, forKey: "wiggleAnimation");
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch:UITouch = touches.first as? UITouch {
            
            var touchPosition = touch.locationInView(self.view)
            
            //Sets mask to touchPosition (Need CATransactions to remove defualt animation)
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            self.circleLayer.position = touchPosition
            CATransaction.commit()
            
            //Scales up the mask
            let scaleAnimate:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimate.fromValue = 0
            circleLayer.transform = CATransform3DMakeScale(1, 1, 1) //So the layer doesn't disappear afterwards
            scaleAnimate.toValue = 1
            scaleAnimate.duration = 0.4
            scaleAnimate.delegate = self
            scaleAnimate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            self.circleLayer.addAnimation(scaleAnimate, forKey: "scaleUpAnimation")
            
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch:UITouch = touches.first as? UITouch {
            
            var touchPosition = touch.locationInView(self.view)
            
            //Sets mask to touchPosition (Need CATransactions to remove defualt animation)
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            self.circleLayer.position = touchPosition
            CATransaction.commit()
            
            
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        //Scales the mask down
        let scaleAnimate:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimate.fromValue = 1
        circleLayer.transform = CATransform3DMakeScale(0, 0, 0)
        scaleAnimate.toValue = 0
        scaleAnimate.duration = 0.2
        scaleAnimate.delegate = self
        scaleAnimate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.circleLayer.addAnimation(scaleAnimate, forKey: "scaleDownAnimation")
        
    }

    
    


}

