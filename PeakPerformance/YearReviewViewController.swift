//
//  YearReviewViewController.swift
//  PeakPerformance
//
//  Created by Bren Moushall on 29/09/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let dvc = segue.destinationViewController as! SecondYearReviewViewController
        dvc.currentUser = self.currentUser
    }

}
