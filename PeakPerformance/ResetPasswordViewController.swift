//
//  ResetPasswordViewController.swift
//  PeakPerformance
//
//  Created by Bren on 9/08/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit
import SwiftValidator
import Firebase

class ResetPasswordViewController: UIViewController, ValidationDelegate, UITextFieldDelegate
{
    
    // MARK: - Properties
    
    /// SwiftValidator instance.
    let validator = Validator( )
    
    // MARK: - Outlets
    @IBOutlet weak var resetPasswordErrorLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    @IBOutlet weak var activityIndicatorReset: UIActivityIndicatorView!
    // MARK: - Actions
   
    @IBAction func resetPasswordButtonPressed(sender: AnyObject)
    {
        validator.validate(self)
        activityIndicatorReset.startAnimating()
    }
    
    @IBAction func logInButtonPressed(sender: AnyObject)
    {
        //unwind to log in (storyboard)
    }
    
    
    // MARK: - Methods
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when all registered fields pass validation.
    func validationSuccessful()
    {
        print ("RPVC: validation successful") //DEBUG
        resetPassword( )
        activityIndicatorReset.stopAnimating()
    }
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when a registered field fails against a validation rule.
    func validationFailed(errors: [(Validatable, ValidationError)])
    {
        print ("RPVC: validation failed") //DEBUG
       
    }
    
    func resetPassword( )
    {
        //reset error label
        self.resetPasswordErrorLabel.hidden = true
        self.resetPasswordErrorLabel.text = ""
        self.resetPasswordButton.enabled = false
        FIRAuth.auth( )?.sendPasswordResetWithEmail(emailField.text!, completion: {
            error in
            guard let error = error else
            {
                //No error, send email
                print("RPVC: password reset successful")
                self.activityIndicatorReset.stopAnimating()
                self.resetPasswordErrorLabel.text = RESET_EMAIL_SENT
                self.resetPasswordErrorLabel.hidden = false
                self.resetPasswordButton.enabled = true
                return
            }
            print("RPVC: error resetting password - " + error.localizedDescription ) // DEBUG
            guard let errCode = FIRAuthErrorCode( rawValue: error.code ) else
            {
                return
            }
            switch errCode
            {
            case .ErrorCodeUserNotFound:
                self.resetPasswordErrorLabel.text = LOGIN_ERR_MSG
                self.resetPasswordErrorLabel.hidden = false
                self.resetPasswordButton.enabled = true
                
            case .ErrorCodeTooManyRequests:
                self.resetPasswordErrorLabel.text = REQUEST_ERR_MSG
                self.resetPasswordErrorLabel.hidden = false
                self.resetPasswordButton.enabled = true
                
            case .ErrorCodeNetworkError:
                self.resetPasswordErrorLabel.text = NETWORK_ERR_MSG
                self.resetPasswordErrorLabel.hidden = false
                self.resetPasswordButton.enabled = true
                
            case .ErrorCodeInternalError:
                self.resetPasswordErrorLabel.text = FIR_INTERNAL_ERROR
                self.resetPasswordErrorLabel.hidden = false
                self.resetPasswordButton.enabled = true
                
            case .ErrorCodeUserDisabled:
                self.resetPasswordErrorLabel.text = USER_DISABLED_ERROR
                self.resetPasswordErrorLabel.hidden = false
                self.resetPasswordButton.enabled = true
                
            default:
                print("RPVC: error case not currently covered") //DEBUG
                self.resetPasswordErrorLabel.text = "Error case not currently covered." //DEBUG
                self.resetPasswordErrorLabel.hidden = false
                self.resetPasswordButton.enabled = true
            }
        })
    }
    
    // MARK: - keyboard stuff
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

    override func viewDidLoad()
    {
        super.viewDidLoad()

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
        
        //register fields for validation
        //email field
        validator.registerField(emailField, errorLabel: emailErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG), EmailRule( message: BAD_EMAIL_ERR_MSG)] )
        
        //set up text field delegates
        emailField.delegate = self
    }
    // MARK: Override Functions
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //hide error labels
        resetPasswordErrorLabel.hidden = true
        emailErrorLabel.hidden = true
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
