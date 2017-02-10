//
//  SignUpViewController.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com -  on 17/07/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit
import Firebase // https://firebase.google.com
import SwiftValidator //https://github.com/jpotts18/SwiftValidator


/**
    Class that controls the Sign Up view.
 */
class SignUpViewController: UIViewController, ValidationDelegate, UITextFieldDelegate {
    
    // MARK: - Properties
    
    /// DataService instance for interacting with Firebase database.
    let dataService = DataService()
    
    /// The currently authenticated user.
    var currentUser: User?
    
    /// This view controller's SwiftValidator instance.
    let validator = Validator( )
    
    
    // MARK: - Outlets
    
    //text fields
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var orgField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    //load indicators
    @IBOutlet weak var activityIndicatorSU: UIActivityIndicatorView! //BEN
    
    //labels
    @IBOutlet weak var firstNameErrorLabel: UILabel!
    @IBOutlet weak var lastNameErrorLabel: UILabel!
    @IBOutlet weak var orgErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    @IBOutlet weak var signUpErrorLabel: UILabel!
    
    //buttons
    @IBOutlet weak var signUpButton: UIButton!
    
    
    // MARK: - Actions
    
    @IBAction func signUpButtonPressed(_ sender: AnyObject)
    {
        validator.validate(self)
    }
    
    @IBAction func backToLoginPressed(_ sender: AnyObject?)
    {
        self.performSegue(withIdentifier: UNWIND_TO_LOGIN, sender: self)
    }

    
    // MARK: - Methods
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when all registered fields pass validation.
    func validationSuccessful()
    {
        signUp()
        activityIndicatorSU.startAnimating()
    }
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when a registered field fails against a validation rule.
    func validationFailed(_ errors: [(Validatable, ValidationError)]){}
    
