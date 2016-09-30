//
//  YearReviewViewController.swift
//  PeakPerformance
//
//  Created by Bren on 29/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit

class YearReviewViewController: UITableViewController {

    // MARK: - Properties
    
    var currentUser: User?
    
    
    // MARK: - Outlets
    @IBOutlet weak var reasonsForDifferencesTextView: UITextView!
    
    @IBOutlet weak var observedAboutMyPerformanceTextView: UITextView!
    
    @IBOutlet weak var changedMyPerformance: UITextView!
    

    
    // MARK: - Overriden Methods

    
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
        let dvc = segue.destinationViewController as! SecondYearReviewViewController
        dvc.currentUser = self.currentUser
    }

}
