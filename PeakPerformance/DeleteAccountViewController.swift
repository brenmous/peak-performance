//
//  ChangePasswordViewController.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 23/09/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit
import SideMenu // https://github.com/jonkykong/SideMenu
import FirebaseAuth // https://firebase.google.com
import SwiftValidator // https://github.com/jpotts18/SwiftValidator

class DeleteAccountViewController: UIViewController, ValidationDelegate, UITextFieldDelegate
{
    
    // MARK: - Properties
    
    /// DataService instance for Firebase database interaction.
    let dataService = DataService()
    
    /// The currently authenticated user.
    var currentUser: User?
    
    /// SwiftValidator instance.
    let validator = Validator( )

    // MARK: - Outlets
    
    // Text fields
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
  
    // Error labels
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    @IBOutlet weak var deleteAccountErrorLabel: UILabel!
    
    // Load indicators
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! //BEN
    @IBOutlet weak var loadScreenBackground: UIView! //BEN
    
    // MARK: - Actions
    
    @IBAction func pressConfirmBarButton(_ sender: UIBarButtonItem)
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
    func validationFailed(_ errors: [(Validatable, ValidationError)]){}
    
    /// Deletes the currently authenticated user's account.
    func deleteAccount()
    {
        self.loadScreenBackground.isHidden = false
        self.activityIndicator.startAnimating()
        let user = FIRAuth.auth()?.currentUser
        self.dataService.removeUser(self.currentUser!)
        user?.delete { (error) in
            guard let error = error else
            {
                self.activityIndicator.stopAnimating()
                self.loadScreenBackground.isHidden = true
                self.present(self.getDeleteAccountSuccessAlert(), animated: true, completion: nil)
                return
            }
            guard let errCode = FIRAuthErrorCode( rawValue: (error as NSError).code ) else
            {
                print("DAVC - deleteAccount(): delete failed with error but couldn't get error code")
                return
            }
            switch errCode
            {
            case .errorCodeRequiresRecentLogin:
                print("DAVC - deleteAccount(): invalid credential, user alerted in reauthUser()")
                
            default:
                break
            }
            self.activityIndicator.stopAnimating()
            self.loadScreenBackground.isHidden = true
            self.deleteAccountErrorLabel.isHidden = false
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    /// Reauthenticates the current user
    func reauthenticateUser()
    {
        self.loadScreenBackground.isHidden = false
        self.activityIndicator.startAnimating()
        self.deleteAccountErrorLabel.isHidden = true
        self.deleteAccountErrorLabel.text = ""
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        guard let cu = currentUser else
        {
            return
        }
        
        let user = FIRAuth.auth()?.currentUser
        let credential = FIREmailPasswordAuthProvider.credential(withEmail: cu.email, password: self.passwordField.text!)
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
        self.present(getDeleteAccountAlert(), animated: true, completion: nil)
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
            self.deleteAccountErrorLabel.text = LOGIN_ERR_MSG
            return
            
        case .errorCodeTooManyRequests:
            self.deleteAccountErrorLabel.text = REQUEST_ERR_MSG
            
        case .errorCodeNetworkError:
            self.deleteAccountErrorLabel.text = NETWORK_ERR_MSG
            
        case .errorCodeInternalError:
            self.deleteAccountErrorLabel.text = FIR_INTERNAL_ERROR
            
        case .errorCodeUserDisabled:
            self.deleteAccountErrorLabel.text = USER_DISABLED_ERROR
            
        case .errorCodeWrongPassword:
            self.deleteAccountErrorLabel.text = CHANGE_PW_ERROR
            
        case .errorCodeUserMismatch:
            self.deleteAccountErrorLabel.text = LOGIN_ERR_MSG
            
        default:
            print("CPVC - reauthUser(): error case not currently covered - \(error.localizedDescription)") //DEBUG
            self.deleteAccountErrorLabel.text = "Error case not currently covered." //DEBUG
        }
        self.deleteAccountErrorLabel.isHidden = false
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    // MARK: - Alert controllers
    /**
        Creates an alert controller asking user to confirm account deletion.
            - Returns: an alert controller.
     */
    func getDeleteAccountAlert() -> UIAlertController
    {
        let deleteAccountAlertController = UIAlertController(title: DELETE_ACCOUNT_ALERT_TITLE, message: DELETE_ACCOUNT_ALERT_MSG, preferredStyle: .actionSheet)
        let confirm = UIAlertAction(title: DELETE_ACCOUNT_ALERT_CONFIRM, style: .destructive) { (action) in
            self.deleteAccount()
        }
        
        let cancel = UIAlertAction(title: DELETE_ACCOUNT_ALERT_CANCEL, style: .cancel ) { (action) in
            self.activityIndicator.stopAnimating()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
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
        let deleteAccountSuccessAlertController = UIAlertController(title: DELETE_ACCOUNT_SUCC_ALERT_TITLE, message: DELETE_ACCOUNT_SUCC_ALERT_MSG, preferredStyle: .actionSheet)
        
        let confirm = UIAlertAction(title: DELETE_ACCOUNT_SUCC_ALERT_CONFIRM, style: .default) { (action) in
            let smnav = self.presentingViewController as! UISideMenuNavigationController
            let sm = smnav.viewControllers[0]
            sm.dismiss(animated: false) {
                sm.performSegue(withIdentifier: UNWIND_TO_LOGIN, sender: sm)
            }
        }
        
        deleteAccountSuccessAlertController.addAction(confirm)
        
        return deleteAccountSuccessAlertController
    }
    
    // MARK: - Overridden methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // BEN //
        // Load Screen Background
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

        // password field
        validator.registerField(passwordField, errorLabel: passwordErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG)])
        
        // confirm password field
        validator.registerField(confirmPasswordField, errorLabel: confirmPasswordErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG), ConfirmationRule( confirmField: passwordField, message: CONPW_ERR_MSG)])
        
        // text field delegation
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //hide labels
        self.passwordErrorLabel.isHidden = true
        self.confirmPasswordErrorLabel.isHidden = true
        self.deleteAccountErrorLabel.isHidden = true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Keyboard
    
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
