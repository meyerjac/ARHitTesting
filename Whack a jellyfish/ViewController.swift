////
//  ViewController.swift
//  Whack a jellyfish
//
//  Created by Jackson Meyer
//  Copyright © 2017 Rayan Slim. All rights reserved.
//

import UIKit
import ARKit


class ViewController: UIViewController {
    
    var timer = Timer()
    
    var time = 10
    
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var SceneView: ARSCNView!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.SceneView.session.run(configuration)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.SceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func play(_ sender: Any) {
       timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.countDown), userInfo: nil, repeats: true)
        self.addNode()
        self.play.isEnabled = false
    }
    
    @IBAction func reset(_ sender: Any) {
    }
    
    func addNode() {
        let jellyFishScene = SCNScene(named: "art.scnassets/Jellyfish.scn")
        let jellyfishNode = jellyFishScene?.rootNode.childNode(withName: "Jellyfish", recursively: false)
        jellyfishNode?.position = SCNVector3(randomNumbers(firstNum: -1, secondNum: 1),randomNumbers(firstNum: -0.5, secondNum: 0.5), randomNumbers(firstNum: -1, secondNum: 1))
        self.SceneView.scene.rootNode.addChildNode(jellyfishNode!)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        if hitTest.isEmpty {
            print("didn't touch anything")
        } else {
            let results = hitTest.first!
            let node = results.node
            if node.animationKeys.isEmpty {
                SCNTransaction.begin()
                self.animateNode(node: node)
                SCNTransaction.completionBlock = {
                    node.removeFromParentNode()
                    self.addNode()
                }
                SCNTransaction.commit()
                }
            }
        }
    
    func animateNode(node: SCNNode) {
        let spin = CABasicAnimation(keyPath: "position")
        spin.fromValue = node.presentation.position
        spin.toValue = SCNVector3(node.presentation.position.z - 0.2, node.presentation.position.y - 0.2 , node.presentation.position.z - 0.2)
        spin.duration = 0.1
        spin.repeatCount = 5
        spin.autoreverses = true
        node.addAnimation(spin, forKey: "position")
    }
    
    func randomNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    @objc func countDown() {
        
        let timeRemaining = timeRemainingLabel.text
        
        let timeRemainingInteger = Int(timeRemaining!)! - 1
        
        timeRemainingLabel.text = String(timeRemainingInteger)
        
        if timeRemainingInteger == 0 {
            timer.invalidate()
            //play a cool ringtonw
        }
    }
}




