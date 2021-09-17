//
//  Basin.swift
//  Perrault
//
//  Created by rkwright on 9/9/21.
//

import Foundation

class Basin {
    var  maze : Maze
    var  event :  ((String,
    Int,
    Int,
    Int,
    Int,
    Int,
    Bool)->())?
   
    
    init () {
        maze = Maze()
    }
        
    func build() {
        //maze = Maze()
        maze.create(col: 3, row: 3, sX: 0, sY: 0)
        maze.build();
        
        let rat = maze.getRat()
        
        rat.initSolveObj(mask: 0x80, single: false, callBack: event!)

        let bSuccess = rat.findSolution( xExit: -1, yExit: -1 );

         // elapsed = (performance.now() - startTime)/1000.0;

        print("Maze solved? ", bSuccess," maxNeighbors: " , maze.maxNeighbors)

        rat.retraceSteps()

          //bPath = false;
          //startTime = performance.now();

        rat.initSolveObj(mask: 0x80, single: true, callBack: event!);

        let bSolve = rat.findSolution( xExit: -1, yExit: -1);

        print("Maze solved? ", bSolve," maxNeighbors: " , maze.maxNeighbors)
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
     * @see com.geofx.example.erosion.MazeEvent#mazeEvent(int, int, int, int, int, boolean)
     */
    func report ( description : String, posx : Int, posy : Int, msx : Int, msy : Int, stackDepth : Int, bSac : Bool  ) {
        print( String( format: "Rat: description %d  posx: %d posy: %d msx: %d  msy: %d  depth: %d bSac: %d ", posx, posy, msx, msy, stackDepth, bSac))
    }
    
    func getMaze() -> Maze {
        return maze;
    }
}
