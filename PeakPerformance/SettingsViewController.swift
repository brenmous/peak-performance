//
//  SettingsViewController.swift
//  PeakPerformance
//
//  Created by Bren on 23/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    // MARK: - Properties
    var currentUser: User?
    
    // MARK: - Actions
    @IBAction func unwindToSettings( sender: UIStoryboardSegue){}
    
    // MARK: - Outlets
    @IBAction func backButtonPressed( sender: AnyObject )
    {
        self.performSegueWithIdentifier(UNWIND_FROM_SETTINGS_SEGUE, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        switch segue.identifier!
        {
        case GO_TO_CHANGE_PASSWORD_SEGUE:
            let dvc = segue.destinationViewController as! ChangePasswordViewController
            dvc.currentUser = self.currentUser
            
        case SETTINGS_TO_DELETE_ACCOUNT_SEGUE:
            let dvc = segue.destinationViewController as! DeleteAccountViewController
            dvc.currentUser = self.currentUser
            
        default:
            return
        }
    }
    

}
