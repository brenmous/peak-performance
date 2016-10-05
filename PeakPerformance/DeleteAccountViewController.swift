//
//  ChangePasswordViewController.swift
//  PeakPerformance
//
//  Created by Bren on 23/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit
import SideMenu
import FirebaseAuth
import SwiftValidator // https://github.com/jpotts18/SwiftValidator

class DeleteAccountViewController: UIViewController, ValidationDelegate, UITextFieldDelegate
{
    
    // MARK: - Properties
    
    let dataService = DataService()
    
    var currentUser: User?
    
    let validator = Validator( )

    // MARK: - Outlets
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
  
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    @IBOutlet weak var deleteAccountErrorLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loadScreenBackground: UIView!
    
    // MARK: - Actions
    
    @IBAction func pressConfirmBarButton(sender: UIBarButtonItem)
    {
        validator.validate(self)
    }
    
    
    // MARK: - Methods
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when all registered fields pass validation.
    func validationSuccessful()
    {
        self.reauthenticateUser()
    }
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when a registered field fails against a validation rule.
    func validationFailed(errors: [(Validatable, ValidationError)]){}
    
    /// Deletes the currently authenticated user's account.
    func deleteAccount()
    {
        self.loadScreenBackground.hidden = false
        self.activityIndicator.startAnimating()
        let user = FIRAuth.auth()?.currentUser
        self.dataService.removeUser(self.currentUser!)
        user?.deleteWithCompletion { (error) in
            guard let error = error else
            {
                self.activityIndicator.stopAnimating()
                self.presentViewController(self.getDeleteAccountSuccessAlert(), animated: true, completion: nil)
                return
            }
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
        self.loadScreenBackground.hidden = false
        self.activityIndicator.startAnimating()
        self.deleteAccountErrorLabel.hidden = true
        self.deleteAccountErrorLabel.text = ""
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        guard let cu = currentUser else
        {
            return
        }
        
        let user = FIRAuth.auth()?.currentUser
        let credential = FIREmailPasswordAuthProvider.credentialWithEmail(cu.email, password: self.passwordField.text!)
        user?.reauthenticateWithCredential(credential) { (error) in
            guard let error = error else
            {
                self.reauthSuccess()
                return
            }
            self.reauthFailure(error)
            return
        }
    }
    
    /// Called when a user successfully reauthenticates.
    func reauthSuccess()
    {
        self.activityIndicator.stopAnimating()
        self.loadScreenBackground.hidden = true
        self.presentViewController(getDeleteAccountAlert(), animated: true, completion: nil)
    }
    
    /// Called when a user fails to reauthenticate.
    func reauthFailure(error: NSError)
    {
        self.loadScreenBackground.hidden = true
        self.activityIndicator.stopAnimating()
        guard let errCode = FIRAuthErrorCode( rawValue: error.code) else
        {
            print("CPVC - reauthUser(): auth failed but could not get error code.")
            return
        }
        switch errCode
        {
        case .ErrorCodeUserNotFound:
            self.deleteAccountErrorLabel.text = LOGIN_ERR_MSG
            return
            
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
    
    // MARK: - Alert controllers
    /**
        Creates an alert controller asking user to confirm account deletion.
            - Returns: an alert controller.
     */
    func getDeleteAccountAlert() -> UIAlertController
    {
        let deleteAccountAlertController = UIAlertController(title: DELETE_ACCOUNT_ALERT_TITLE, message: DELETE_ACCOUNT_ALERT_MSG, preferredStyle: .ActionSheet)
        let confirm = UIAlertAction(title: DELETE_ACCOUNT_ALERT_CONFIRM, style: .Destructive) { (action) in
            self.deleteAccount()
        }
        
        let cancel = UIAlertAction(title: DELETE_ACCOUNT_ALERT_CANCEL, style: .Cancel ) { (action) in
            self.activityIndicator.stopAnimating()
            self.navigationItem.rightBarButtonItem?.enabled = true
            self.passwordField.text = ""
            self.confirmPasswordField.text = ""
        }
        
        deleteAccountAlertController.addAction(confirm); deleteAccountAlertController.addAction(cancel)
        
        return deleteAccountAlertController
    }
    
    /**
        Creates an alert controller informing the user that account deletion was successful.
            - Returns: an alert controller.
     */
    func getDeleteAccountSuccessAlert() -> UIAlertController
    {
        let deleteAccountSuccessAlertController = UIAlertController(title: DELETE_ACCOUNT_SUCC_ALERT_TITLE, message: DELETE_ACCOUNT_SUCC_ALERT_MSG, preferredStyle: .ActionSheet)
        
        let confirm = UIAlertAction(title: DELETE_ACCOUNT_SUCC_ALERT_CONFIRM, style: .Default) { (action) in
            let smnav = self.presentingViewController as! UISideMenuNavigationController
            let sm = smnav.viewControllers[0]
            sm.dismissViewControllerAnimated(false) {
                sm.performSegueWithIdentifier(UNWIND_TO_LOGIN, sender: sm)
            }
        }
        
        deleteAccountSuccessAlertController.addAction(confirm)
        
        return deleteAccountSuccessAlertController
    }
    
    // MARK: - Overridden methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Load Screen Background
        loadScreenBackground.hidden = true
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
