//
//  MIDatePicker.swift
//  Agenda medica
//
//  Created by Mario on 15/06/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import UIKit

protocol MIDatePickerDelegate: class {
    
    func miDatePicker(amDatePicker: MIDatePicker, didSelect date: NSDate)
    func miDatePickerDidCancelSelection(amDatePicker: MIDatePicker)
    
}

class MIDatePicker: UIView {
    
    // MARK: - Config
    // MARK: - Config
    struct Config {
        
        private let contentHeight: CGFloat = 230
        private let bouncingOffset: CGFloat = 20
        
        var startDate: NSDate?
        
        var confirmButtonTitle = "Confirm"
        var cancelButtonTitle = "Cancel"
        
        var headerHeight: CGFloat = 40
        
        var animationDuration: NSTimeInterval = 0.5
        
        var contentBackgroundColor: UIColor = UIColor.lightGrayColor()
        var headerBackgroundColor: UIColor = UIColor.whiteColor()
        var confirmButtonColor: UIColor = UIColor.init(red: 143/255, green: 87/255, blue: 152/255, alpha: 1)
        var cancelButtonColor: UIColor = UIColor.blackColor()
        
        var overlayBackgroundColor: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        
    }
    
    var config = Config()
    
    weak var delegate: MIDatePickerDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    var bottomConstraint: NSLayoutConstraint!
    var overlayButton: UIButton!
    
    // MARK: - Init
    static func getFromNib() -> MIDatePicker {
        return UINib.init(nibName: String(self), bundle: nil).instantiateWithOwner(self, options: nil).last as! MIDatePicker
    }
    
    // MARK: - IBAction
    @IBAction func confirmButtonDidTapped(sender: AnyObject) {
        
        config.startDate = datePicker.date
        
        dismiss()
        delegate?.miDatePicker(self, didSelect: datePicker.date)
        
    }
    @IBAction func cancelButtonDidTapped(sender: AnyObject) {
        dismiss()
        delegate?.miDatePickerDidCancelSelection(self)
    }
    
    // MARK: - Private
    private func setup(parentVC: UIViewController) {
        
        // Loading configuration
        
        if let startDate = config.startDate {
            datePicker.date = startDate
        }
        
        headerViewHeightConstraint.constant = config.headerHeight
        
        confirmButton.setTitle(config.confirmButtonTitle, forState: .Normal)
        cancelButton.setTitle(config.cancelButtonTitle, forState: .Normal)
        
        confirmButton.setTitleColor(config.confirmButtonColor, forState: .Normal)
        cancelButton.setTitleColor(config.cancelButtonColor, forState: .Normal)
        
        headerView.backgroundColor = config.headerBackgroundColor
        backgroundView.backgroundColor = config.contentBackgroundColor
        
        // Overlay view constraints setup
        
        overlayButton = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
        overlayButton.backgroundColor = config.overlayBackgroundColor
        overlayButton.alpha = 0
        
        overlayButton.addTarget(self, action: #selector(cancelButtonDidTapped(_:)), forControlEvents: .TouchUpInside)
        
        if !overlayButton.isDescendantOfView(parentVC.view) { parentVC.view.addSubview(overlayButton) }
        
        overlayButton.translatesAutoresizingMaskIntoConstraints = false
        
        parentVC.view.addConstraints([
            NSLayoutConstraint(item: overlayButton, attribute: .Bottom, relatedBy: .Equal, toItem: parentVC.view, attribute: .Bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .Top, relatedBy: .Equal, toItem: parentVC.view, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .Leading, relatedBy: .Equal, toItem: parentVC.view, attribute: .Leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .Trailing, relatedBy: .Equal, toItem: parentVC.view, attribute: .Trailing, multiplier: 1, constant: 0)
            ]
        )
        
        
        // Setup picker constraints
        
        frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.height, width: UIScreen.mainScreen().bounds.width, height: config.contentHeight + config.headerHeight)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        bottomConstraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: parentVC.view, attribute: .Bottom, multiplier: 1, constant: 0)
        
        if !isDescendantOfView(parentVC.view) { parentVC.view.addSubview(self) }
        
        parentVC.view.addConstraints([
            bottomConstraint,
            NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: parentVC.view, attribute: .Leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: parentVC.view, attribute: .Trailing, multiplier: 1, constant: 0)
            ]
        )
        addConstraint(
            NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: frame.height)
        )
        
        move(goUp: false)
        
    }
    private func move(goUp goUp: Bool) {
        bottomConstraint.constant = goUp ? config.bouncingOffset : config.contentHeight + config.headerHeight
    }
    
    // MARK: - Public
    func show(inVC parentVC: UIViewController, completion: (() -> ())? = nil) {
        
        setup(parentVC)
        move(goUp: true)
        
        UIView.animateWithDuration(
            config.animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .CurveEaseIn, animations: {
                
                parentVC.view.layoutIfNeeded()
                self.overlayButton.alpha = 1
                
            }, completion: { (finished) in
                completion?()
            }
        )
        
    }
    func dismiss(completion: (() -> ())? = nil) {
        
        move(goUp: false)
        
        UIView.animateWithDuration(
            config.animationDuration, animations: {
                
                self.layoutIfNeeded()
                self.overlayButton.alpha = 0
                
            }, completion: { (finished) in
                completion?()
                self.removeFromSuperview()
                self.overlayButton.removeFromSuperview()
            }
        )
        
    }
    
}