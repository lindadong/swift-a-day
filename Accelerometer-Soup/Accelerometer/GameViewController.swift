//
//  GameViewController.swift
//  Accelerometer
//
//  Created by Linda Dong on 5/26/15.
//  Copyright (c) 2015 Linda Dong. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        guard let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") else {
            return nil
        }
        
        guard let sceneData = try? NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe) else {
            return nil
        }
        
        let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
        archiver.finishDecoding()
        
        return scene
    }
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene else {
            return
        }
        
        // Configure the view.
        let skView = self.view as! SKView
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//        skView.showsPhysics = false

        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .ResizeFill
        scene.size = skView.bounds.size
        
        skView.presentScene(scene)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
