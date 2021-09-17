/*
 * @author rkwright / www.geofx.com
 *
 * Copyright 2017, All rights reserved.
 *
 */

class MazeRat  {

    var bSuccess : Bool = false			// true if search was successful
    var bSac = false				// true if last cell was cul-de-sac
    var targetX = 0			    // coords of target
    var targetY = 0
    var ratX = 0				        // coords of cell
    var ratY = 0
    var lastX = -1
    var lastY = -1			    // coords of last cell drawn to
    var last_step : Bool = false

    var singleHit : Bool = false
    var searchMask : UInt8 = 0
    var stack : [UCoord] = [] 			    // solution search stack
    var mouseStack : [UCoord] = []		    // mouse-values stack
    
    weak var maze: Maze?
    var mazeEvent : ((String, Int, Int, Int, Int, Int, Bool)->())?
    
    /**
     *
     */
    init()   {
        //mazeEvent = report
    }
    
    /**
     * Init the rat for the search
     * @param mask
     * @param bSingleHit
     * @param mazeEvent - callback that takes 6 arguments and returns void
     * @returns {boolean}
     */
    func initSolveObj ( mask : UInt8, single : Bool, callBack : @escaping (String,
                                                                    Int,
                                                                    Int,
                                                                    Int,
                                                                    Int,
                                                                    Int,
                                                                    Bool)->()   ) {

        searchMask = mask          // unique mask value for this object

        singleHit = single

        bSuccess = false;			// true if search was successful
        bSac     = false;

        for i in 0..<maze!.nRow {
            for j in 0..<maze!.nCol {
                maze!.cells[i * maze!.nRow + j] |= 0xf0
            }
        }

        // clear stacks
        stack = [];			    // solution search stack
        mouseStack = []		    // mouse-values stack

        mazeEvent = callBack
        
        // push seed on stack
        stack.append(UCoord(x: maze!.seedX, y: maze!.seedY))
    }
        /**
     * Solves the specified maze by using a variant of the 4x4 seed fill.
     */
    func findSolution ( xExit : Int, yExit : Int ) -> Bool	{
        targetX = xExit
        targetY = yExit

        // while Stack not empty...
        while ( stack.count > 0 ) {

            solveStep()

            updateObject()
        }

        return bSuccess;
    }

    /**
     *  This func solves one step for the specified by maze by using a variant
     *  of the 4x4 seed fill.
     */
    func solveStep ()	{
        var		px : Int,py : Int;
        var		mazval : UInt8
        var     zx : Int,zy : Int;

        // pop next value from Stack
        let c = stack.removeLast();
        ratX  = c.x
        px    = ratX
        ratY  = c.y
        py    = ratY

        // if exit not yet found...
        if ( px != targetX || py != targetY )
        {
            mazval = maze!.cells[py * maze!.nRow + px];

            mazeEvent!("   solveStep", px,  py,  -1,  -1,  stack.count, false);

            // turn off top bit to show this cell has been checked
            maze!.cells[py * maze!.nRow + px] ^= searchMask;

            bSac = true
            for k in 0..<4 {
                zx = px + XEdge[k]
                zy = py + YEdge[k]
 
                if ( zx >= 0 && zx < maze!.nCol && zy >= 0 && zy < maze!.nRow ) {
                    
                    let mz = maze!.cells[zy * maze!.nRow + zx];

                    if ((maze!.cells[zy * maze!.nRow + zx] & searchMask) != 0 && ((mazval & (1 << k)) == 0) ) {
                        bSac = false
                        stack.append(UCoord(x: zx, y: zy))

                        mazeEvent!("    addStack", px, py, zx, zy, stack.count, false);
                    }
                }
            }

            bSuccess = false;
        }
        else {
            bSuccess = true
        }
    }

    /**
     * Updates the current position within the "maze".
     */
    func updateObject ()
    {
        var     msx : Int, msy : Int
        var     posx : Int, posy : Int

        // get and save object's current position
        posx  = ratX
        lastX = ratX
        posy  = ratY
        lastY = ratY

        if ( singleHit ) {
            if ( mouseStack.count > 0) {
                msx = mouseStack[mouseStack.count-1].x
                msy = mouseStack[mouseStack.count-1].y
            }
            else {
                msx = -1
                msy = -1
            }

           // if (mazeEvent != nil) {
            //
            //    mazeEvent( "updateObject", posy, posx, msy, msx, mouseStack.length, bSac );
            //}
        }

        // if cul-de-sac then re-trace "steps"
        if ( bSac ) {
            retraceSteps();
        }
        else {
            // if NOT a cul-de-sac, then save position  on stack
            mouseStack.append(UCoord(x: posx, y: posy))
        }
    }

    /**
     * This func updates the current position within the "maze".
     */
    func retraceSteps () {
        var     adjacent : Bool = false
        var		msx : Int, msy : Int
        var		posx : Int, posy : Int
        var		mazval : UInt8
        var     edg : Int
        var 	coord : UCoord

        last_step = stack.count == 0

        // Get ACTUAL next position from Main Stack , i.e. the pos to which we
        // must retrace our steps.  Note that we have to handle the last step
        // specially because the stack is now empty.
        if (last_step) {
            posx = maze!.seedX;
            posy = maze!.seedX;
        }
        else {
            // set the point to retrace to as the next item on the stack
            posx = stack[stack.count-1].x;
            posy = stack[stack.count-1].y;
        }

        // get maze value at that position
        mazval = maze!.cells[posy * maze!.nRow + posx];

        repeat  {
            if ( mouseStack.count > 0 ) {
                // pop previous position from mouse-stack
                coord = mouseStack.removeLast()
                msx = coord.x;
                msy = coord.y;

               // if ( !bSingleHit && mazeEvent != nil) {
               //     mazeEvent( "retraceSteps", maze, lastY, lastX, msy, msx, stack.count, bSac )
               // }

                // only the first cell is a real cul-de-sac, so clear the local flag
    			bSac = false

                // retrace line to that position
                lastX = msx;
                lastY = msy;

                // simple computational convenience
                msx -= posx;
                msy -= posy;

                // are we next to the "target"??
                adjacent = ( msx == 0 || msy == 0 ) && ( abs(msy) == 1 || abs(msx) == 1 )

                if ( adjacent && !last_step )  {
                    // see if the way is open..
                    edg = EdgeIndx[msy+1][msx+1]

                    adjacent = (mazval & (1 << edg)) != 0
                    if (adjacent) {
                        mouseStack.append(coord)   // was mouseIndex++;  ??
                    }
                }
            }
        }
        while ((mouseStack.count > 0) && ( !adjacent || last_step ))

        // if this is the end, call back and report that we are exiting the initial seed point
        //if (last_step) {
         //   if ( !bSingleHit && mazeEvent != nil ) {
         //       mazeEvent( "retraceSteps", this, this.maze.seedY, this.maze.seedX, 0, -1, this.stack.length, this.bSac )
         //   }

        //}
    }

    /**
     * @see com.geofx.example.erosion.MazeEvent#mazeEvent(int, int, int, int, int, boolean)
     */
    func report ( description : String, posx : Int, posy : Int, msx : Int, msy : Int, stackDepth : Int, bSac : Bool  ) {
        print(String(format: "%@  x: %d  y: %d  msx: %d  msy: %d depth: %d  bSac: %d",description, posx, posy, msx, msy, stackDepth, bSac))
    }
}
