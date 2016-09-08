//
//  MonthlyReviewViewController.swift
//  PeakPerformance
//
//  Created by Bren on 6/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
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
        
        for (key, val) in self.summary!.klaRatings
        {
            print("\(key) rated at \(val)")
        }
        //go to next view
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
