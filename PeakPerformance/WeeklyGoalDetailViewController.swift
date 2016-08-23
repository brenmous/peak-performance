//
//  WeeklyGoalDetailViewController.swift
//  PeakPerformance
//
//  Created by Bren on 2/08/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit
import SwiftValidator //https://github.com/jpotts18/SwiftValidator
import ActionSheetPicker_3_0
import SideMenu

protocol WeeklyGoalDetailViewControllerDelegate
{
    func addNewGoal( weeklyGoal: WeeklyGoal )
    func saveModifiedGoal( weeklyGoal: WeeklyGoal )
}

class WeeklyGoalDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, ValidationDelegate, UITextViewDelegate
{
    
    // MARK: - Properties
    
    /// This view controller's delegate.
    var delegate: WeeklyGoalDetailViewControllerDelegate?
    
    /// The currently authenticated user.
    var currentUser: User?
    
    /// The goal currently being edited.
    var currentGoal: WeeklyGoal?
    
    /// Key life areas for the KLA picker.
    var keyLifeAreas = [KLA_FAMILY, KLA_EMOSPIRITUAL, KLA_FINANCIAL, KLA_FRIENDSSOCIAL, KLA_HEALTHFITNESS, KLA_PARTNER, KLA_PERSONALDEV, KLA_WORKBUSINESS]
    
    /// Swift validator instance.
    let validator = Validator( )
    
    // MARK: Date Picker Instance (retrieved from cocoapods)
    var datePicker = MIDatePicker.getFromNib()
    //  var kAreaPicker = MIKLAPicker.getFromNib()
    var dateFormatter = NSDateFormatter()
    
    // MARK: - Outlets
    
    //text fields
    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var klaTextField: UITextField!
    @IBOutlet weak var deadlineTextField: UITextField!
    
    //pickers
    @IBOutlet weak var klaPicker: UIPickerView!
    @IBOutlet weak var deadlinePicker: UIDatePicker!
    
    //error labels
    @IBOutlet weak var klaErrorLabel: UILabel!
    @IBOutlet weak var goalTextErrorLabel: UILabel!
    @IBOutlet weak var deadlineErrorLabel: UILabel!
    
    //buttons
    
    
    
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(sender: AnyObject)
    {
        validator.validate(self)
    }
    
    @IBAction func klaButtonPressed(sender: AnyObject)
    {
        // klaPicker.hidden = false
        let acp = ActionSheetMultipleStringPicker(title: "Key Life Area", rows: [keyLifeAreas], initialSelection: [3], doneBlock: {
                picker, values, indexes in
            
        // trimming the index values
                let newValue = String(values)
                let trimmedPunctuationWithNewValue = newValue.stringByTrimmingCharactersInSet(NSCharacterSet.punctuationCharacterSet())
                let trimmedSpaceWithNewValue = trimmedPunctuationWithNewValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                let index = Int(trimmedSpaceWithNewValue)
            
        // assign to textfield
                self.klaTextField.text = self.keyLifeAreas[index!]
                return
            }, cancelBlock: { ActionMultipleStringCancelBlock in return }, origin: sender)
        
        acp.showActionSheetPicker()
    }
    
    @IBAction func deadlineButtonPressed(sender: AnyObject)
    {
//        datePicker.show(inVC: self)
        let datePicker = ActionSheetDatePicker(title: "Date:", datePickerMode: UIDatePickerMode.Date, selectedDate: NSDate(), doneBlock: {
            picker, value, index in
            print("value = \(value)")
            let newDate = value as? NSDate
            print("newDate = \(newDate)")
            
            // assign to textfield
            self.deadlineTextField.text =  self.dateFormatter.stringFromDate(newDate!)
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender.superview!!.superview)
        
        // sets up the interval for date picker in seconds
        let secondsInWeek: NSTimeInterval = 7 * 24 * 60 * 60; // this can be changed depending on how many days are left in the week
        datePicker.minimumDate = NSDate(timeInterval: 0, sinceDate: NSDate())
        datePicker.maximumDate = NSDate(timeInterval: secondsInWeek, sinceDate: NSDate())
        
        datePicker.showActionSheetPicker()
    
    }
    
    
    // MARK: - Methods
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when all registered fields pass validation.
    func validationSuccessful()
    {
        print ("WGDVC: validation successful") //DEBUG
        
        //hide error labels
        //goalTextErrorLabel.hidden = true
        //klaErrorLabel.hidden = true
        //deadlineErrorLabel.hidden = true
        
        saveChanges( )
    }
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when a registered field fails against a validation rule.
    func validationFailed(errors: [(Validatable, ValidationError)])
    {
        print ("WGDVC: validation failed") //DEBUG
    }
    
    /// Saves changes to an existing goal, or creates a new one if no goal currently exists.
    func saveChanges( )
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
        performSegueWithIdentifier(UNWIND_FROM_WGDVC_SEGUE, sender: self)
    }
    
