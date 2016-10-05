//
//  InitialSetupViewController.swift
//  PeakPerformance
//
//  Created by Bren on 16/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit


class InitialSetupViewController: UITableViewController {

    /// The currently logged in user.
    var currentUser: User?
    
    /// The Current Reality summary.
    let summary = CurrentRealitySummary( )
    
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
        performSegueWithIdentifier(GO_TO_SECOND_INITIAL_SETUP, sender: self)
    }
    
    @IBAction func reasonButtonPuhsed( sender: UIButton )
    {
        var reason = ""
        
        let reasonAlertController = UIAlertController(title: INITIAL_SETUP_ALERT_TITLE, message: INITIAL_SETUP_ALERT_MSG, preferredStyle: .ActionSheet)
        let cancel = UIAlertAction(title: INITIAL_SETUP_ALERT_CANCEL, style: .Cancel, handler: nil )
        let confirm = UIAlertAction(title: INITIAL_SETUP_ALERT_CONFIRM, style: .Default ) { (action) in
            let reasonTextField = reasonAlertController.textFields![0] as UITextField
            reason = reasonTextField.text!
        }
        reasonAlertController.addAction(confirm); reasonAlertController.addAction(cancel)
        
        let tag = sender.tag
        switch tag
        {
        case 0: //family
            self.summary.klaReasons[KLA_FAMILY] = reason
        case 1: //friends 
            self.summary.klaReasons[KLA_FRIENDSSOCIAL] = reason
        case 2: //partner
            self.summary.klaReasons[KLA_PARTNER] = reason
        case 3: //work
            self.summary.klaReasons[KLA_WORKBUSINESS] = reason
        case 4: //health
            self.summary.klaReasons[KLA_HEALTHFITNESS] = reason
        case 5: //personal dev
            self.summary.klaReasons[KLA_PERSONALDEV] = reason
        case 6: //finance 
            self.summary.klaReasons[KLA_FINANCIAL] = reason
        case 7: //emotional
            self.summary.klaReasons[KLA_EMOSPIRITUAL] = reason
        default:
            print("ISVC: tag out of range or some whack computer shit happened, I dunno I ain't getting paid for this")
            return
        }
        
    }
    
    
    /// Get values from sliders and save to self.summary
    func updateSummaryWithSliderValues( )
    {
        summary.klaRatings[KLA_FAMILY] = Double(self.familySlider.value)
        summary.klaRatings[KLA_FRIENDSSOCIAL] = Double(self.friendsSlider.value)
        summary.klaRatings[KLA_PARTNER] = Double(self.partnerSlider.value)
        summary.klaRatings[KLA_WORKBUSINESS] = Double(self.workSlider.value)
        summary.klaRatings[KLA_HEALTHFITNESS] = Double(self.healthSlider.value)
        summary.klaRatings[KLA_PERSONALDEV] = Double(self.personalDevelopmentSlider.value)
        summary.klaRatings[KLA_FINANCIAL] = Double(self.financeSlider.value)
        summary.klaRatings[KLA_EMOSPIRITUAL] = Double(self.emotionalSpiritualSlider.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.tintColor = UIColor.init(red: 54/255, green: 54/255, blue: 52/255, alpha: 1);
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    // MARK: - Navigation
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == GO_TO_SECOND_INITIAL_SETUP
        {
            let dvc = segue.destinationViewController as! SecondInitialSetupViewController
            dvc.currentUser = self.currentUser
            dvc.summary = self.summary
        }
    }
    
    
}
