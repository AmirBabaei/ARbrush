//
//  ViewController.swift
//  AR Drawing
//
//  Created by Amir Babaei on 11/8/17.
//  Copyright © 2017 Amir Babaei. All rights reserved.
//

import UIKit
import ARKit
class ViewController: UIViewController, ARSCNViewDelegate {

  @IBOutlet weak var draw: UIButton!
  
  @IBOutlet weak var sceneView: ARSCNView!
  let configuration = ARWorldTrackingConfiguration()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
    self.sceneView.showsStatistics = true
    self.sceneView.session.run(configuration)
    self.sceneView.delegate = self
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //renderring function
  func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
    
    //get the position of the camera
    guard let pointOfView = sceneView.pointOfView else {return}
    let transform =  pointOfView.transform
    let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
    let location = SCNVector3(transform.m41,transform.m42,transform.m43)
    let currentPositionOfCamera =  orientation + location
    DispatchQueue.main.async {
      if self.draw.isHighlighted{
        let spherNode = SCNNode(geometry: SCNSphere(radius: 0.02))
        spherNode.position = currentPositionOfCamera
        self.sceneView.scene.rootNode.addChildNode(spherNode)
        spherNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
      } else {
        
        let pointer = SCNNode(geometry: SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 1/2))
        pointer.position = currentPositionOfCamera
        self.sceneView.scene.rootNode.addChildNode(pointer)
        //remove the extra spheres
        self.sceneView.scene.rootNode.enumerateChildNodes({(node, _) in
          if node.geometry is SCNBox{
          node.removeFromParentNode()
          }
        })
        self.sceneView.scene.rootNode.addChildNode(pointer)
        pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
      }
    }
  }

}
// "+" operation for SCNVector3
func +(left: SCNVector3, right: SCNVector3)-> SCNVector3 {
  return SCNVector3Make(left.x + right.x, left.y + right.y, right.z + left.z)
}
