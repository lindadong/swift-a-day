//
//  GameViewController.swift
//  Torus
//
//  Created by Linda Dong on 9/8/15.
//  Copyright (c) 2015 Linda Dong. All rights reserved.
//

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

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene()
        
        // Make Torus
        let torusMaterial = SCNMaterial()
        torusMaterial.diffuse.contents = UIColor.whiteColor()
        torusMaterial.specular.contents = UIColor.whiteColor()
        
        let torusGeometry = SCNTorus(ringRadius:3.8, pipeRadius: 2.0)
        torusGeometry.materials = [torusMaterial]
        let torusNode = SCNNode(geometry: torusGeometry)
        scene.rootNode.addChildNode(torusNode)
        
        // Make Floor
        let floor = SCNFloor()
        floor.firstMaterial?.emission.contents = UIColor(netHex: 0xc78eb2)
        floor.reflectivity = 1.0
        floor.reflectionResolutionScaleFactor = 1.0
        floor.reflectionFalloffStart = 0
        floor.reflectionFalloffEnd = 5.0
        let floorNode = SCNNode(geometry: floor)
        floorNode.position.y = -6.1
        scene.rootNode.addChildNode(floorNode)
        
        // Create Camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        scene.rootNode.addChildNode(cameraNode)

        // Create Omni Light
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.light!.color = UIColor.yellowColor()
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)

        // Create Ambient Light
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.purpleColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        let scnView = self.view as! SCNView
        scnView.scene = scene
        scnView.showsStatistics = false
        scnView.allowsCameraControl = false
        
        scnView.backgroundColor = UIColor(netHex: 0xffb0cc)
        
        // Animate Torus
        torusNode.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(2, y: 0, z: 2, duration: 1)))
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
//    override func supportedInterfaceOrientations() -> Int {
//        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
//            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
//        } else {
//            return Int(UIInterfaceOrientationMask.All.rawValue)
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