    /// Attempts to create a new Firebase user account with supplied email and password.
    func signUp()
    {
        FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text! ) { (user, error) in
            guard let error = error else
            {
                self.firstLogin()
                return
            }
            //Check for Firebase errors and inform user of error here somewhere
            print("SUVC - signUp(): " + error.localizedDescription)
            self.activityIndicatorSU.stopAnimating()
            guard let errCode = FIRAuthErrorCode(rawValue: (error as NSError).code ) else
            {
                return
            }
            switch errCode
            {
            case .errorCodeNetworkError:
                self.signUpErrorLabel.text = NETWORK_ERR_MSG
                self.signUpErrorLabel.isHidden = false
                self.signUpButton.isEnabled = true
              
            case .errorCodeEmailAlreadyInUse:
                self.signUpErrorLabel.text = EMAIL_IN_USE_ERR_MSG
                self.signUpErrorLabel.isHidden = false
                self.signUpButton.isEnabled = true
               
            case .errorCodeInternalError:
                self.signUpErrorLabel.text = FIR_INTERNAL_ERROR
                self.signUpErrorLabel.isHidden = false
                self.signUpButton.isEnabled = true
              
            default:
                print("SUVC - signUp(): " + error.localizedDescription)
                self.signUpErrorLabel.text = FIR_INTERNAL_ERROR
                self.signUpErrorLabel.isHidden = false
                self.signUpButton.isEnabled = true
               
            }
        }
    }
    
    /// Authenticates the user with the supplied details and if succesful, creates the user object.
    func firstLogin()
    {
        //reset error label
        signUpErrorLabel.isHidden = true
        signUpErrorLabel.text = ""
        signUpButton.isEnabled = false
        FIRAuth.auth()?.signIn( withEmail: emailField.text!, password: passwordField.text! ) { (user, error) in
            guard let error = error else
            {
                self.createUser( )
                self.activityIndicatorSU.stopAnimating()
                self.performSegue(withIdentifier: FT_LOG_IN_SEGUE, sender: self)
                return
            }
            print("SUVC - firstLogin(): " + error.localizedDescription)
            self.activityIndicatorSU.stopAnimating()
            guard let errCode = FIRAuthErrorCode(rawValue: (error as NSError).code) else
            {
                return
            }
            switch errCode
            {
            case .errorCodeUserNotFound:
                self.signUpErrorLabel.text = LOGIN_ERR_MSG
                self.signUpErrorLabel.isHidden = false
                self.signUpButton.isEnabled = true
                
            case .errorCodeTooManyRequests:
                self.signUpErrorLabel.text = REQUEST_ERR_MSG
                self.signUpErrorLabel.isHidden = false
                self.signUpButton.isEnabled = true
                
            case .errorCodeNetworkError:
                self.signUpErrorLabel.text = NETWORK_ERR_MSG
                self.signUpErrorLabel.isHidden = false
                self.signUpButton.isEnabled = true
                
            case .errorCodeInternalError:
                self.signUpErrorLabel.text = FIR_INTERNAL_ERROR
                self.signUpErrorLabel.isHidden = false
                self.signUpButton.isEnabled = true
                
            default:
                print("LUVC - firstLogin(): " + error.localizedDescription)
                self.signUpErrorLabel.text = FIR_INTERNAL_ERROR
                self.signUpErrorLabel.isHidden = false
                self.signUpButton.isEnabled = true
            }
        }
    }
    
    /// Creates a new user and save details to database.
    func createUser()
    {
        guard let user = FIRAuth.auth()?.currentUser else
        {
            // - FIXME: Inform user of firebase error and kick them to root view
            return
        }
        
        let fname = firstNameField.text!
        let lname = lastNameField.text!
        let org = orgField.text!
        let email = emailField.text!
        let uid = user.uid as String
        let startDate = Date()
        
        self.currentUser = User(fname: fname, lname: lname, org: org, email: email, uid: uid, startDate: startDate)
        
        self.dataService.saveUser(self.currentUser!)
        
    }
    
    
    // MARK: - Overriden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up SwiftValidator style transformers (modifying the field/error label based on success or failure).
        //This should pretty much stay the same for all controllers and text fields.
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
        
        //Registering fields to be validated by SwiftValidator.
        //Params for registration are the text field, the label to display the error and an array of validation rules which can also each take an error message as an argument.
        //See "jpotss18.github.io/SwiftValidator" for the docs and various rules.
        //Custom rules can be created but if this framework doesn't work I can build a custom module, but for now it's working pretty good.
        
        //first name field
        validator.registerField(firstNameField, errorLabel: firstNameErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG), AlphaRule( message: ALPHA_CHAR_ERR_MSG)] )
        
        //last name field
        validator.registerField(lastNameField, errorLabel: lastNameErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG), AlphaRule( message: ALPHA_CHAR_ERR_MSG)] )
        
        //org field
        validator.registerField(orgField, errorLabel: orgErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG ), AlphaRule( message: ALPHA_CHAR_ERR_MSG)] )
        
        //email field
        validator.registerField(emailField, errorLabel: emailErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG), EmailRule( message: BAD_EMAIL_ERR_MSG)] )
        
        //username field
        //validator.registerField(userNameField, errorLabel: userNameErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG), AlphaNumericRule( message: ALPHA_NUMERIC_CHAR_ERR_MSG) ] )
        
        //password field
        validator.registerField(passwordField, errorLabel: passwordErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG), MinLengthRule(length: PW_MIN_LEN, message: SHORTPW_ERR_MSG ), MaxLengthRule(length: PW_MAX_LEN, message: LONGPW_ERR_MSG), PasswordRule( message: BADPW_ERR_MSG ) ] )
        
        //confirm password field
        validator.registerField(confirmPasswordField, errorLabel: confirmPasswordErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG), ConfirmationRule( confirmField: passwordField, message: CONPW_ERR_MSG)])
        
        //textfield delegation
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        orgField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //clear fields
        firstNameField.text = ""
        lastNameField.text = ""
        orgField.text = ""
        emailField.text = ""
        passwordField.text = ""
        confirmPasswordField.text = ""
        
        //hide error labels
        firstNameErrorLabel.isHidden = true
        lastNameErrorLabel.isHidden = true
        orgErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        confirmPasswordErrorLabel.isHidden = true
        signUpErrorLabel.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        activityIndicatorSU.stopAnimating()
    }
    
    // BEN //
    // Inverts colour of the status bar.
    override var preferredStatusBarStyle : UIStatusBarStyle
    {
        return UIStatusBarStyle.lightContent
    }
    // END BEN //
    
    
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segue.identifier!
        {
        case FT_LOG_IN_SEGUE:
            let dvc = segue.destination as! TutorialViewController
            dvc.currentUser = self.currentUser
            
        default:
            return
        }
    }
}
