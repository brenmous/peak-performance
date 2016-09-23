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

class ChangePasswordViewController: UIViewController, ValidationDelegate, UITextFieldDelegate
{

    // MARK: - Properties
    var currentUser: User?
    
    let validator = Validator( )
    
    // MARK: - Outlets
    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBOutlet weak var currentPasswordErrorLabel: UILabel!
    @IBOutlet weak var newPasswordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    @IBOutlet weak var changePasswordErrorLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var changePasswordButton: UIButton!
    
    // MARK: - Actions
    @IBAction func changePasswordPressed( sender: AnyObject )
    {
        validator.validate(self)
    }
    
    // MARK: - Methods
    @IBAction func pressConfirmBarButton(sender: UIBarButtonItem) {
        validator.validate(self)
    }
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when all registered fields pass validation.
    func validationSuccessful()
    {
        print ("CPVC - validation successful") //DEBUG
        self.changePassword()
    }
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when a registered field fails against a validation rule.
    func validationFailed(errors: [(Validatable, ValidationError)])
    {
        print ("CPVC - validation failed")
    }
    
    /// Change a user's password.
    func changePassword( )
    {
        activityIndicator.startAnimating()
        print("CPVC - changePassword(): attempting to change password...")
        //reset error label & disable button
        self.changePasswordErrorLabel.hidden = true
        self.changePasswordErrorLabel.text = ""
//        self.changePasswordButton.enabled = false
        
        print("CPVC - changePassword(): attemping to reauthenticate user...")
        guard let cu = currentUser else
        {
            return
        }
        
        let user = FIRAuth.auth()?.currentUser
        let credential = FIREmailPasswordAuthProvider.credentialWithEmail(cu.email, password: self.currentPasswordField.text!)
        user?.reauthenticateWithCredential(credential) { (error) in
            //handle reauth error
            guard let error = error else
            {
                //reauth successful
                print("CPVC - reauthUser(): auth successful")
                user?.updatePassword(self.newPasswordField.text!) { (error) in
                    guard let error = error else
                    {
                        //inform user of password change success
                        print("CPVC - changePassword(): password change successful")
                        self.activityIndicator.stopAnimating()
                        self.presentViewController(UIAlertController.getChangePasswordAlert(self), animated: true ) {
                            self.currentPasswordField.text = ""
                            self.newPasswordField.text = ""
                            self.confirmPasswordField.text = ""
//                            self.changePasswordButton.enabled = true
                        }
                        return
                    }
                    //handle pw change error
                    print("CPVC - changePassword(): failed to change password")
                    guard let errCode = FIRAuthErrorCode( rawValue: error.code ) else
                    {
                        print("CPVC - changePassword(): got FIRAuth error, but no error code")
                        return
                    }
                    switch errCode
                    {
                    case .ErrorCodeInvalidCredential:
                        print("CPVC - changePassword(): invalid credential, user alerted in reauthUser()")
                        
                    default:
                        break
                    }
                    self.changePasswordErrorLabel.hidden = false
//                    self.changePasswordButton.enabled = true
                }
                return
            }
            guard let errCode = FIRAuthErrorCode( rawValue: error.code) else
            {
                return
            }
            print("CPVC - reauthUser(): auth failed")
            switch errCode
            {
            case .ErrorCodeUserNotFound:
                self.changePasswordErrorLabel.text = LOGIN_ERR_MSG
                
            case .ErrorCodeTooManyRequests:
                self.changePasswordErrorLabel.text = REQUEST_ERR_MSG
                
            case .ErrorCodeNetworkError:
                self.changePasswordErrorLabel.text = NETWORK_ERR_MSG
                
            case .ErrorCodeInternalError:
                self.changePasswordErrorLabel.text = FIR_INTERNAL_ERROR
                
            case .ErrorCodeUserDisabled:
                self.changePasswordErrorLabel.text = USER_DISABLED_ERROR
                
            case .ErrorCodeWrongPassword:
                self.changePasswordErrorLabel.text = CHANGE_PW_ERROR
                
            case .ErrorCodeUserMismatch:
                self.changePasswordErrorLabel.text = LOGIN_ERR_MSG
                
            default:
                print("CPVC - reauthUser(): error case not currently covered - \(error.localizedDescription)") //DEBUG
                self.changePasswordErrorLabel.text = "Error case not currently covered." //DEBUG
            }
            self.changePasswordErrorLabel.hidden = false
//            self.changePasswordButton.enabled = true
        }
    }
    
