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
    
    /// The user's weekly goals.
    var weeklyGoals = [WeeklyGoal]( )
    
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
    
    
    
    // MARK: - Actions
    
    @IBAction func logInButtonPressed(sender: AnyObject)
    {
        //self.login( )
        validator.validate(self)
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject)
    {
        shouldPerformSegueWithIdentifier( GO_TO_SIGN_UP_SEGUE , sender: self )
    }
    
    //@IBAction func resetPasswordButtonPressed(sender: AnyObject) {}
    
    
    
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
        logInErrorLabel.hidden = true
        logInErrorLabel.text = ""
       
        FIRAuth.auth()?.signInWithEmail( emailField.text!, password: passwordField.text!, completion:  {
            user, error in
            
            if let error = error
            {
                print("LIVC: error logging in - " + error.localizedDescription) //DEBUG
                if let errCode = FIRAuthErrorCode( rawValue: error.code )
                {
                    switch errCode
                    {
                        case .ErrorCodeUserNotFound:
                            self.logInErrorLabel.text = LOGIN_ERR_MSG
                            self.logInErrorLabel.hidden = false
                        
                        case .ErrorCodeTooManyRequests:
                            self.logInErrorLabel.text = REQUEST_ERR_MSG
                            self.logInErrorLabel.hidden = false
                        
                        case .ErrorCodeNetworkError:
                            self.logInErrorLabel.text = NETWORK_ERR_MSG
                            self.logInErrorLabel.hidden = false
                        
                        default:
                            print("LIVC: error case not currently covered") //DEBUG
                    }
                }
            }
        })
        //Authentication was successful so start fetching the user details and their content.
        fetchUser( )
    }
    
    /// This method fetches the user object from the database and sets it as the currentUser.
    func fetchUser( )
    {
        if let user = FIRAuth.auth()?.currentUser
        {
            print("LIVC: logged in")
            //note that when calling a method with a completion block as its last argument, you can supply the needed parameters in brackets
            // and then specify the completion block in curly braces. Generally I use a sameline curly brace to indicate this and a newline curly brace everywhere else.
            self.dataService.loadUser( user.uid ) {
                
                //this is the variable being passed by the completion block back in DataService
                (user, weeklyGoalIDStrings ) in
                self.currentUser = user
                
                //Because Firebase retrieval (this method) is asynchronous, we have to chain calls to the fetch/segue methods by
                // calling them in the completion block within a GCD (dispatch_async).
                //Otherwise if they are placed outside this block, the program will execute those calls before the fetch has completed.
                
                //Go to next fetch.
                dispatch_async( dispatch_get_main_queue() ) {
                    print("LIVC: user fetched, fetching weekly goals...")
                    self.fetchWeeklyGoals( weeklyGoalIDStrings )
                }
                
                //self.performSegueWithIdentifier("loggedIn", sender: self)
                
                //TEST WEEKLY GOAL
                //let wg = WeeklyGoal( goalText: "test2", kla: KeyLifeArea.Family, deadline: "12/05/2017", wgid: "54321")
                //self.dataService.saveWeeklyGoal(user.uid, weeklyGoal: wg)
            }
        }
    }
    
    /// This method fetches the user's weekly goals from the database sets it as the value of the weeklyGoals variable.
    func fetchWeeklyGoals( weeklyGoalIDStrings: [String] )
    {
        //If the user has no goals then go straight to weekly goal view...
        if weeklyGoalIDStrings.isEmpty
        {
            self.performSegueWithIdentifier(LOGGED_IN_SEGUE, sender: self)
        }
            //...otherwise fetch the user's goals
        else
        {
            for ( index, wgid ) in weeklyGoalIDStrings.enumerate()
            {
                self.dataService.loadWeeklyGoal(wgid) {
                    (weeklyGoal) in
                    self.weeklyGoals.append( weeklyGoal )
                    
                    //last goal is fetched so chain the next method before the completion block ends
                    if index == weeklyGoalIDStrings.count - 1
                    {
                        //go to next fetch when it's ready, but for now we shall segue
                        dispatch_async( dispatch_get_main_queue() ) {
                            print("LIVC: last weekly goal loaded, seguing....")
                            self.performSegueWithIdentifier(LOGGED_IN_SEGUE, sender: self)
                        }
                    }
                }
            }
        }
    }
    
    
    /*
    func fetchComplete( )
    {
        performSegueWithIdentifier("loggedIn", sender: self)
    } */
    

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
            dvc.weeklyGoals = self.weeklyGoals
        }
        else if segue.identifier == GO_TO_SIGN_UP_SEGUE
        {
            let dvc = segue.destinationViewController as! SignUpViewController
            dvc.currentUser = self.currentUser
        }
    }
    

}
