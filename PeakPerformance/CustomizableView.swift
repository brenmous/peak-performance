//
//  CustomizableView.swift
//  PeakPerformance
//
//  Created by Benjamin Chiong on 9/26/16.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit

@IBDesignable class CustomizableView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet{
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
            clipsToBounds = true
        }
    }
    
}