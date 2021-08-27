//
//  SKScene.swift
//
//  Copyright © 2021 Ric Wright. All rights reserved.
//

import UIKit
import SceneKit

//-----------------------------------------------------------------------------

class SKScene: SCNScene, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    
    private var _baseNode: BaseNode?
 
    /*
     * Perform any creation tasks needed.
     */
    func create() {

        addBaseNode()
    }
    
    /*
     * Create and add the base node which is the root node of the whole thing
     */
    private func addBaseNode() {
        _baseNode = BaseNode()
        self.rootNode.addChildNode(_baseNode!)
        
        // dumpSCNNode(node: self.rootNode)
    }
    
    /*
     * Override the init to perform our initialisation
     */
    override init() {
        super.init()
        
        
        // Camera Node
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 20)
        cameraNode.camera!.zNear = 0.1
        cameraNode.camera!.zFar = 200
        self.rootNode.addChildNode(cameraNode)

        /*
        // Create a spotlight at the player
        let spotLight = SCNLight()
        spotLight.type = SCNLight.LightType.spot
        spotLight.spotInnerAngle = 40.0
        spotLight.spotOuterAngle = 80.0
        spotLight.castsShadow = true
        spotLight.color = UIColor.white
        let spotLightNode = SCNNode()
        spotLightNode.light = spotLight
        spotLightNode.position = SCNVector3(x: 1.0, y: 5.0, z: -2.0)
        self.addChildNode(spotLightNode)
         */

        // Create a directional light at the Node
        let light = SCNLight()
        light.type = SCNLight.LightType.directional
        light.color = UIColor.white
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 1.0, y: 5.0, z: -2.0)
        self.rootNode.addChildNode(lightNode)

        // Create additional omni light
        let omniNode = SCNNode()
        omniNode.light = SCNLight()
        omniNode.light!.type = SCNLight.LightType.omni
        omniNode.light!.color = UIColor.white
        omniNode.position = SCNVector3(x: 0, y: 10.00, z: -2)
        self.rootNode.addChildNode(omniNode)

        drawAxes(height: 10.0)
    }
        
    /*
     * Compiler-supplied required function.  Only needed if one uses storyboards.
     */
    required init(coder: NSCoder) {
        fatalError("Not using storyboards!")
    }
    
    /*
     * Dump out the contents of the specified node.  Calls recursively
     * to each child of the specified node.
     */
    private func dumpSCNNode ( node: SCNNode ) {
        
        print("Node: ", node)
        if let nom = node.name {
            print("Name: " + nom)
        }
        else {
            print("Unnamed")
        }
 
        let bbox = node.boundingBox
        print("bbox: ", bbox.min.x, bbox.min.y, bbox.max.x, bbox.max.y )
        
        let count = node.childNodes.count
        for i in 0..<count {
            print("i: " , i )
            dumpSCNNode(node: node.childNodes[i])
        }
    }
   
    /*
     * Draw an axis for debug purposes
     */
    let     X_AXIS = 0;
    let     Y_AXIS = 1;
    let     Z_AXIS = 2;
    let     HALF_PI = Float.pi / 2.0
    let     TWO_PI  = Float.pi * 2.0
    
    func drawAxis ( axis : Int, axisColor: UIColor, axisHeight: Float ) {
        
        let     axisRadius : Float   = axisHeight / 100.0
        let     axisStep   : Float   = axisHeight / 20.0
        let     numSteps   : Int     = 20
        var     curColor   : UIColor

        for i in 0...numSteps {
                            
            var pos = -axisHeight / 2 + Float(i) * axisStep;
        
            curColor = (i & 1 == 0) ? axisColor : (pos < 0) ? UIColor.gray : UIColor.white
                
            let cylinder = SCNCylinder(radius: CGFloat(axisRadius), height: CGFloat(axisStep))
            let cylNode = SCNNode(geometry: cylinder)
            
            cylinder.materials.first?.diffuse.contents = curColor

            pos += axisStep / 2.0;
            if (axis == X_AXIS) {
                cylNode.position.x = pos
                cylNode.eulerAngles.z = HALF_PI
            }
            else if (axis == Y_AXIS) {
                cylNode.position.y = pos
                cylNode.rotation.y = HALF_PI
            }
            else {
                cylNode.position.z = pos
                cylNode.eulerAngles.x = HALF_PI
            }
                
            self.rootNode.addChildNode(cylNode)
        }
    }

    /*
     * Draw the three axes for debug purposes
     */
    func drawAxes ( height: Float ) {
        
        drawAxis(axis: X_AXIS, axisColor: UIColor.blue, axisHeight:  height);
        drawAxis(axis: Y_AXIS, axisColor: UIColor.green, axisHeight:  height);
        drawAxis(axis: Z_AXIS, axisColor: UIColor.red, axisHeight:  height);
    }
    // -------------------------------------------------------------------------

}
