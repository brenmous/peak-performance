//
//  WeeklyGoalDetailViewController.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 2/08/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit
import SwiftValidator // https://github.com/jpotts18/SwiftValidator
import ActionSheetPicker_3_0 // https://github.com/TimCinel/ActionSheetPicker
import SideMenu // https://github.com/jonkykong/SideMenu

protocol MonthlyGoalDetailViewControllerDelegate
{
    func addNewGoal( _ monthlyGoal: MonthlyGoal )
    func saveModifiedGoal( _ monthlyGoal: MonthlyGoal)
}

class MonthlyGoalDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, ValidationDelegate, UITextViewDelegate
{
    
    // MARK: - Properties
    
    /// This view controller's delegate.
    var delegate: MonthlyGoalDetailViewControllerDelegate?
    
    /// The currently authenticated user.
    var currentUser: User?
    
    /// The goal currently being edited.
    var currentGoal: MonthlyGoal?
    
    /// Key life areas for the KLA picker.
    let keyLifeAreas = [KLA_FAMILY, KLA_EMOSPIRITUAL, KLA_FINANCIAL, KLA_FRIENDSSOCIAL, KLA_HEALTHFITNESS, KLA_PARTNER, KLA_PERSONALDEV, KLA_WORKBUSINESS]

    /// SwiftValidator instance.
    let validator = Validator( )
 
    // MARK: - Outlets
    
    //text fields
    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var klaTextField: UITextField!
    @IBOutlet weak var deadlineTextField: UITextField!
    
    //pickers
    @IBOutlet weak var klaPicker: UIPickerView!
    @IBOutlet weak var deadlinePicker: UIDatePicker!
    
    //error labels
    @IBOutlet weak var goalTextErrorLabel: UILabel!
    @IBOutlet weak var klaErrorLabel: UILabel!
    @IBOutlet weak var deadlineErrorLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(_ sender: AnyObject)
    {
        //dismiss keyboard
        self.view.endEditing(true)
        
        validator.validate(self)
    }
    
