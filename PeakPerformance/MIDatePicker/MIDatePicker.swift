//
//  MIDatePicker.swift
//  Agenda medica
//
//  Created by Mario on 15/06/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import UIKit

protocol MIDatePickerDelegate: class {
    
    func miDatePicker(_ amDatePicker: MIDatePicker, didSelect date: Date)
    func miDatePickerDidCancelSelection(_ amDatePicker: MIDatePicker)
    
}

class MIDatePicker: UIView {
    
    // MARK: - Config
    // MARK: - Config
    struct Config {
        
        fileprivate let contentHeight: CGFloat = 230
        fileprivate let bouncingOffset: CGFloat = 20
        
        var startDate: Date?
        
        var confirmButtonTitle = "Confirm"
        var cancelButtonTitle = "Cancel"
        
        var headerHeight: CGFloat = 40
        
        var animationDuration: TimeInterval = 0.5
        
        var contentBackgroundColor: UIColor = UIColor.lightGray
        var headerBackgroundColor: UIColor = UIColor.white
        var confirmButtonColor: UIColor = UIColor.init(red: 143/255, green: 87/255, blue: 152/255, alpha: 1)
        var cancelButtonColor: UIColor = UIColor.black
        
        var overlayBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.7)
        
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
        return UINib.init(nibName: String(describing: self), bundle: nil).instantiate(withOwner: self, options: nil).last as! MIDatePicker
    }
    
    // MARK: - IBAction
    @IBAction func confirmButtonDidTapped(_ sender: AnyObject) {
        
        config.startDate = datePicker.date
        
        dismiss()
        delegate?.miDatePicker(self, didSelect: datePicker.date)
        
    }
    @IBAction func cancelButtonDidTapped(_ sender: AnyObject) {
        dismiss()
        delegate?.miDatePickerDidCancelSelection(self)
    }
    
    // MARK: - Private
    fileprivate func setup(_ parentVC: UIViewController) {
        
        // Loading configuration
        
        if let startDate = config.startDate {
            datePicker.date = startDate
        }
        
        headerViewHeightConstraint.constant = config.headerHeight
        
        confirmButton.setTitle(config.confirmButtonTitle, for: UIControlState())
        cancelButton.setTitle(config.cancelButtonTitle, for: UIControlState())
        
        confirmButton.setTitleColor(config.confirmButtonColor, for: UIControlState())
        cancelButton.setTitleColor(config.cancelButtonColor, for: UIControlState())
        
        headerView.backgroundColor = config.headerBackgroundColor
        backgroundView.backgroundColor = config.contentBackgroundColor
        
        // Overlay view constraints setup
        
        overlayButton = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        overlayButton.backgroundColor = config.overlayBackgroundColor
        overlayButton.alpha = 0
        
        overlayButton.addTarget(self, action: #selector(cancelButtonDidTapped(_:)), for: .touchUpInside)
        
        if !overlayButton.isDescendant(of: parentVC.view) { parentVC.view.addSubview(overlayButton) }
        
        overlayButton.translatesAutoresizingMaskIntoConstraints = false
        
        parentVC.view.addConstraints([
            NSLayoutConstraint(item: overlayButton, attribute: .bottom, relatedBy: .equal, toItem: parentVC.view, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .top, relatedBy: .equal, toItem: parentVC.view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .leading, relatedBy: .equal, toItem: parentVC.view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .trailing, relatedBy: .equal, toItem: parentVC.view, attribute: .trailing, multiplier: 1, constant: 0)
            ]
        )
        
        
        // Setup picker constraints
        
        frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: config.contentHeight + config.headerHeight)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: parentVC.view, attribute: .bottom, multiplier: 1, constant: 0)
        
        if !isDescendant(of: parentVC.view) { parentVC.view.addSubview(self) }
        
        parentVC.view.addConstraints([
            bottomConstraint,
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: parentVC.view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: parentVC.view, attribute: .trailing, multiplier: 1, constant: 0)
            ]
        )
        addConstraint(
            NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: frame.height)
        )
        
        move(goUp: false)
        
    }
    fileprivate func move(goUp: Bool) {
        bottomConstraint.constant = goUp ? config.bouncingOffset : config.contentHeight + config.headerHeight
    }
    
    // MARK: - Public
    func show(inVC parentVC: UIViewController, completion: (() -> ())? = nil) {
        
        setup(parentVC)
        move(goUp: true)
        
        UIView.animate(
            withDuration: config.animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseIn, animations: {
                
                parentVC.view.layoutIfNeeded()
                self.overlayButton.alpha = 1
                
            }, completion: { (finished) in
                completion?()
            }
        )
        
    }
    func dismiss(_ completion: (() -> ())? = nil) {
        
        move(goUp: false)
        
        UIView.animate(
            withDuration: config.animationDuration, animations: {
                
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
