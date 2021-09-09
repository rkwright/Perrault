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
    }
}
