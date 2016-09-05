//
//  customizableTextView.swift
//  PeakPerformance
//
//  Created by Benjamin Chiong on 9/5/16.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit

@IBDesignable class CustomizableTextView: UITextView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: CGColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor {
        
        didSet {
            layer.borderColor = borderColor
        }
    }
    
}