    /*
    /// Reauthenticate the currently logged in user.
    func reauthUser( user: FIRUser ) -> Bool?
    {
        print("CPVC - reauthUser(): attemping to reauthenticate user...")
        guard let cu = currentUser else
        {
            return false
        }
        var success: Bool? = nil
        let user = FIRAuth.auth()?.currentUser
        let credential = FIREmailPasswordAuthProvider.credentialWithEmail(cu.email, password: self.currentPasswordField.text!)
        user?.reauthenticateWithCredential(credential) { (error) in
            //handle reauth error
            guard let error = error else
            {
                //reauth successful
                print("CPVC - reauthUser(): auth successful")
                success = true
                return
            }
            guard let errCode = FIRAuthErrorCode( rawValue: error.code) else
            {
                return
            }
            print("CPVC - reauthUser(): auth failed")
            switch errCode
            {
            case .ErrorCodeUserNotFound:
                self.changePasswordErrorLabel.text = LOGIN_ERR_MSG
                
            case .ErrorCodeTooManyRequests:
                self.changePasswordErrorLabel.text = REQUEST_ERR_MSG
                
            case .ErrorCodeNetworkError:
                self.changePasswordErrorLabel.text = NETWORK_ERR_MSG
                
            case .ErrorCodeInternalError:
                self.changePasswordErrorLabel.text = FIR_INTERNAL_ERROR
                
            case .ErrorCodeUserDisabled:
                self.changePasswordErrorLabel.text = USER_DISABLED_ERROR
                
            case .ErrorCodeWrongPassword:
                self.changePasswordErrorLabel.text = CHANGE_PW_ERROR
                
            case .ErrorCodeUserMismatch:
                self.changePasswordErrorLabel.text = LOGIN_ERR_MSG
                
            default:
                print("CPVC - reauthUser(): error case not currently covered - \(error.localizedDescription)") //DEBUG
                self.changePasswordErrorLabel.text = "Error case not currently covered." //DEBUG
            }
            self.changePasswordErrorLabel.hidden = false
            self.changePasswordButton.enabled = true
            success = false
        }
        while( success == nil ){} //FIXME: - potential infinite loop
        return success
    } */

    
    
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
        
        // current password field
        validator.registerField(currentPasswordField, errorLabel: currentPasswordErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG)])
        
        // new password field
        validator.registerField(newPasswordField, errorLabel: newPasswordErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG), MinLengthRule(length: PW_MIN_LEN, message: SHORTPW_ERR_MSG ), MaxLengthRule(length: PW_MAX_LEN, message: LONGPW_ERR_MSG), PasswordRule( message: BADPW_ERR_MSG ) ] )
        
        // confirm password field
        validator.registerField(confirmPasswordField, errorLabel: confirmPasswordErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG), ConfirmationRule( confirmField: newPasswordField, message: CONPW_ERR_MSG)])
        
        // text field delegation
        currentPasswordField.delegate = self
        newPasswordField.delegate = self
        confirmPasswordField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //clear fields
        self.newPasswordErrorLabel.text = ""
        self.confirmPasswordField.text = ""
        self.currentPasswordErrorLabel.text = ""
        self.changePasswordErrorLabel.text = ""
        
        //hide labels
        self.currentPasswordErrorLabel.hidden = true
        self.newPasswordErrorLabel.hidden = true
        self.confirmPasswordErrorLabel.hidden = true
        self.changePasswordErrorLabel.hidden = true
        
        //enable change password button
//        self.changePasswordButton.enabled = true
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

}
