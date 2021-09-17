//
//  Scene2D.swift
//  Perrault
//
//  Created by rkwright on 8/31/21.
//

import UIKit

class Scene2D: UIView {

    var maze : Maze?
    var context :  CGContext?
    var screenReady : Bool = false
    
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
          print(String(format: "DrawEvent %@  x: %d  y: %d  msx: %d  msy: %d depth: %d  bSac: %d",description, posX, posY, msX, msY, stackDepth, bSac))
        
        let cellSize = 400 / maze!.nRow;
        let px1 = 80 + Int(Double(posX) + 0.5) * cellSize;
        let py1 = 420 - Int(Double(posY) + 0.5) * cellSize;
        let px2 = 80 + Int(Double(msX) + 0.5) * cellSize;
        let py2 = 420 - Int(Double(msY) + 0.5) * cellSize;

        context?.setLineWidth(1.0)

        context?.beginPath()
        context?.move(to: CGPoint(x: px1, y: py1))
        context?.addLine(to: CGPoint(x: px2, y: py2))
        context?.strokePath()
    }
    
    func drawMaze( maze : Maze ) {
        let cellSize = 200 / maze.nRow

        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1.0)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 0.0, 1.0]
        let color = CGColor(colorSpace: colorSpace, components: components)
        context?.setStrokeColor(color!)

        //UIColor.setStroke(UIColor.red)
        
        print("Drawing the maze, cellSize: ", cellSize)
        
        var px = 80
        var py = 420
        var sKnt = 0
        for i in 0..<maze.nRow {
            for j in 0..<maze.nCol {
                
                let mz = maze.cells[i * maze.nRow + j];

                    //console.log(i.toFixed(0) + " " + j.toFixed(0) +
                    //    " S: " + (mz & MAZE.SOUTH_BIT) + " W: " + (mz & MAZE.WEST_BIT) +
                    //    " N: " + (mz & MAZE.NORTH_BIT) + " E: " + (mz & MAZE.EAST_BIT)  );

                    if  ((mz & SOUTH_BIT) != 0) {
                        context?.beginPath()
                        context?.move(to: CGPoint(x: px, y: py))
                        context?.addLine(to: CGPoint(x: px + cellSize, y: py))
                        context?.strokePath()
                        //print(String( format: "S: moveTo: %d %d,  lineTo: %d %d", px,py,px+cellSize,py))
                        sKnt += 2;
                    }

                    if  ((mz & WEST_BIT) != 0) {
                        context?.beginPath();
                        context?.move(to: CGPoint(x: px, y: py))
                        context?.addLine(to: CGPoint(x: px, y: py-cellSize))
                        context?.strokePath()
                        //print(String( format: "W: moveTo: %d %d,  lineTo: %d %d", px,py,px,py-cellSize))
                        sKnt += 2;
                    }

                    if  ((mz & NORTH_BIT) != 0) {
                        context?.beginPath();
                        context?.move(to: CGPoint(x: px, y: py-cellSize))
                        context?.addLine(to: CGPoint(x: px+cellSize, y: py-cellSize))
                        context?.strokePath()
                        //print(String( format: "N: moveTo: %d %d,  lineTo: %d %d", px,py-cellSize,px+cellSize,py-cellSize))
                        sKnt += 2;
                    }

                    if  ((mz & EAST_BIT) != 0) {
                        context?.beginPath();
                        context?.move(to: CGPoint(x: px+cellSize, y: py))
                        context?.addLine(to: CGPoint(x: px+cellSize, y: py-cellSize))
                        context?.strokePath()
                        //print(String( format: "E: moveTo: %d %d,  lineTo: %d %d", px+cellSize,py,px+cellSize,py-cellSize))
                        sKnt += 2;
                    }

                    px += cellSize;
                }

                px = 80;
                py -= cellSize;
            }
            print("Drawmaze done! sKnt: ",sKnt);
        }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
   
    override func draw( _ rect: CGRect ) {
        
        if ( maze!.nCol > 0 || maze!.nRow > 0) {
    
            drawMaze( maze: maze!)
            screenReady = true
            //setNeedsDisplay()
            
            //let vc: UIViewController = self.parentViewController!
            //print("vc")
        }
     }
}

extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
