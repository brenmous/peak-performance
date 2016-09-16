//
//  UITableViewExtensions.swift
//  PeakPerformance
//
//  Created by Bren on 14/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import Foundation
import UIKit
import SideMenu
import SwiftValidator

// MARK: - UIViewController
extension UIViewController
{
    //  - Loads the burger icon with the badge if a monthly review is available
    //  - Sets up a UIImage and a Highlighted UIImage and a button and assigns it to leftBarButtonItem
    //  - ENMBadgedBarButtonItem is responsible for the badge
    
    func setUpLeftBarButtonItem( number: String )
    {
        
        let image = UIImage(named: MENU_ICON_NAME)
        let highlightedImage = UIImage(named: MENU_ICON_HIGHLIGHTED_NAME)
        let button = UIButton(type: .Custom)
        
        if let knownImage = image {
            button.frame = CGRectMake(0.0, 0.0, knownImage.size.width, knownImage.size.height)
        } else {
            button.frame = CGRectZero;
        }
        
        button.setBackgroundImage(image, forState: UIControlState.Normal)
        button.setBackgroundImage(highlightedImage, forState: .Highlighted)
        button.addTarget(self,
                         action: #selector(leftButtonPressed(_:)),
                         forControlEvents: UIControlEvents.TouchUpInside)
        button.adjustsImageWhenHighlighted = true
        button.tintColor = UIColor.lightGrayColor()
        let newBarButton = ENMBadgedBarButtonItem(customView: button, value: number) // parameter value for the number inside the dot
        newBarButton.badgeValue = number  // sets the dot and the number inside
        navigationItem.leftBarButtonItem = newBarButton
    }
}

extension UIViewController
{
    // function to Bar Button item tap
    func leftButtonPressed(_sender: UIButton)
    {
        presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
        navigationItem.leftBarButtonItem?.tintColor = UIColor.lightGrayColor()
    }
}


//MARK: - SideMenu
extension SideMenuManager
{
    /// Set up side menu in view controllers that should be able to display it.
    public class func setUpSideMenu( sb: UIStoryboard, user: User )
    {
        SideMenuManager.menuLeftNavigationController = UISideMenuNavigationController( )
        SideMenuManager.menuLeftNavigationController?.navigationBarHidden = true // hides the navigation bar
        SideMenuManager.menuLeftNavigationController?.leftSide = true
        let smvc = sb.instantiateViewControllerWithIdentifier(SIDE_MENU_VC) as! SideMenuViewController
        smvc.currentUser = user
        smvc.sb = sb
        SideMenuManager.menuLeftNavigationController?.setViewControllers([smvc], animated: true)
        
        // Pan Gestures
        
        SideMenuManager.menuAddPanGestureToPresent(toView: (menuLeftNavigationController?.navigationBar)!)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: (menuLeftNavigationController?.navigationBar)!)
        
        // Customize side menu
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuPresentMode = .MenuSlideIn
        SideMenuManager.menuShadowOpacity = 0.5
        SideMenuManager.menuBlurEffectStyle = .Light
        SideMenuManager.menuAnimationFadeStrength = 0.5
    }
}


//MARK: - UITextView

// Allows UITextViews to be used with SwiftValidator.
extension UITextView: Validatable {
    
    public var validationText: String {
        return text ?? ""
    }
}

