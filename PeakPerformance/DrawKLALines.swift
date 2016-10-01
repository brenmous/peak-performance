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
    override func drawRect(rect: CGRect) {
        
        // Drawing code
        
        // context is the object used for drawing the line
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 4.0)
        CGContextSetStrokeColorWithColor(context, UIColor.darkGrayColor().CGColor)
        
//        let xcoord = summary?.klaXaxis[KLA_FAMILY]
        
        CGContextMoveToPoint(context, 157.5, 202.5) // start of the line
        CGContextAddLineToPoint(context, 80, 200) // end of the line
//        CGContextAddLineToPoint(context, 120, 50) // connects the line

        // Actually draw the path
        CGContextStrokePath(context)
    }
 

}
