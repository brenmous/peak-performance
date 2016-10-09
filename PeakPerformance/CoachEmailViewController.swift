//
//  CoachEmailViewController.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 25/09/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit
import SwiftValidator // https://github.com/jpotts18/SwiftValidator

class CoachEmailViewController: UIViewController, UITextFieldDelegate, ValidationDelegate {

    // MARK: - Properties
    
    /// DataService instance for Firebase Database interactions.
    let dataService = DataService()
    
    /// The currently authenticated user.
    var currentUser: User?
    
    /// SwiftValidator instance.
    let validator = Validator( )
    
    // MARK: - Outlets
    
    // Labels
    @IBOutlet weak var currentCoachEmailLabel: UILabel!
    @IBOutlet weak var newCoachEmailErrorLabel: UILabel!
    @IBOutlet weak var changeCoachEmailErrorLabel: UILabel!
    
    // Text fields
    @IBOutlet weak var newCoachEmailField: UITextField!
    
    // Load indicators
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! // BEN
 
    // MARK: - Actions
    @IBAction func confirmButtonPressed(sender: UIBarButtonItem)
    {
        validator.validate(self)
    }
    
    
    // MARK: - Methods
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when all registered fields pass validation.
    func validationSuccessful()
    {
        self.navigationItem.rightBarButtonItem!.enabled = false
        self.activityIndicator.startAnimating()
        self.changeCoachEmail()
    }
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when a registered field fails against a validation rule.
    func validationFailed(errors: [(Validatable, ValidationError)])
    {
        self.navigationItem.rightBarButtonItem!.enabled = true
        self.activityIndicator.stopAnimating()
    }
    
    /// Change user's coach email with the entered email.
    func changeCoachEmail()
    {
        self.currentUser?.coachEmail = self.newCoachEmailField.text!
        self.dataService.saveCoachEmail(self.currentUser!)
        self.activityIndicator.stopAnimating()
        self.presentViewController(getChangeCoachEmailSuccessAlert(), animated: true, completion: nil)
    }
    
    // MARK: - Alert controllers
    /**
     Creates an alert controller informing user that change of coach email was successful.
     - Parameters:
     - cevc: the change coach email view controller.
     
     - Returns: an alert controller.
     */
    func getChangeCoachEmailSuccessAlert() -> UIAlertController
    {
        let changeCoachEmailSucccessAlertController = UIAlertController(title: COACH_EMAIL_SUCC_ALERT_TITLE, message: COACH_EMAIL_SUCC_ALERT_MSG, preferredStyle: .ActionSheet)
        
        let confirm = UIAlertAction(title: COACH_EMAIL_SUCC_ALERT_CONFIRM, style: .Default) { (action) in
            self.performSegueWithIdentifier(UNWIND_FROM_COACH_EMAIL_SEGUE, sender: self)
        }
        
        changeCoachEmailSucccessAlertController.addAction(confirm)
        
        return changeCoachEmailSucccessAlertController
    }
    
    // MARK: - Overridden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // BEN //
        // Back button
        self.navigationController!.navigationBar.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1);
        // END BEN //
        
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
        
        // register fields for validation
        
        // email field
        validator.registerField(newCoachEmailField, errorLabel: newCoachEmailErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG), EmailRule( message: BAD_EMAIL_ERR_MSG)])
      
        
        // text field delegation
        newCoachEmailField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //hide labels
        self.newCoachEmailErrorLabel.hidden = true
        self.changeCoachEmailErrorLabel.hidden = true
        
        let ce = self.currentUser!.coachEmail
        self.currentCoachEmailLabel.text =  ce.isEmpty ? NO_COACH_EMAIL_MESSAGE : ce
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: - Keyboard
    
    /// Dismisses keyboard when return is pressed.
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        validator.validate( self )
        textField.resignFirstResponder()
        return true
    }
    
    /// Dismisses keyboard when tap outside keyboard detected.
    override func touchesBegan( touchers: Set<UITouch>, withEvent event: UIEvent? )
    {
        self.view.endEditing(true)
    }
   

}