    @IBAction func klaButtonPressed(_ sender: AnyObject) //Ben
    {
        //dismiss keyboard
        self.view.endEditing(true)
        
        let acp = ActionSheetMultipleStringPicker(title: "Key Life Area", rows: [keyLifeAreas], initialSelection: [3], doneBlock: {
            picker, values, indexes in
            
            // trimming the index values
            let newValue = String(describing: values)
            let trimmedPunctuationWithNewValue = newValue.trimmingCharacters(in: CharacterSet.punctuationCharacters)
            let trimmedSpaceWithNewValue = trimmedPunctuationWithNewValue.trimmingCharacters(in: CharacterSet.whitespaces)
            let index = Int(trimmedSpaceWithNewValue)
            // assign to textfield 
            self.klaTextField.text = self.keyLifeAreas[index!]
            return
            }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
        
        acp?.show()
        
    }
    
    @IBAction func deadlineButtonPressed(_ sender: AnyObject) //Ben
    {
        //dismiss keyboard
        self.view.endEditing(true)
        
        guard let cu = self.currentUser else
        {
            return
        }
        let monthsOfTheYear = Date().monthlyDatePickerStringArray(cu.startDate)
        let acp = ActionSheetMultipleStringPicker(title: "Deadline", rows: [monthsOfTheYear], initialSelection: [0], doneBlock: {
            picker, values, indexes in
            
            // trimming the index values
            let newValue = String(describing: values)
            let trimmedPunctuationWithNewValue = newValue.trimmingCharacters(in: CharacterSet.punctuationCharacters)
            let trimmedSpaceWithNewValue = trimmedPunctuationWithNewValue.trimmingCharacters(in: CharacterSet.whitespaces)
            let index = Int(trimmedSpaceWithNewValue)
            // assign to textfield
            self.deadlineTextField.text = monthsOfTheYear[index!]
            return
            }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
        
        acp?.show()
    }
    
    @IBAction func menuButtonPressed(_ sender: AnyObject)
    {
        //dismiss keyboard
        self.view.endEditing(true)
        
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Methods
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when all registered fields pass validation.
    func validationSuccessful()
    {
        saveChanges( )
    }
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when a registered field fails against a validation rule.
    func validationFailed(_ errors: [(Validatable, ValidationError)]){}

    /// Saves changes to an existing goal, or creates a new one if no goal currently exists.
    func saveChanges( )
    {
        //if there's no current goal, make a new one...
        if currentGoal == nil
        {
            createNewGoal( )
        }
            //...otherwise modify the referenced goal
        else
        {
            updateGoal( )
        }
        performSegue(withIdentifier: UNWIND_FROM_MGDVC_SEGUE, sender: self)
    }
    
    /// Creates a new weekly goal object with details from text fields. Calls delegate to save goal.
    func createNewGoal( )
    {
        let goalText = goalTextView.text!
        let kla = klaTextField.text!
        let deadline = deadlineTextField.text!
        let gid = UUID( ).uuidString
        let mg = MonthlyGoal(goalText: goalText, kla: kla, deadline: deadline, gid: gid)
        delegate?.addNewGoal(mg)
    }
    
    /// Updates a currently existing goal with details from text fields. Calls delegate to save goal.
    func updateGoal( )
    {
        guard let cg = currentGoal else { return }
        cg.goalText = goalTextView.text!
        cg.kla = klaTextField.text!
        let dateFormatter = DateFormatter( )
        dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
        let deadline = deadlineTextField.text!
        guard let dl = dateFormatter.date(from: deadline) else { return }
        cg.deadline = dl
        delegate?.saveModifiedGoal(cg)
    }
    
    /// Updates text fields with details from the current goal (if available).
    func updateTextFields( )
    {
        guard let cg = currentGoal else { return }
        goalTextView.text = cg.goalText
        klaTextField.text = cg.kla
        let dateFormatter = DateFormatter( )
        dateFormatter.dateFormat = MONTH_FORMAT_STRING
        deadlineTextField.text = dateFormatter.string(from: cg.deadline as Date)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //hide pickers
        klaPicker.isHidden = true
        deadlinePicker.isHidden = true
        
        //hide error labels
        goalTextErrorLabel.isHidden = true
        klaErrorLabel.isHidden = true
        deadlineErrorLabel.isHidden = true
        
        //update textfields if editing a goal
        if currentGoal != nil
        {
            self.updateTextFields( )
        }
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // set up badge and menu bar button item
        self.setUpLeftBarButtonItem( String(self.currentUser!.numberOfUnreviwedSummaries()) )
        
        // text view set up
        goalTextView.layer.cornerRadius = 5
        goalTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        goalTextView.layer.borderWidth = 1
        goalTextView.clipsToBounds = true
        
        //set up validator style transformer
        validator.styleTransformers(success: { (validationRule) -> Void in
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            if let textField = validationRule.field as? UITextField
            {
                textField.layer.borderColor = TEXTFIELD_REGULAR_BORDER_COLOUR
                textField.layer.borderWidth = CGFloat( TEXTFIELD_REGULAR_BORDER_WIDTH )
            }
            
            }, error: { (validationError ) -> Void in
                validationError.errorLabel?.isHidden = false
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
        
        //Side Menu
        SideMenuManager.setUpSideMenu(self.storyboard!, user: self.currentUser!) //func declaration is in SideMenuViewController
        
        //picker
        klaPicker.dataSource = self
        klaPicker.delegate = self
        
    }
    
    
    // MARK: - keyboard stuff
    /// Work around for dismissing keyboard on text view.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
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
    
    /// Dismisses keyboard when tap outside keyboard detected.
    override func touchesBegan( _ touchers: Set<UITouch>, with event: UIEvent? )
    {
        self.view.endEditing(true)
    }
    
    // BEN //
    // MARK: - KLA Picker

    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return keyLifeAreas.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return keyLifeAreas[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        klaTextField.text = keyLifeAreas[row]
        klaPicker.isHidden = true
    }
    // END BEN //
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}



