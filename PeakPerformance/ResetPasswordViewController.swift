//
//  ResetPasswordViewController.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 9/08/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit
import SwiftValidator // https://github.com/jpotts18/SwiftValidator
import Firebase // https://firebase.google.com

/**
    Class that handles the reset password view.
 */
class ResetPasswordViewController: UIViewController, ValidationDelegate, UITextFieldDelegate
{
    
    // MARK: - Properties
    
    /// SwiftValidator instance.
    let validator = Validator( )
    
    
    // MARK: - Outlets
    
    //Labels
    @IBOutlet weak var resetPasswordErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    //Fields
    @IBOutlet weak var emailField: UITextField!
    
    //Load indicators
    @IBOutlet weak var activityIndicatorReset: UIActivityIndicatorView! //BEN
    
    
    // MARK: - Actions
   
    @IBAction func resetPasswordButtonPressed(_ sender: AnyObject)
    {
        validator.validate(self)
        activityIndicatorReset.startAnimating()
    }
    
    @IBAction func logInButtonPressed(_ sender: AnyObject){
    self.performSegue(withIdentifier: UNWIND_TO_LOGIN, sender: self)
    } //unwind to login (storyboard segue)
    
    
    // MARK: - Methods
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when all registered fields pass validation.
    func validationSuccessful()
    {
        print ("RPVC: validation successful") //DEBUG
        resetPassword()
        activityIndicatorReset.stopAnimating()
    }
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when a registered field fails against a validation rule.
    func validationFailed(_ errors: [(Validatable, ValidationError)])
    {
        print ("RPVC: validation failed") //DEBUG
       
    }
    
    /// Sends a reset password email to the currently authenticated user.
    func resetPassword()
    {
        //reset error label
        resetPasswordErrorLabel.isHidden = true
        resetPasswordErrorLabel.text = ""
        resetPasswordButton.isEnabled = false
        FIRAuth.auth( )?.sendPasswordReset(withEmail: emailField.text!, completion: {
            error in
            guard let error = error else
            {
                self.activityIndicatorReset.stopAnimating()
                self.resetPasswordErrorLabel.text = RESET_EMAIL_SENT
                self.resetPasswordErrorLabel.isHidden = false
                self.resetPasswordButton.isEnabled = true
                return
            }
            print("RPVC - resetPassword() " + error.localizedDescription)
            guard let errCode = FIRAuthErrorCode( rawValue: (error as NSError).code ) else
            {
                return
            }
            switch errCode
            {
            case .errorCodeUserNotFound:
                self.resetPasswordErrorLabel.text = LOGIN_ERR_MSG
                self.resetPasswordErrorLabel.isHidden = false
                self.resetPasswordButton.isEnabled = true
                
            case .errorCodeTooManyRequests:
                self.resetPasswordErrorLabel.text = REQUEST_ERR_MSG
                self.resetPasswordErrorLabel.isHidden = false
                self.resetPasswordButton.isEnabled = true
                
            case .errorCodeNetworkError:
                self.resetPasswordErrorLabel.text = NETWORK_ERR_MSG
                self.resetPasswordErrorLabel.isHidden = false
                self.resetPasswordButton.isEnabled = true
                
            case .errorCodeInternalError:
                self.resetPasswordErrorLabel.text = FIR_INTERNAL_ERROR
                self.resetPasswordErrorLabel.isHidden = false
                self.resetPasswordButton.isEnabled = true
                
            case .errorCodeUserDisabled:
                self.resetPasswordErrorLabel.text = USER_DISABLED_ERROR
                self.resetPasswordErrorLabel.isHidden = false
                self.resetPasswordButton.isEnabled = true
                
            default:
                print("RPVC - resetPassword() " + error.localizedDescription)
                self.resetPasswordErrorLabel.text = FIR_INTERNAL_ERROR
                self.resetPasswordErrorLabel.isHidden = false
                self.resetPasswordButton.isEnabled = true
            }
        })
    }
    
    // MARK: - keyboard stuff
    /// Dismisses keyboard when return is pressed.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        validator.validate(self)
        textField.resignFirstResponder()
        return true
    }
    
    /// Dismisses keyboard when tap outside keyboard detected.
    override func touchesBegan(_ touchers: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

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
        
        //register fields for validation
        //email field
        validator.registerField(emailField, errorLabel: emailErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG), EmailRule( message: BAD_EMAIL_ERR_MSG)] )
        
        //set up text field delegates
        emailField.delegate = self
    }
    
    // MARK: Override Functions
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //clear field
        emailField.text = ""
        
        //hide error labels
        resetPasswordErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // BEN //
    /// Inverts the status bar colour.
    override var preferredStatusBarStyle : UIStatusBarStyle
    {
        return UIStatusBarStyle.lightContent
    }
    // END BEN //
}
