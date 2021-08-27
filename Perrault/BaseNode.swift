//
//  BaseNode.swift
//
//  Copyright © 2021 Ric Wright. All rights reserved.
//

import SceneKit

//-----------------------------------------------------------------------------

class BaseNode : SCNNode {
    
    /*
     * Initialisation
     */
    override init() {
        super.init()
        
        // Create player node
        let cubeGeometry = SCNBox(width: 2.5, height: 2.5, length: 2.5, chamferRadius: 0.0)
        let colorMaterial = SCNMaterial()
        cubeGeometry.materials = [colorMaterial]
        let cubeNode = SCNNode(geometry: cubeGeometry)
        self.addChildNode(cubeNode)
    }
    
    /*
     * Compiler-supplied required function.  Only needed if one uses storyboards.
     */
    required init(coder: NSCoder) {
        fatalError("Not using storyboards!")
    }
}