    /// Creates a new weekly goal object with details from text fields. Calls delegate to save goal.
    func createNewWeeklyGoal( )
    {
        let goalText = goalTextView.text!
        let kla = klaTextField.text!
        let deadline = deadlineTextField.text!
        let gid = NSUUID( ).UUIDString
        let wg = WeeklyGoal(goalText: goalText, kla: kla, deadline: deadline, gid: gid)
        delegate?.addNewGoal(wg)
    }
    
    /// Updates a currently existing goal with details from text fields. Calls delegate to save goal.
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
    
    /// Updates text fields with details from the current goal (if available).
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
    
    // MARK: - Overridden methods

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //hide pickers
        klaPicker.hidden = true
        deadlinePicker.hidden = true
        
        //hide error labels
        goalTextErrorLabel.hidden = true
        klaErrorLabel.hidden = true
        deadlineErrorLabel.hidden = true
        
        //update textfields if editing a goal
        if currentGoal != nil
        {
            self.updateTextFields( )
        }
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Picker stuff
        dateFormatter.dateFormat = "dd/MM/yyyy"
        klaPicker.dataSource = self
        klaPicker.delegate = self
        datePicker.delegate = self
        
        //Check if user is authenticated
        if currentUser == nil
        {
            //handle error/reauthenticate
        }
        
        // Do any additional setup after loading the view.
        goalTextView.layer.cornerRadius = 5
        goalTextView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        goalTextView.layer.borderWidth = 1
        goalTextView.clipsToBounds = true
        
        //set up validator style transformer
        validator.styleTransformers(success: { (validationRule) -> Void in
            validationRule.errorLabel?.hidden = true
            validationRule.errorLabel?.text = ""
            if let textField = validationRule.field as? UITextField
            {
                textField.layer.borderColor = TEXTFIELD_REGULAR_BORDER_COLOUR
                textField.layer.borderWidth = CGFloat( TEXTFIELD_REGULAR_BORDER_WIDTH )
            }
            
            }, error: { (validationError ) -> Void in
                validationError.errorLabel?.hidden = false
                validationError.errorLabel?.text = validationError.errorMessage
                if let textField = validationError.field as? UITextField
                {
                    textField.layer.borderColor = TEXTFIELD_ERROR_BORDER_COLOUR
                    textField.layer.borderWidth = CGFloat( TEXTFIELD_ERROR_BORDER_WIDTH )
                }
        })
        
        //Register fields with SwiftValidator.
        //key life area text field
        validator.registerField(klaTextField, errorLabel: klaErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG)] )
        
        //deadline text field
        validator.registerField(deadlineTextField, errorLabel: deadlineErrorLabel, rules: [RequiredRule(message: REQUIRED_FIELD_ERR_MSG)])
        
        //goal text view
        validator.registerField(goalTextView, errorLabel: goalTextErrorLabel, rules: [RequiredRule(message: REQUIRED_FIELD_ERR_MSG)])
        
        //textfield & textview delegation
        goalTextView.delegate = self
    
        
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
    
    // MARK: - keyboard stuff
    /// Work around for dismissing keyboard on text view.
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        if text == "\n"
        {
            textView.resignFirstResponder( )
            validator.validate(self)
            return false
        }
        else
        {
            return true
        }
    }
    //Dismisses keyboard when tap outside keyboard detected.
    override func touchesBegan( touchers: Set<UITouch>, withEvent event: UIEvent? )
    {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Deadline picker
    
    @IBAction func deadlinePickerActivated(sender: AnyObject)
    {

    }
    

}


extension WeeklyGoalDetailViewController: MIDatePickerDelegate {
    func miDatePicker(amDatePicker: MIDatePicker, didSelect date: NSDate) {
        let deadline = dateFormatter.stringFromDate(date)
        deadlineTextField.text = deadline
    }
    
    func miDatePickerDidCancelSelection(amDatePicker: MIDatePicker) {
        
    }
}


