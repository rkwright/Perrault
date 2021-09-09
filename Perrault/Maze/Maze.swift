/*
 * @author rkwright / www.geofx.com
 *
 * Copyright 2021, All rights reserved.
 *
 */

import CoreGraphics
import UIKit

struct UCoord {
    var x : Int
    var y : Int
    
    mutating func set ( cx : Int, cy: Int ) {
        x = cx
        y = cy
    }
}

// cardinal directions
let SOUTH = 0
let WEST  = 1
let NORTH = 2
let EAST  = 3

// 1 << (cardinal_direction)
let SOUTH_BIT = 1
let WEST_BIT  = 2
let NORTH_BIT = 4
let EAST_BIT  = 8

//this.EdgeStr = ["S", "W", "N", "E"];
let EdgeBit    = [1, 2, 4, 8]
let OppEdgeBit = [4, 8, 1, 2]
let XEdge      = [0, -1, 0, 1]
let YEdge      = [-1, 0, 1, 0]
let EdgeIndx   = [[-1,  0, -1],
                  [ 1, -1,  3],
                  [-1,  2, -1]]

class Maze {
    
   
    let revision =  "r03"

    var neighbors    : [UCoord]
    var cells        : [UInt8]
    var maxNeighbors : Int = 0
    var nRow : Int = 0
    var nCol : Int = 0
    var seedX : Int = 0
    var seedY : Int = 0
    var coord : UCoord = UCoord( x: 0, y: 0)

    /**
     * Initialize the parameters that control the maze-building
     * process.
     */
    init () {
        neighbors = []
        cells = []
    }

    /**
     * @param col - number of columns in the maze
     * @param row - number of rows in the maze
     * @param seedX - x-index of seed cell
     * @param seedY - y-index of seed cell
     */
    func create ( col : Int, row : Int, sX : Int, sY : Int ) {
       
    neighbors = [];
    maxNeighbors = 0;	// just for info's sake

    nRow = row;         // actual number of rows in maze
    nCol = col;         // actual number of cols in maze

    cells = [UInt8](repeating: 0, count: row * col)

    seedX = sX;
    seedY = sY;

    cells[seedY * row + seedX] = 0xff;

    /*
    this.random = [
        0.7089998792613033,
        0.2984042827075908,
        0.151327677518597,
        0.5311409004659107,
        0.3592650838882001,
        0.12786247721616228,
        0.08303331111448853,
        0.13022329844710323,
        0.3901487586026049,
        0.9507173128886488,
        0.43746401482808395,
        0.349821701435554,
        0.7707404924385883,
        0.032055300540311915,
        0.20838748976454724,
        0.9388920819931408,
        0.0756514748990138,
        0.606463251716048,
        0.7744438337871995,
        0.8881816498950352,
        0.6959170586112238,
        0.7078428113596047,
        0.9319804811012935,
        0.3097252899190752,
        0.30846991398937096,
        0.9158152580489112,
        0.6421344322846634,
        0.5149000577715059,
        0.7896001483653874,
        0.5242420736444318,
        0.344417139647895,
        0.7072985028307064
    ];

    for ( var i=0; i<32; i++ ) {
        console.log(Math.random() + ",");
    } */
}
    /**
     * Builds the maze.  basically, it just starts with the seed and visits
     * that cell and checks if there are any neighbors that have NOT been
     * visited yet.  If so, it adds the to neighbors list.
     */
    func build () {

        var coord : UCoord = UCoord(x: seedX, y: seedY)

        repeat {

            findNeighbors( curCoord: coord )

            let k = Int.random(in: 0..<neighbors.count)
            coord = neighbors.remove(at: k)

            //console.log("Dissolving edge for current cell: " + coord.x.toFixed(0) + " " +
            //      coord.y.toFixed() + " k: "  + k.toFixed(2));

            dissolveEdge( coord: coord )
            
        } while (neighbors.count > 0)
        
        dumpEdges(col: nCol, row: nRow)
    }

