//
//  ViewController.swift
//
//  Copyright © 2021 Ric Wright. All rights reserved.
//

import UIKit
import SceneKit

//---------------------------------------------------------------------------

class ViewController: UIViewController {

    private var sceneView :    SCNView!
    private var scene :        SKScene!
    private var spawnTime :     TimeInterval = 0
    private var basin :         Basin!
    private var view2D : Scene2D!
    private var maz : Maze!
    private var basinBuilt : Bool = false
    /*
     * ViewController life cycle
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        //create3DView()
        
        create2DView()
        
        createBasin()
        
        maz = basin.getMaze()
        view2D.setMaze(maz: maz )
        basin.setCallBack( callback: view2D.drawEvent)
        
        //basin.build()
    }

    override func viewDidAppear( _ animated: Bool ) {
        super.viewDidAppear( animated )
        print("View appeared")
        
        if (basinBuilt == false) {
            basin.build()
            basinBuilt = true
        }
                
        view2D.setNeedsDisplay()
    }

    /*
     * Create the 3D view by creating a SceneKit "scene"
     */
    func create3DView () {
        
        scene = SKScene()
        scene.create()
        
        sceneView = SCNView()
        sceneView.scene = scene
        sceneView.delegate = self
        sceneView.allowsCameraControl = true
        sceneView.showsStatistics = true
        sceneView.backgroundColor = UIColor.black
        sceneView.isPlaying = true
        sceneView.isHidden = false
        self.view = sceneView
    }
    
    /*
     * The 2D view is simply a white background.  Drawing is done
     * via Quartz/CoreGrapgics
     */
    func create2DView () {
        
        view2D = Scene2D()
        view2D.backgroundColor = .white
           
        self.view = view2D
    }
    
    /*
     *
     */
    func createBasin() {
    
        basin = Basin()
    }
    
    func viewReady() {
        basin.build()
    }
    
    /*
     *
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // -------------------------------------------------------------------------

}

//
// Extension protocol so we can handle the render loop calls
//
extension ViewController: SCNSceneRendererDelegate {

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {

        if time > spawnTime {
                    
            spawnTime = time //+ TimeInterval(Float.random(min: 0.2, max: 1.5))
        }
    }
}


