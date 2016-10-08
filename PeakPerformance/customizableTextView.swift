//
//  customizableTextView.swift
//  PeakPerformance
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Ignacio Nieto Carvajal
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import UIKit

private let kPlaceholderTextViewInsetSpan: CGFloat = 8

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
    
    /** The string that will be put in the placeholder */
    @IBInspectable var placeholder: NSString? { didSet { setNeedsDisplay() } }
    /** color for the placeholder text. Default is UIColor.lightGrayColor() */
    @IBInspectable var placeholderColor: UIColor = UIColor.lightGrayColor()
    
    // MARK: - Text insertion methods need to "remove" the placeholder when needed
    
    /** Override normal text string */
    override var text: String! { didSet { setNeedsDisplay() } }
    
    /** Override attributed text string */
    override var attributedText: NSAttributedString! { didSet { setNeedsDisplay() } }
    
    /** Setting content inset needs a call to setNeedsDisplay() */
    override var contentInset: UIEdgeInsets { didSet { setNeedsDisplay() } }
    
    /** Setting font needs a call to setNeedsDisplay() */
    override var font: UIFont? { didSet { setNeedsDisplay() } }
    
    /** Setting text alignment needs a call to setNeedsDisplay() */
    override var textAlignment: NSTextAlignment { didSet { setNeedsDisplay() } }
    
    // MARK: - Lifecycle
    
    /** Override coder init, for IB/XIB compatibility */
    #if !TARGET_INTERFACE_BUILDER
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        listenForTextChangedNotifications()
    }
    
    /** Override common init, for manual allocation */
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        listenForTextChangedNotifications()
    }
    #endif
    
    /** Initializes the placeholder text view, waiting for a notification of text changed */
    func listenForTextChangedNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CustomizableTextView.textChangedForPlaceholderTextView(_:)), name:UITextViewTextDidChangeNotification , object: self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CustomizableTextView.textChangedForPlaceholderTextView(_:)), name:UITextViewTextDidBeginEditingNotification , object: self)
    }
    
    /** willMoveToWindow will get called with a nil argument when the window is about to dissapear */
    override func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToWindow(newWindow)
        if newWindow == nil { NSNotificationCenter.defaultCenter().removeObserver(self) }
        else { listenForTextChangedNotifications() }
    }
    
    
    // MARK: - Adjusting placeholder.
    func textChangedForPlaceholderTextView(notification: NSNotification) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // in case we don't have a text, put the placeholder (if any)
        if self.text.characters.count == 0 && self.placeholder != nil {
            let baseRect = placeholderBoundsContainedIn(self.bounds)
            let font = self.font ?? self.typingAttributes[NSFontAttributeName] as? UIFont ?? UIFont.systemFontOfSize(UIFont.systemFontSize())
            
            self.placeholderColor.set()
            
            // build the custom paragraph style for our placeholder text
            var customParagraphStyle: NSMutableParagraphStyle!
            if let defaultParagraphStyle =  typingAttributes[NSParagraphStyleAttributeName] as? NSParagraphStyle {
                customParagraphStyle = defaultParagraphStyle.mutableCopy() as! NSMutableParagraphStyle
            } else { customParagraphStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle }
            // set attributes
            customParagraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
            customParagraphStyle.alignment = self.textAlignment
            let attributes = [NSFontAttributeName: font, NSParagraphStyleAttributeName: customParagraphStyle.copy() as! NSParagraphStyle, NSForegroundColorAttributeName: self.placeholderColor]
            // draw in rect.
            self.placeholder?.drawInRect(baseRect, withAttributes: attributes)
        }
    }
    
    func placeholderBoundsContainedIn(containerBounds: CGRect) -> CGRect {
        // get the base rect with content insets.
        let baseRect = UIEdgeInsetsInsetRect(containerBounds, UIEdgeInsetsMake(kPlaceholderTextViewInsetSpan, kPlaceholderTextViewInsetSpan/2.0, 0, 0))
        
        // adjust typing and selection attributes
        if let paragraphStyle = typingAttributes[NSParagraphStyleAttributeName] as? NSParagraphStyle {
            return baseRect.offsetBy(dx: paragraphStyle.headIndent, dy: paragraphStyle.firstLineHeadIndent)
        }
        
        return baseRect
    }
    
}