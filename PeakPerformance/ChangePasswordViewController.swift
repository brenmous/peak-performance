//
//  ChangePasswordViewController.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 23/09/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit
import FirebaseAuth // https://firebase.google.com
import SwiftValidator // https://github.com/jpotts18/SwiftValidator

class ChangePasswordViewController: UIViewController, ValidationDelegate, UITextFieldDelegate
{

    // MARK: - Properties
    
    /// The currently authenticated user.
    var currentUser: User?
    
    /// SwiftValidator instance.
    let validator = Validator( )
    
    // MARK: - Outlets
    
    // Text fields
    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    // Error labels
    @IBOutlet weak var currentPasswordErrorLabel: UILabel!
    @IBOutlet weak var newPasswordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    @IBOutlet weak var changePasswordErrorLabel: UILabel!

    // Load indicators
    @IBOutlet weak var loadScreenBackground: UIView! //BEN
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! //BEN

    
    // MARK: - Actions

    @IBAction func pressConfirmBarButton(_ sender: UIBarButtonItem)
    {
        validator.validate(self)
    }
    
    
    // MARK: - Methods
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when all registered fields pass validation.
    func validationSuccessful()
    {
        reauthenticateUser()
    }
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when a registered field fails against a validation rule.
    func validationFailed(_ errors: [(Validatable, ValidationError)]){}
    
    /// Change the currently authenticated user's password.
    func changePassword( )
    {
        loadScreenBackground.isHidden = false
        activityIndicator.startAnimating()
        changePasswordErrorLabel.isHidden = true
        changePasswordErrorLabel.text = ""
        let user = FIRAuth.auth()?.currentUser
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        user?.updatePassword(self.newPasswordField.text!) { (error) in
            guard let error = error else
            {
                self.loadScreenBackground.isHidden = true
                self.activityIndicator.stopAnimating()
                self.present(self.getChangePasswordAlert(), animated: true) {
                    self.currentPasswordField.text = ""
                    self.newPasswordField.text = ""
                    self.confirmPasswordField.text = ""
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                }
                return
            }
            guard let errCode = FIRAuthErrorCode( rawValue: (error as NSError).code ) else
            {
                print("CPVC - changePassword(): change password failed with error but couldn't get error code")
                return
            }
            switch errCode
            {
            case .errorCodeInvalidCredential:
                print("CPVC - changePassword(): invalid credential, user alerted in reauthUser()")
                
            default:
                break
            }
            self.activityIndicator.stopAnimating()
            self.loadScreenBackground.isHidden = true
            self.changePasswordErrorLabel.isHidden = false
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    /// Reauthenticates the current user
    func reauthenticateUser()
    {
        self.loadScreenBackground.isHidden = false
        self.activityIndicator.startAnimating()
        self.changePasswordErrorLabel.isHidden = true
        self.changePasswordErrorLabel.text = ""
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        guard let cu = currentUser else
        {
            return
        }
        
        let user = FIRAuth.auth()?.currentUser
        let credential = FIREmailPasswordAuthProvider.credential(withEmail: cu.email, password: self.currentPasswordField.text!)
        user?.reauthenticate(with: credential) { (error) in
            guard let error = error else
            {
                self.reauthSuccess()
                return
            }
            self.reauthFailure(error as NSError)
            return
        }
    }
    
    /// Called when a user successfully reauthenticates.
    func reauthSuccess()
    {
        self.activityIndicator.stopAnimating()
        self.loadScreenBackground.isHidden = true
        changePassword()
    }
    
    /// Called when a user fails to reauthenticate.
    func reauthFailure(_ error: NSError)
    {
        self.loadScreenBackground.isHidden = true
        self.activityIndicator.stopAnimating()
        guard let errCode = FIRAuthErrorCode( rawValue: error.code) else
        {
            print("CPVC - reauthUser(): auth failed but could not get error code.")
            return
        }
        switch errCode
        {
        case .errorCodeUserNotFound:
            self.changePasswordErrorLabel.text = LOGIN_ERR_MSG
            return
            
        case .errorCodeTooManyRequests:
            self.changePasswordErrorLabel.text = REQUEST_ERR_MSG
            
        case .errorCodeNetworkError:
            self.changePasswordErrorLabel.text = NETWORK_ERR_MSG
            
        case .errorCodeInternalError:
            self.changePasswordErrorLabel.text = FIR_INTERNAL_ERROR
            
        case .errorCodeUserDisabled:
            self.changePasswordErrorLabel.text = USER_DISABLED_ERROR
            
        case .errorCodeWrongPassword:
            self.changePasswordErrorLabel.text = CHANGE_PW_ERROR
            
        case .errorCodeUserMismatch:
            self.changePasswordErrorLabel.text = LOGIN_ERR_MSG
            
        default:
            print("CPVC - reauthUser(): error case not currently covered - \(error.localizedDescription)") //DEBUG
            self.changePasswordErrorLabel.text = "Error case not currently covered." //DEBUG
        }
        self.changePasswordErrorLabel.isHidden = false
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }

    
    // MARK: - Alert controllers
    
    /**
        Creates an alert controller informing the user that their password change was successful.
     
        - Returns: an alert controller.
     */
    func getChangePasswordAlert() -> UIAlertController
    {
        let changePWAlertController = UIAlertController(title: CHANGEPW_ALERT_TITLE, message: CHANGEPW_ALERT_MSG, preferredStyle: .actionSheet)
        let confirm = UIAlertAction(title: CHANGEPW_ALERT_CONFIRM, style: .default) { (action) in
            self.performSegue(withIdentifier: UNWIND_FROM_CHANGE_PW_SEGUE, sender: self)
        }
        
        changePWAlertController.addAction(confirm)
        
        return changePWAlertController
    }
    
    // MARK: - Overridden methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // BEN //
        loadScreenBackground.isHidden = true
        // Back button 
        self.navigationController!.navigationBar.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1);
        // END BEN //
        
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
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //clear fields
        self.newPasswordErrorLabel.text = ""
        self.confirmPasswordField.text = ""
        self.currentPasswordErrorLabel.text = ""
        self.changePasswordErrorLabel.text = ""
        
        //hide labels
        self.currentPasswordErrorLabel.isHidden = true
        self.newPasswordErrorLabel.isHidden = true
        self.confirmPasswordErrorLabel.isHidden = true
        self.changePasswordErrorLabel.isHidden = true
        
        //enable change password button
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - keyboard stuff
    
    /// Dismisses keyboard when return is pressed.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        validator.validate( self )
        textField.resignFirstResponder()
        return true
    }
    
    /// Dismisses keyboard when tap outside keyboard detected.
    override func touchesBegan( _ touchers: Set<UITouch>, with event: UIEvent? )
    {
        self.view.endEditing(true)
    }

}
