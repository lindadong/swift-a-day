//
//  ViewController.swift
//  Snap
//
//  Created by Linda Dong on 9/5/15.
//  Copyright (c) 2015 Linda Dong. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}


class ViewController: UIViewController {
    
    var squareView: UIView!
    var snap: UISnapBehavior!
    var animator: UIDynamicAnimator!
    var behavior: UIDynamicBehavior!
    var subviews = [UIView]()
    var count : CGFloat = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(netHex: 0x0a2038)
        let shapeCount = 12
        for i in 0..<shapeCount {
            
            count *= 1.7
            var width = 40 * CGFloat(i) + count
            var height = width
            
            squareView = UIView(frame: CGRect(x: view.center.x - width/2, y: view.center.y - height/2, width: width, height: height))
            squareView.backgroundColor = UIColor.clearColor()
            
            if i > 0 { squareView.layer.borderWidth = 2 }
            else { squareView.layer.borderWidth = 0}
            
            squareView.layer.borderColor = UIColor(netHex: 0x88f85c).CGColor
            squareView.alpha = 0.1 * CGFloat(shapeCount - i)
            
            squareView.layer.shouldRasterize = true
            squareView.layer.rasterizationScale = 1
            squareView.layer.shadowColor = UIColor.yellowColor().CGColor
            squareView.layer.shadowOffset = CGSize(width: 0, height: 0)
            squareView.layer.shadowOpacity = 1.0
            squareView.layer.shadowRadius = 3
            
            view.addSubview(squareView)
            subviews.append(squareView)
        }
        
        println(subviews)
        animator = UIDynamicAnimator(referenceView: view)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleTap(sender: UITapGestureRecognizer) {
        
        let tapPoint: CGPoint = sender.locationInView(view)
        
        self.animator.removeAllBehaviors()
        
        for i in 0..<subviews.count {
            var index = subviews[i]
            
            let snapBehavior = UISnapBehavior(item: index, snapToPoint: tapPoint)
            let random = arc4random_uniform(1000)
            snapBehavior.damping = 0.7
            
            let seconds = Double(i)/2 * 0.1
            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
            var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.animator.addBehavior(snapBehavior)
            })
        }
    }
    

    

    
}