//
//  WeeklyGoalDetailViewController.swift
//  PeakPerformance
//
//  Created by Bren on 2/08/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit

protocol WeeklyGoalDetailViewControllerDelegate
{
    func addNewGoal( weeklyGoal: WeeklyGoal )
}

class WeeklyGoalDetailViewController: UIViewController
{

    // MARK: - Properties
    
    /// This view controller's delegate.
    var delegate: WeeklyGoalDetailViewControllerDelegate?
    
    /// The currently authenticated user.
    var currentUser: User?
    
    // MARK: - Outlets
    
    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var klaTextField: UITextField!
    @IBOutlet weak var deadlineTextField: UITextField!
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(sender: AnyObject)
    {
        self.createNewWeeklyGoal( )
        
    }
    
    // MARK: - Methods
    
    func createNewWeeklyGoal( )
    {
        //VALIDATE THESE FIELDS, currently temporary setup
        let goalText = goalTextView.text!
        let kla = KLA_FAMILY //TEMP
        let deadline = "01/01/2017" //TEMP
        guard let cu = currentUser else
        {
            return
        }
        let gid = "\(NSUUID().UUIDString)" + "-\(cu.uid)"
        let wg = WeeklyGoal(goalText: goalText, kla: kla, deadline: deadline, gid: gid)
        delegate?.addNewGoal(wg)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Check if user is authenticated
        if currentUser == nil
        {
            //handle error/reauthenticate
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
