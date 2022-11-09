//
//  Basin.swift
//  Perrault
//
//  Created by rkwright on 9/9/21.
//

import Foundation
import os.log

class Basin {
    var  maze : Maze
    var  rat  : MazeRat
    var  event :  ((String,Int,Int,Int,Int,Int,Bool)->())?
   
    
    init () {
        maze = Maze()
        rat  = maze.getRat()
        
        let logger = Logger(subsystem: "com.steipete.LoggingTest", category: "main")
        logger.notice("Notice: \("wowsr", privacy: .public)")
        logger.debug("Debug: \("wowsr", privacy: .public)")
        logger.trace("Trace: \("wowsr", privacy: .public)")
        logger.error("Error: \("wowsr", privacy: .public)")
        logger.warning("Warning: \("wowsr", privacy: .public)")
        logger.fault("Fault: \("wowsr", privacy: .public)")
        logger.critical("Critical: \("wowsr", privacy: .public)")
    }
        
    func build() {
        //maze = Maze()
        maze.create(col: 500, row: 500, sX: 0, sY: 0)
        maze.build();
        
        //let rat = maze.getRat()
        
        let bSolve : Bool = traverseStreams()
        
        print("Maze solved? ", bSolve," maxNeighbors: " , maze.maxNeighbors)
    }
    
    /*
     *
     */
    func traverseStreams()  -> Bool {
        
        rat.initSolveObj(mask: 0x80, single: false, callBack: event!)

        let bSuccess = rat.findSolution( xExit: -1, yExit: -1 );

         // elapsed = (performance.now() - startTime)/1000.0;

        print("Maze solved? ", bSuccess," maxNeighbors: " , maze.maxNeighbors)

        rat.retraceSteps()

          //bPath = false;
          //startTime = performance.now();

        rat.initSolveObj(mask: 0x80, single: true, callBack: event!);

        let bSolve = rat.findSolution( xExit: -1, yExit: -1);

        return bSolve
    }
    
    func setCallBack( callback: @escaping (String,
                                           Int,
                                           Int,
                                           Int,
                                           Int,
                                           Int,
                                           Bool)->()  ) {
        event = callback
    }
    /**
     * @see com. .example.erosion.MazeEvent#mazeEvent(int, int, int, int, int, boolean)
     */
    func report ( description : String, posx : Int, posy : Int, msx : Int, msy : Int, stackDepth : Int, bSac : Bool  ) {
        print( String( format: "Rat: description %d  posx: %d posy: %d msx: %d  msy: %d  depth: %d bSac: %d ", posx, posy, msx, msy, stackDepth, bSac))
    }
    
    func getMaze() -> Maze {
        return maze;
    }
}
