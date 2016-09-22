//
//  LoginViewController.swift
//  PeakPerformance
//
//  Created by Bren on 17/07/2016.
//  Copyright © 2016 Bren. All rights reserved.
//

import UIKit
import Firebase
import SwiftValidator //https://github.com/jpotts18/SwiftValidator

//TODO: - Load summaries from database
//TODO: - speed up initial load

/**
    Class that controls the Log In view.
 */
class LoginViewController: UIViewController, ValidationDelegate, UITextFieldDelegate {
 
    // MARK: - Properties
    
    /// The currently authenticated user.
    var currentUser: User?
    
    /// This view controller's SwiftValidator instance.
    let validator = Validator( )
    
    
    // MARK: - Outlets
    
    //text fields
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //labels
    @IBOutlet weak var logInErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    //buttons
    @IBOutlet weak var logInButton: UIButton!

    
    // MARK: - Actions
    
    @IBAction func logInButtonPressed(sender: AnyObject)
    {
        validator.validate(self)
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject)
    {
        shouldPerformSegueWithIdentifier( GO_TO_SIGN_UP_SEGUE , sender: self )
    }
    
    @IBAction func resetPasswordButtonPressed(sender: AnyObject)
    {
        shouldPerformSegueWithIdentifier( GO_TO_RESET_PW_SEGUE, sender: self )
    }
    
    @IBAction func unwindFromSignUp(segue: UIStoryboardSegue){ }
    
    @IBAction func unwindFromWGVC( segue: UIStoryboardSegue)
    {
        
    }
    
    // MARK: - Methods
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when all registered fields pass validation.
    func validationSuccessful()
    {
        print ("LIVC: validation successful") //DEBUG
        self.login()
        activityIndicator.startAnimating()
    }
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when a registered field fails against a validation rule.
    func validationFailed(errors: [(Validatable, ValidationError)])
    {
        print ("LIVC: validation failed") //DEBUG
        activityIndicator.stopAnimating()
    }

    /// Attempts to authenticate a user using supplied details.
    func login()
    {
        //reset login error label
        self.logInErrorLabel.hidden = true
        self.logInErrorLabel.text = ""
        self.logInButton.enabled = false
        
        FIRAuth.auth()?.signInWithEmail( emailField.text!, password: passwordField.text!, completion:  {
            user, error in
            guard let error = error else {
                //Auth successful so fetch user and content
                self.fetchUser()
                return
            }
            self.activityIndicator.stopAnimating()
            print("LIVC: error logging in - " + error.localizedDescription) //DEBUG
            guard let errCode = FIRAuthErrorCode( rawValue: error.code ) else {
                return
            }
            switch errCode
            {
            case .ErrorCodeUserNotFound:
                self.logInErrorLabel.text = LOGIN_ERR_MSG
                self.logInErrorLabel.hidden = false
                self.logInButton.enabled = true
                
            case .ErrorCodeTooManyRequests:
                self.logInErrorLabel.text = REQUEST_ERR_MSG
                self.logInErrorLabel.hidden = false
                self.logInButton.enabled = true
                
            case .ErrorCodeNetworkError:
                self.logInErrorLabel.text = NETWORK_ERR_MSG
                self.logInErrorLabel.hidden = false
                self.logInButton.enabled = true
                
            case .ErrorCodeInternalError:
                self.logInErrorLabel.text = FIR_INTERNAL_ERROR
                self.logInErrorLabel.hidden = false
                self.logInButton.enabled = true
                
            case .ErrorCodeUserDisabled:
                self.logInErrorLabel.text = USER_DISABLED_ERROR
                self.logInErrorLabel.hidden = false
                self.logInButton.enabled = true
                
            case .ErrorCodeWrongPassword:
                self.logInErrorLabel.text = WRONG_PW_ERROR
                self.logInErrorLabel.hidden = false
                self.logInButton.enabled = true
                
            default:
                print("LIVC: error case not currently covered") //DEBUG
                self.logInErrorLabel.text = "Error case not currently covered." //DEBUG
                self.logInErrorLabel.hidden = false
                self.logInButton.enabled = true
            }
        })
    }
    
    /// This method fetches the user and their content from the database.
    func fetchUser( )
    {
        guard let user = FIRAuth.auth()?.currentUser else
        {
            //couldn't auth user -- handle it here
            return
        }
        print("LIVC: authenticated user \(user.uid)")
        
        //how many layers of indentation are you on?
        //like maybe 5 or 6 right now my dude
        //you are like a baby, watch this
        
        //Fetch user and content
        DataService.loadUser( user.uid ) { (user) in
            self.currentUser = user
            
            DataService.loadWeeklyGoals( user.uid ) { ( weeklyGoals ) in
                user.weeklyGoals = weeklyGoals
                
                DataService.loadMonthlyGoals(user.uid) { ( monthlyGoals) in
                    user.monthlyGoals = monthlyGoals
                    
                    DataService.loadDreams(user.uid) { (dreams) in
                        user.dreams = dreams
                        
                        DataService.loadValues(user.uid) { (values) in
                            user.values = values
                            
                            DataService.loadSummaries(user) { (summaries) in
                                user.monthlySummaries = summaries
                                
                            
                            print("LIVC: content fetched, going to home screen")
                            self.performSegueWithIdentifier(LOGGED_IN_SEGUE, sender: self)
                            
                            
                            }
                        }
                    }
                }
            }
        }
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
    
    
    // MARK: - Overridden methods
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
        
        //password field
        validator.registerField(passwordField, errorLabel: passwordErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG)] )
        
        
        //set up text field delegates
        emailField.delegate = self
        passwordField.delegate = self
    
        //Comment these lines out to use other accounts
//        emailField.text = "laura.johnson@hmail.com"
//        passwordField.text = "Password1"
//        validator.validate(self)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //reset fields
        self.emailField.text = ""
        self.passwordField.text = ""
        
        //hide error labels
        logInErrorLabel.hidden = true
        emailErrorLabel.hidden = true
        passwordErrorLabel.hidden = true
        
        //enable log in button
        logInButton.enabled = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        activityIndicator.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // status bar invert color
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == LOGGED_IN_SEGUE
        {
            let dvc = segue.destinationViewController as! TabBarViewController
            dvc.currentUser = self.currentUser
        }
        else if segue.identifier == GO_TO_SIGN_UP_SEGUE
        {
            
        }
    }
    

}
