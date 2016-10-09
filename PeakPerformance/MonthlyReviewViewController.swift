//
//  MonthlyReviewViewController.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 6/09/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit

class MonthlyReviewViewController: UITableViewController {

    /// The currently logged in user.
    var currentUser: User?
    
    /// The summary being reviewed.
    var summary: MonthlySummary?
    
    // MARK: - Outlets
    
    @IBOutlet weak var familySlider: UISlider!
    @IBOutlet weak var friendsSlider: UISlider!
    @IBOutlet weak var partnerSlider: UISlider!
    @IBOutlet weak var workSlider: UISlider!
    @IBOutlet weak var healthSlider: UISlider!
    @IBOutlet weak var personalDevelopmentSlider: UISlider!
    @IBOutlet weak var financeSlider: UISlider!
    @IBOutlet weak var emotionalSpiritualSlider: UISlider!
    
    
    // MARK: - Actions
    @IBAction func nextButtonPushed(sender: AnyObject)
    {
        updateSummaryWithSliderValues( )
    
        //go to next view
        performSegueWithIdentifier(GO_TO_SECOND_REVIEW_SEGUE, sender: self)
    }
    
    /// Get values from sliders and save to self.summary
    func updateSummaryWithSliderValues( )
    {
        guard let s = self.summary else
        {
            print("MRVC: could not get summary")
            return
        }
        s.klaRatings[KLA_FAMILY] = Double(self.familySlider.value)
        s.klaRatings[KLA_FRIENDSSOCIAL] = Double(self.friendsSlider.value)
        s.klaRatings[KLA_PARTNER] = Double(self.partnerSlider.value)
        s.klaRatings[KLA_WORKBUSINESS] = Double(self.workSlider.value)
        s.klaRatings[KLA_HEALTHFITNESS] = Double(self.healthSlider.value)
        s.klaRatings[KLA_PERSONALDEV] = Double(self.personalDevelopmentSlider.value)
        s.klaRatings[KLA_FINANCIAL] = Double(self.financeSlider.value)
        s.klaRatings[KLA_EMOSPIRITUAL] = Double(self.emotionalSpiritualSlider.value)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.tintColor = UIColor.init(red: 54/255, green: 54/255, blue: 52/255, alpha: 1);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - Navigation


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == GO_TO_SECOND_REVIEW_SEGUE
        {
            let dvc = segue.destinationViewController as! SecondMonthlyReviewViewController
            dvc.currentUser = self.currentUser
            dvc.summary = self.summary
        }
    }
    

}
