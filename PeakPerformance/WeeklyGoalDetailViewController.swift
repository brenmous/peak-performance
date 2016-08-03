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
    func saveModifiedGoal( weeklyGoal: WeeklyGoal )
}

class WeeklyGoalDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
{

    // MARK: - Properties
    
    /// This view controller's delegate.
    var delegate: WeeklyGoalDetailViewControllerDelegate?
    
    /// The currently authenticated user.
    var currentUser: User?
    
    /// The goal currently being edited.
    var currentGoal: WeeklyGoal?
    
    /// Key life areas for the KLA picker.
    var keyLifeAreas = [KLA_FAMILY, KLA_EMOSPIRITUAL, KLA_FINANCIAL, KLA_FRIENDSSOCIAL, KLA_HEALTHFITNESS,
                        KLA_PARTNER, KLA_PERSONALDEV, KLA_WORKBUSINESS]
    
    // MARK: - Outlets
    
    //text fields
    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var klaTextField: UITextField!
    @IBOutlet weak var deadlineTextField: UITextField!
    
    //pickers
    @IBOutlet weak var klaPicker: UIPickerView!
    @IBOutlet weak var deadlinePicker: UIDatePicker!
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(sender: AnyObject)
    {
        //if there's no current goal, make a new one...
        if currentGoal == nil
        {
            createNewWeeklyGoal( )
        }
        //...otherwise modify the referenced goal
        else
        {
            updateGoal( )
        }
    }

    //unhide pickers when their selection button is pressed
    @IBAction func klaButtonPressed(sender: AnyObject)
    {
        klaPicker.hidden = false
    }
    @IBAction func deadlineButtonPressed(sender: AnyObject)
    {
        deadlinePicker.hidden = false
    }

    
    // MARK: - Methods
    
    /// This method creates a new weekly goal using the text fields and passes it to its delegate, where it is saved.
    func createNewWeeklyGoal( )
    {
        //VALIDATE THESE FIELDS, currently temporary setup
        let goalText = goalTextView.text!
        let kla = klaTextField.text!
        let deadline = deadlineTextField.text!
        guard let cu = currentUser else
        {
            return
        }
        let gid = "\(NSUUID().UUIDString)" + "-\(cu.uid)"
        let wg = WeeklyGoal(goalText: goalText, kla: kla, deadline: deadline, gid: gid)
        delegate?.addNewGoal(wg)
    }
    
    /// This method updates an existing weekly goal using the text field and passes it to its delegate, where it is saved.
    func updateGoal( )
    {
        guard let cg = currentGoal else
        {
            return
        }
        cg.goalText = goalTextView.text!
        cg.kla = klaTextField.text!
        let dateFormatter = NSDateFormatter( )
        dateFormatter.dateFormat = DATE_FORMAT_STRING
        guard let dl = dateFormatter.dateFromString(deadlineTextField.text!) else
        {
            return
        }
        cg.deadline = dl
        delegate?.saveModifiedGoal(cg)
    }
    
    /// This method fills the text field with details from the goal selected for editing.
    func updateTextFields( )
    {
        guard let cg = currentGoal else
        {
            return
        }
        goalTextView.text = cg.goalText
        klaTextField.text = cg.kla
        let dateFormatter = NSDateFormatter( )
        dateFormatter.dateFormat = DATE_FORMAT_STRING
        deadlineTextField.text = dateFormatter.stringFromDate(cg.deadline)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //hide pickers
        klaPicker.hidden = true
        deadlinePicker.hidden = true
        
        //update textfields if editing a goal
        if currentGoal != nil
        {
            self.updateTextFields( )
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        klaPicker.dataSource = self
        klaPicker.delegate = self
        
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
    
    // MARK: - KLA Picker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return keyLifeAreas.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return keyLifeAreas[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        klaTextField.text = keyLifeAreas[row]
        klaPicker.hidden = true
    }
    
    // MARK: - Deadline picker
    
    @IBAction func deadlinePickerActivated(sender: AnyObject)
    {
        let dateFormatter = NSDateFormatter( )
        dateFormatter.dateFormat = DATE_FORMAT_STRING
        let deadline = dateFormatter.stringFromDate(deadlinePicker.date)
        deadlineTextField.text = deadline
        deadlinePicker.hidden = true
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
