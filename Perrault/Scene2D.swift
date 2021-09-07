//
//  Scene2D.swift
//  Perrault
//
//  Created by rkwright on 8/31/21.
//

import UIKit

class Scene2D: UIView {

    override init ( frame: CGRect ) {
        super.init(frame: frame )
        print("Scene2D Init")
    }
    
    /*
     * Compiler-supplied required function.  Only needed if one uses storyboards.
     */
    required init(coder: NSCoder) {
        fatalError("Not using storyboards!")
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw( _ rect: CGRect ) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2.0)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 1.0, 1.0]
        let color = CGColor(colorSpace: colorSpace, components: components)
        context?.setStrokeColor(color!)

        context?.move(to: CGPoint(x: 30, y: 30))
        context?.addLine(to: CGPoint(x: 300, y: 400))
        
        context?.strokePath()
    }
   
}
