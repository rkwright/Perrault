//
//  Basin.swift
//  Perrault
//
//  Created by rkwright on 9/9/21.
//

import Foundation

class Basin {
    private var  maze : Maze
    
    init () {
        
        maze = Maze()
        maze.create(col: 4, row: 4, sX: 0, sY: 0)
        maze.build();
        
        let rat = maze.getRat()
        
        rat.initSolveObj(mask: 0x80, singleHit: false, callBack: report)

        let bSuccess = rat.findSolution( xExit: -1, yExit: -1 );

         // elapsed = (performance.now() - startTime)/1000.0;

        print("Maze solved? ", bSuccess," maxNeighbors: " , maze.maxNeighbors)

        rat.retraceSteps()

          //bPath = false;
          //startTime = performance.now();

        rat.initSolveObj(mask: 0x80, singleHit: true, callBack: report);

        let bSolve = rat.findSolution( xExit: -1, yExit: -1);
    }
    
    /**
     * @see com.geofx.example.erosion.MazeEvent#mazeEvent(int, int, int, int, int, boolean)
     */
    func report ( description : String, posx : Int, posy : Int, msx : Int, msy : Int, stackDepth : Int, bSac : Bool  ) {
        //console.info(description + " posx: " +  posx.toFixed(0) + "  posy: " + posy.toFixed(0) + " msx: " + msx.toFixed(0) +
        //    " msy: " + msy.toFixed(0) + " depth: " + stackDepth.toFixed(0) + " bSac: " + bSac);
    }
}
