//
//  DrawKLALines.swift
//  PeakPerformance
//
//  Created by Benjamin Chiong on 10/1/16.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit

class DrawKLALines: UIView {

    
    var summary: MonthlySummary?
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        // Drawing code
        
        // context is the object used for drawing the line
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(4.0)
        context?.setStrokeColor(UIColor.darkGray.cgColor)
        
//        let xcoord = summary?.klaXaxis[KLA_FAMILY]
        
//        CGContextMoveToPoint(context, 120, 180) // start of the line
//        CGContextAddLineToPoint(context, 80, 50)
//        CGContextAddLineToPoint(context, 120, 50) // end of the line

        // Actually draw the path
        context?.strokePath()
    }
 

}
