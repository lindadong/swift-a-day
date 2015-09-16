//
//  ViewController.swift
//  HexDrop
//
//  Created by Linda Dong on 9/15/15.
//  Copyright (c) 2015 Linda Dong. All rights reserved.
//

import UIKit

// Hex Color Convenience Function
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
    
    @IBOutlet weak var growView: UIImageView!
    @IBOutlet weak var dragView: UIImageView!
    @IBOutlet weak var plusView: UIImageView!
    
    var dragOrigin: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dragOrigin = dragView.center
        dragView.image = dragView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate) //tint color
        plusView.alpha = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        
        //Drag the View
        var translation = recognizer.translationInView(self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                y:view.center.y + translation.y)
            view.layer.zPosition = 1
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
        
        //Calculates the distance between the two views
        var touchPosition : CGPoint = recognizer.locationInView(self.view)
        let viewPosition = growView.center
        
        var xDist : CGFloat = (touchPosition.x - viewPosition.x)
        var yDist : CGFloat = (touchPosition.y - viewPosition.y)
        var distance = sqrt((xDist * xDist) + (yDist * yDist))
        
        //This is how I map the distance between the two views to the scale factor. Going from 0 to 460 (min and max distance on the screen) to a scale factor from 1 to 2.
        let oldMax : CGFloat = 460
        let oldMin : CGFloat = 0
        let newMax : CGFloat = 2
        let newMin : CGFloat = 1
        var oldRange = (oldMax - oldMin)
        var newRange = (newMax - newMin)
        var newValue = (((distance - oldMin) * newRange) / oldRange) + newMin
        var scaleFactor = 3 - newValue //So it grows larger instead of smaller
        
        //Alpha factor for plus label
        var alphaFactor = 1 - (newValue - 1.5)
        
        //Adding min and max thresholds to stop scaling the view at a certain size
        let thresholdMin : CGFloat = 1.1
        let thresholdMax : CGFloat = 1.5
        
        if scaleFactor > thresholdMax {
            scaleFactor = thresholdMax
        }
        if scaleFactor < thresholdMin {
            scaleFactor = thresholdMin
        }
        
        //Panning state actions
        if recognizer.state == .Began {
            UIView.animateWithDuration(
                0.2,
                delay: 0,
                options: .CurveEaseInOut,
                animations: {
                    self.growView.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
                    self.dragView.tintColor = UIColor(netHex: 0xffffff)
                    self.plusView.alpha = 0.6
                },
                completion: {success in
            })
            
        }
        
        if recognizer.state == .Changed {
            growView.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
            plusView.alpha = alphaFactor
        }
        
        if recognizer.state == .Ended {
            //Snaps to point if close enough
            if scaleFactor >= thresholdMax {
                UIView.animateWithDuration(
                    0.25,
                    delay: 0,
                    options: .CurveEaseInOut,
                    animations: {
                        self.dragView.transform = CGAffineTransformMakeTranslation(self.growView.center.x - self.dragView.center.x, self.growView.center.y - self.dragView.center.y)
                    },
                    completion: {finished in
                })
                UIView.animateWithDuration(
                    0.18,
                    delay: 0.22,
                    options: .CurveEaseInOut,
                    animations: {
                        self.dragView.tintColor = UIColor(netHex: 0xdeff00)
                        self.growView.transform = CGAffineTransformMakeScale(1.1, 1.1)
                        
                    },
                    completion: {finished in})
                
            }
            //Others goes back to starting position
            else {
                UIView.animateWithDuration(
                    0.25,
                    delay: 0,
                    options: .CurveEaseInOut,
                    animations: {
                        self.dragView.transform = CGAffineTransformMakeTranslation(self.dragOrigin.x - self.dragView.center.x, self.dragOrigin.y - self.dragView.center.y)
                        self.growView.transform = CGAffineTransformMakeScale(1, 1)
                        self.plusView.alpha = 0
                        
                    },
                    completion: {success in})
            }
            
        }
        
    }
    
}

