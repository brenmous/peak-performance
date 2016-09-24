//
//  ChangePasswordViewController.swift
//  PeakPerformance
//
//  Created by Bren on 23/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftValidator // https://github.com/jpotts18/SwiftValidator

class DeleteAccountViewController: UIViewController, ValidationDelegate, UITextFieldDelegate
{
    
    // MARK: - Properties
    var currentUser: User?
    
    
    let validator = Validator( )
    
    // MARK: - Outlets
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
  
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    @IBOutlet weak var deleteAccountErrorLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Actions
    
    @IBAction func pressConfirmBarButton(sender: UIBarButtonItem) {
        validator.validate(self)
    }
    
    
    // MARK: - Methods
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when all registered fields pass validation.
    func validationSuccessful()
    {
        print ("DAVC - validation successful") //DEBUG
        self.reauthenticateUser()
    }
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when a registered field fails against a validation rule.
    func validationFailed(errors: [(Validatable, ValidationError)])
    {
        print ("DAVC - validation failed")
    }
    
    func deleteAccount()
    {
        self.activityIndicator.startAnimating()
        let user = FIRAuth.auth()?.currentUser
        DataService.removeUser(self.currentUser!)
        user?.deleteWithCompletion { (error) in
            guard let error = error else
            {
                //success
                self.activityIndicator.stopAnimating()
                self.presentViewController(UIAlertController.getDeleteAccountSuccessAlert(self), animated: true, completion: nil)
                return
            }
            DataService.saveUser(self.currentUser!)
            //failure
            guard let errCode = FIRAuthErrorCode( rawValue: error.code ) else
            {
                print("DAVC - deleteAccount(): delete failed with error but couldn't get error code")
                return
            }
            switch errCode
            {
            case .ErrorCodeRequiresRecentLogin:
                print("DAVC - deleteAccount(): delete failed, requires recent login - handled by reauth")
                
            default:
                break
            }
            self.activityIndicator.stopAnimating()
            self.deleteAccountErrorLabel.hidden = false
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
    }
    
    /// Reauthenticates the current user
    func reauthenticateUser()
    {
        activityIndicator.startAnimating()
        //reset error label & disable button
        self.deleteAccountErrorLabel.hidden = true
        self.deleteAccountErrorLabel.text = ""
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        print("DAVC - deleteAccount(): attemping to reauthenticate user...")
        guard let cu = currentUser else
        {
            return
        }
        
        let user = FIRAuth.auth()?.currentUser
        let credential = FIREmailPasswordAuthProvider.credentialWithEmail(cu.email, password: self.passwordField.text!)
        user?.reauthenticateWithCredential(credential) { (error) in
            guard let error = error else
            {
                //reauth successful
                print("CPVC - reauthUser(): auth successful")
                self.activityIndicator.stopAnimating()
                
                //show destructive alert
                self.presentViewController(UIAlertController.getDeleteAccountAlert(self), animated: true, completion: nil)
                
                return
            }
            //handle reauth error
            guard let errCode = FIRAuthErrorCode( rawValue: error.code) else
            {
                return
            }
            print("CPVC - reauthUser(): auth failed")
            self.activityIndicator.stopAnimating()
            switch errCode
            {
            case .ErrorCodeUserNotFound:
                self.deleteAccountErrorLabel.text = LOGIN_ERR_MSG
                
            case .ErrorCodeTooManyRequests:
                self.deleteAccountErrorLabel.text = REQUEST_ERR_MSG
                
            case .ErrorCodeNetworkError:
                self.deleteAccountErrorLabel.text = NETWORK_ERR_MSG
                
            case .ErrorCodeInternalError:
                self.deleteAccountErrorLabel.text = FIR_INTERNAL_ERROR
                
            case .ErrorCodeUserDisabled:
                self.deleteAccountErrorLabel.text = USER_DISABLED_ERROR
                
            case .ErrorCodeWrongPassword:
                self.deleteAccountErrorLabel.text = CHANGE_PW_ERROR
                
            case .ErrorCodeUserMismatch:
                self.deleteAccountErrorLabel.text = LOGIN_ERR_MSG
                
            default:
                print("CPVC - reauthUser(): error case not currently covered - \(error.localizedDescription)") //DEBUG
                self.deleteAccountErrorLabel.text = "Error case not currently covered." //DEBUG
            }
            self.deleteAccountErrorLabel.hidden = false
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
    }
    
    
    // MARK: - Overridden methods
    
    override func viewDidLoad()
    {
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

        // password field
        validator.registerField(passwordField, errorLabel: passwordErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG)])
        
        // confirm password field
        validator.registerField(confirmPasswordField, errorLabel: confirmPasswordErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG), ConfirmationRule( confirmField: passwordField, message: CONPW_ERR_MSG)])
        
        // text field delegation
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        
        
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //hide labels
        self.passwordErrorLabel.hidden = true
        self.confirmPasswordErrorLabel.hidden = true
        self.deleteAccountErrorLabel.hidden = true
    }
    
    
    override func didReceiveMemoryWarning()
    {
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