    /**
     * Finds all neighbors of the specified cell.  Each neighbor is pushed onto
     * the "stack" (actually just an array list.
     *
     * @param x - current index into the array
     * @param y
     */
    func findNeighbors (  curCoord: UCoord ) {

        var zx : Int
        var zy : Int
        var coord : UCoord = UCoord(x: curCoord.x, y: curCoord.y)

        for  i in 0..<4  {

            zx = Int(coord.x) + XEdge[i];
            zy = Int(coord.y) + YEdge[i];

            // if indicies in range and cell still zero then the cell is still in the "src list"
            if (zx >= 0 && zx < nCol && zy >= 0 && zy < nRow
                        && cells[zy * Int(nRow) + zx] == 0) {

                // set the upper bits to indicate that this cell has been "found"
                cells[zy * Int(nRow) + zx] = 0xf0;

                coord.x = zx
                coord.y = zy
                neighbors.append( coord );

                //console.log("Adding to neighbors: " + zx.toFixed(0) + " " + zy.toFixed(0));

                maxNeighbors = max( maxNeighbors, neighbors.count );
            }
        }
    }

    /**
     * Dissolves the edge between the specified cell and one of the
     * adjacent cells in the spanning tree.  However, it does so ONLY
     * if the adjacent cell is already part of the "maze tree", i.e.
     * it won't open a cell into an unvisited cell.
     * The algorithm is such that it is guaranteed that each cell will
     * only be visited once.
     *
     * @param x - cur index
     * @param y
      * return - true if added to the tree
     */
    func dissolveEdge ( coord: UCoord ) {

        var		edg     : Int
        var     edgeRay : [Int] = []
        var		zx,zy   : Int
        var     cellVal : UInt8

        // build the fence for this cell
        cells[Int(coord.y) * Int(nRow) + Int(coord.x)] = 0xff;

        for i in 0..<4 {

            zx = coord.x + XEdge[i];
            zy = coord.y + YEdge[i];

            // if indicies in range and cell has been visited, push it on the local stack
            let oppEdg = Int(OppEdgeBit[i])

            if ( zx >= 0 && zx < nCol && zy >= 0 && zy < nRow ) {

                cellVal = UInt8(Int(cells[zy * nRow + zx]) & oppEdg)

                if (cellVal != 0) {
                
                    edgeRay.append( i )
                }
            }
        }

        if ( edgeRay.count > 0 ) {

            let n = Int.random(in: 0..<edgeRay.count);
            edg = edgeRay[n];
            zx  = coord.x + XEdge[edg];
            zy  = coord.y + YEdge[edg];

            cells[coord.y * nRow + coord.x]   ^= UInt8(EdgeBit[edg])
            cells[zy * nRow + zx] ^= UInt8(OppEdgeBit[edg])

            //console.log("In cell " + x.toFixed(0) + " " + y.toFixed(0) +
             //   " dissolving edge: " + this.EdgeStr[edg] + " into cell: " + zx.toFixed(0) + " " + zy.toFixed(0));
        }
    }

    /**
     * Dissolve the specified edge of the seed cell to form an exit
     * @param edg
     */
    func dissolveExit ( edg : Int ) {
        cells[seedY * nRow + seedX]   ^= UInt8(EdgeBit[edg])
    }
    
    /**
     * Return a random integer between min and max. The result may include the minimum
     * but will NOT include the maximum.  The random value is pulled from a static list of
     * pre-generated list of random values. This is to allow reproducible mazes.
     */
    /*
    func getRandomInt2 ( min : Int, max : Int ) {
        let min2 = ceil(Double(min))
        let max2 = floor(Double(max))
        return floor(random.removeLast() * (max2 - min2)) + min2
    }
 */
    
    /*
     *
     */
    func drawEvent ( description : String, posx : Int, posy : Int, msx : Int, msy : Int, stackDepth : Int, bSac : Bool ) {
        
    }
    
    /**
     * @param col
     * @param row
     */
    func dumpEdges (  col : Int, row : Int ) {
        for i in 0..<row  {
            for j in 0..<col {
            
                let mz = cells[i * row + j]
                
                print(i, " ", j , " mz: " , mz )

               // print(i, " ", j , " S: " , Int(mz & SOUTH_BIT), " W: ", Int(mz & WEST_BIT),
               //     " N: " , Int(mz & NORTH_BIT), " E: ", Int(mz & EAST_BIT)  )
            }
        }
    }
}


