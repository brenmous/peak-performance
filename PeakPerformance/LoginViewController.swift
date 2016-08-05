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

/*
/**
    Protocol for specifying log in DataService requirements.
 */
protocol LogInDataService
{
    func loadUser( uid: String ) -> User
}
*/

/**
    Class that controls the Log In view.
 */
class LoginViewController: UIViewController, ValidationDelegate, UITextFieldDelegate {
 
    // MARK: - Properties
    
    /// The currently authenticated user.
    var currentUser: User?
    
    /// This view controller's DataService instance.
    let dataService = DataService( )
    
    /// This view controller's SwiftValidator instance.
    let validator = Validator( )
    
    
    // MARK: - Outlets
    
    //text fields
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
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
    
    @IBAction func resetPasswordButtonPressed(sender: AnyObject) {}
    
    
    
    // MARK: - Methods
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when all registered fields pass validation.
    func validationSuccessful()
    {
        print ("LIVC: validation successful") //DEBUG
        self.login()
    }
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when a registered field fails against a validation rule.
    func validationFailed(errors: [(Validatable, ValidationError)])
    {
        print ("LIVC: validation failed") //DEBUG
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
                
            default:
                print("LIVC: error case not currently covered") //DEBUG
                self.logInErrorLabel.text = "Error case not currently covered." //DEBUG
                self.logInErrorLabel.hidden = false
                self.logInButton.enabled = true
            }
        })
    }
    
    /// This method fetches the user object from the database and sets it as the currentUser.
    /*
    Currently this loads content sequentially which is not using the full power of the async loading from Firebase.
    For now it should be okay as performance gains will be negliblblblelble but I will tweak this and try to bundle
    fetching into a single method so content loads concurrently.
    */
    func fetchUser( )
    {
        guard let user = FIRAuth.auth()?.currentUser else
        {
            //couldn't auth user -- handle it here
            return
        }
        print("LIVC: logged in")
        self.dataService.loadUser( user.uid ) { (user) in
            
            //this is the variable being passed by the completion block back in DataService
            self.currentUser = user
            
            self.dataService.loadGoals( user.uid ) { ( weeklyGoals ) in
            
                user.weeklyGoals = weeklyGoals
                
                print("LIVC: user content fetched, going to home screen")
                
                self.performSegueWithIdentifier(LOGGED_IN_SEGUE, sender: self)
            }
        }
    }
    /*
    /// This method fetches the user's weekly goals from the database sets it as the value of the weeklyGoals variable.
    func fetchWeeklyGoals( weeklyGoalIDStrings: [String] )
    {
        //If the user has no goals then go straight to weekly goal view...
        if weeklyGoalIDStrings.isEmpty
        {
            self.performSegueWithIdentifier(LOGGED_IN_SEGUE, sender: self)
            return
        }
        self.dataService.loadWeeklyGoals(weeklyGoalIDStrings)
            {
            self.weeklyGoals.appendContentsOf($0)
            self.performSegueWithIdentifier(LOGGED_IN_SEGUE, sender: self)
        }
    }
    */

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        //self.login()
        validator.validate( self )
        return true
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
        
        //password field
        validator.registerField(passwordField, errorLabel: passwordErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG)] )
        
        
        //set up text field delegates
        emailField.delegate = self
        passwordField.delegate = self

    
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //hide error labels
        logInErrorLabel.hidden = true
        emailErrorLabel.hidden = true
        passwordErrorLabel.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
