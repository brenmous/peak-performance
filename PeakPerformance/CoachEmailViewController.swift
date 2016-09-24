//
//  CoachEmailViewController.swift
//  PeakPerformance
//
//  Created by Bren on 25/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit
import SwiftValidator

class CoachEmailViewController: UIViewController, UITextFieldDelegate, ValidationDelegate {

    // MARK: - Properties
    
    var currentUser: User?
    
    let validator = Validator( )
    
    // MARK: - Outlets
    
    @IBOutlet weak var currentCoachEmailLabel: UILabel!
    @IBOutlet weak var newCoachEmailErrorLabel: UILabel!
    @IBOutlet weak var changeCoachEmailErrorLabel: UILabel!
    
    @IBOutlet weak var newCoachEmailField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        DataService.saveCoachEmail(self.currentUser!)
        self.activityIndicator.stopAnimating()
        self.presentViewController(UIAlertController.getChangeCoachEmailSuccessAlert(self), animated: true, completion: nil)
    }
    
    // MARK: - Overridden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Back button
        self.navigationController!.navigationBar.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1);
        
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
        self.currentCoachEmailLabel.text =  ce.isEmpty ? "No coach!" : ce
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: - Keyboard
    
    //Dismisses keyboard when return is pressed.
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        validator.validate( self )
        textField.resignFirstResponder()
        return true
    }
    
    //Dismisses keyboard when tap outside keyboard detected.
    override func touchesBegan( touchers: Set<UITouch>, withEvent event: UIEvent? )
    {
        self.view.endEditing(true)
    }
   

}
