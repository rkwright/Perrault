//
//  Scene2D.swift
//  Perrault
//
//  Created by rkwright on 8/31/21.
//

import UIKit

class Scene2D: UIView {

    var maze : Maze?
    
    override init ( frame: CGRect ) {
        super.init(frame: frame )
        print("Scene2D Init")
    }
    
    func setMaze( maz : Maze ) {
        maze = maz;
    }
    
    /*
     * Compiler-supplied required function.  Only needed if one uses storyboards.
     */
    required init(coder: NSCoder) {
        fatalError("Not using storyboards!")
    }

    func drawEvent ( description : String, posX : Int, posY : Int, msX : Int, msY : Int, stackDepth : Int, bSac : Bool  ) {
          print(String(format: "%@  x: %d  y: %d  msx: %d  msy: %d depth: %d  bSac: %d",description, posX, posY, msX, msY, stackDepth, bSac))

    }
    
    func drawMaze( maze : Maze ) {
        let cellSize = 200 / maze.nRow

        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1.0)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 1.0, 1.0]
        let color = CGColor(colorSpace: colorSpace, components: components)
        context?.setStrokeColor(color!)

        context?.move(to: CGPoint(x: 30, y: 30))
        context?.addLine(to: CGPoint(x: 300, y: 400))
        
        context?.strokePath()

        var px = 20
        var py = 820
        var sKnt = 0
        for i in 0..<maze.nRow {
            for j in 0..<maze.nCol {
                
                let mz = maze.cells[i * maze.nRow + j];

                    //console.log(i.toFixed(0) + " " + j.toFixed(0) +
                    //    " S: " + (mz & MAZE.SOUTH_BIT) + " W: " + (mz & MAZE.WEST_BIT) +
                    //    " N: " + (mz & MAZE.NORTH_BIT) + " E: " + (mz & MAZE.EAST_BIT)  );

                    if  ((mz & SOUTH_BIT) != 0) {
                        context?.beginPath();
                        context?.move(to: CGPoint(x: px, y: py))
                        context?.addLine(to: CGPoint(x: px + cellSize, y: py))
                        context?.strokePath()
                        sKnt += 2;
                    }

                    if  ((mz & WEST_BIT) != 0) {
                        context?.beginPath();
                        context?.move(to: CGPoint(x: px, y: py-cellSize))
                        context?.addLine(to: CGPoint(x: px, y: py-cellSize))
                        context?.strokePath()
                        sKnt += 2;
                    }

                    if  ((mz & NORTH_BIT) != 0) {
                        context?.beginPath();
                        context?.move(to: CGPoint(x: px, y: py-cellSize))
                        context?.addLine(to: CGPoint(x: px+cellSize, y: py-cellSize))
                        context?.strokePath()
                        sKnt += 2;
                    }

                    if  ((mz & EAST_BIT) != 0) {
                        context?.beginPath();
                        context?.move(to: CGPoint(x: px+cellSize, y: py))
                        context?.addLine(to: CGPoint(x: px+cellSize, y: py-cellSize))
                        context?.strokePath()
                        sKnt += 2;
                    }

                    px += cellSize;
                }

                px = 20;
                py -= cellSize;
            }
            print("Drawmaze done! sKnt: ",sKnt);
        }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
   
    override func draw( _ rect: CGRect ) {
        
        drawMaze( maze: maze!)
        // Drawing code
        /*let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2.0)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 1.0, 1.0]
        let color = CGColor(colorSpace: colorSpace, components: components)
        context?.setStrokeColor(color!)

        context?.move(to: CGPoint(x: 30, y: 30))
        context?.addLine(to: CGPoint(x: 300, y: 400))
        
        context?.strokePath()
         */
    }
}
