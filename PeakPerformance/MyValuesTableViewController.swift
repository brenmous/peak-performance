//
//  MyValuesTableViewController.swift
//  PeakPerformance
//
//  Created by Benjamin Chiong on 9/1/16.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit
import SideMenu
import Firebase


class MyValuesTableViewController: UITableViewController {


// MARK: IBOutlet
    
    @IBOutlet weak var myValuesTextView: UITextView!
    @IBOutlet weak var myValuesTextView2: UITextView!
    @IBOutlet weak var myValuesTextView3: UITextView!
    @IBOutlet weak var myValuesTextView4: UITextView!
    @IBOutlet weak var myValuesTextView5: UITextView!
    @IBOutlet weak var myValuesTextView6: UITextView!

    @IBAction func menuButtonPressed(sender: UIBarButtonItem) {
                presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        


    }
    


}
