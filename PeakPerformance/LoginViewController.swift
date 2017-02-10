//
//  LoginViewController.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 17/07/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit
import Firebase // https://firebase.google.com
import SwiftValidator // https://github.com/jpotts18/SwiftValidator

/**
    Class that controls the Log In view.
 */
class LoginViewController: UIViewController, ValidationDelegate, UITextFieldDelegate {
 
    // MARK: - Properties
    
    /// DataService instance for interacting with Firebase database.
    let dataService = DataService()
    
    /// The currently authenticated user.
    var currentUser: User?
    
    /// This view controller's SwiftValidator instance.
    let validator = Validator()
    
    
    // MARK: - Outlets
    
    //text fields
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    //load indicator
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! //BEN
    
    //labels
    @IBOutlet weak var logInErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    //buttons
    @IBOutlet weak var logInButton: UIButton!

    
    // MARK: - Actions
    
    @IBAction func logInButtonPressed(_ sender: AnyObject)
    {
        validator.validate(self)
    }
    
    @IBAction func signUpButtonPressed(_ sender: AnyObject)
    {
        shouldPerformSegue(withIdentifier: GO_TO_SIGN_UP_SEGUE, sender: self )
    }
    
    @IBAction func resetPasswordButtonPressed(_ sender: AnyObject)
    {
        shouldPerformSegue(withIdentifier: GO_TO_RESET_PW_SEGUE, sender: self )
    }
    
    // FIXME: - change these two unwind segues to the single "unwindToLogIn" segue
    @IBAction func unwindToLogIn(_ segue: UIStoryboardSegue){}
    
    // MARK: - Methods
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when all registered fields pass validation.
    func validationSuccessful()
    {
        login()
    }
    
    /// Method required by ValidationDelegate (part of SwiftValidator). Is called when a registered field fails against a validation rule.
    func validationFailed(_ errors: [(Validatable, ValidationError)])
    {
        activityIndicator.stopAnimating()
    }

    /// Attempts to authenticate a user using supplied details.
    func login()
    {
        activityIndicator.startAnimating()
        logInErrorLabel.isHidden = true
        logInErrorLabel.text = ""
        logInButton.isEnabled = false
        
        FIRAuth.auth()?.signIn( withEmail: emailField.text!, password: passwordField.text!, completion:  {
            user, error in
            guard let error = error else
            {
                self.fetchUser()
                return
            }
            self.activityIndicator.stopAnimating()
            print("LIVC: error logging in - " + error.localizedDescription)
            guard let errCode = FIRAuthErrorCode(rawValue: (error as NSError).code) else {
                return
            }
            switch errCode
            {
            case .errorCodeUserNotFound:
                self.logInErrorLabel.text = LOGIN_ERR_MSG
                
            case .errorCodeTooManyRequests:
                self.logInErrorLabel.text = REQUEST_ERR_MSG
                
            case .errorCodeNetworkError:
                self.logInErrorLabel.text = NETWORK_ERR_MSG
                
            case .errorCodeInternalError:
                self.logInErrorLabel.text = FIR_INTERNAL_ERROR
                
            case .errorCodeUserDisabled:
                self.logInErrorLabel.text = USER_DISABLED_ERROR
                
            case .errorCodeWrongPassword:
                self.logInErrorLabel.text = WRONG_PW_ERROR
                
            default:
                self.logInErrorLabel.text = FIR_INTERNAL_ERROR
            }
            self.logInErrorLabel.isHidden = false
            self.logInButton.isEnabled = true
            
        })
    }
    
    /// This method fetches the user and their content from the database.
    func fetchUser( )
    {
        guard let user = FIRAuth.auth()?.currentUser else
        {
            return
        }

        //Counter for determining when load has completed.
        let thingsToLoad = 7; var loadCount = 0
        
        dataService.loadUser(user.uid) { (user) in
            self.currentUser = user
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async(execute: {
                
                self.dataService.loadSummaries(user) { (summaries) in
                    user.monthlySummaries = summaries
                    loadCount += 1
                    if loadCount == thingsToLoad
                    {
                        self.performSegue(withIdentifier: LOGGED_IN_SEGUE, sender: self)
                    }
                }
            });
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async(execute: {
                self.dataService.loadWeeklyGoals(user.uid) { (weeklyGoals) in
                    user.weeklyGoals = weeklyGoals
                    loadCount += 1
                    if loadCount == thingsToLoad
                    {
                        self.performSegue(withIdentifier: LOGGED_IN_SEGUE, sender: self)
                    }
                }
            });
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async(execute: {
                self.dataService.loadMonthlyGoals(user.uid) { (monthlyGoals) in
                    user.monthlyGoals = monthlyGoals
                    loadCount += 1
                    if loadCount == thingsToLoad
                    {
                        self.performSegue(withIdentifier: LOGGED_IN_SEGUE, sender: self)
                    }
                }
            });
            
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async(execute: {
                self.dataService.loadDreams(user.uid) { (dreams) in
                    user.dreams = dreams
                    loadCount += 1
                    if loadCount == thingsToLoad
                    {
                        self.performSegue(withIdentifier: LOGGED_IN_SEGUE, sender: self)
                    }
                }
            });
            
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async(execute: {
                self.dataService.loadValues(user.uid) { (values) in
                    user.values = values
                    loadCount += 1
                    if loadCount == thingsToLoad
                    {
                        self.performSegue(withIdentifier: LOGGED_IN_SEGUE, sender: self)
                    }
                }
            });
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async(execute: {
                
                    self.dataService.loadYearlySummaries(user) { (summaries) in
                        user.yearlySummary = summaries
                        loadCount += 1
                        if loadCount == thingsToLoad { self.performSegue(withIdentifier: LOGGED_IN_SEGUE, sender: self) }
                    }
            });
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async(execute: {
                
                self.dataService.loadCurrentRealitySummary(user) { (summary) in
                    user.initialSummary = summary
                    loadCount += 1
                    if loadCount == thingsToLoad { self.performSegue(withIdentifier: LOGGED_IN_SEGUE, sender: self) }
                }
            });
        }
    }

    // MARK: - Keyboard
    
    /// Dismisses keyboard when return is pressed.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        validator.validate(self)
        textField.resignFirstResponder()
        return true
    }
    
    /// Dismisses keyboard when tap outside keyboard detected.
    override func touchesBegan( _ touchers: Set<UITouch>, with event: UIEvent? )
    {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Overridden methods
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
        
        //password field
        validator.registerField(passwordField, errorLabel: passwordErrorLabel, rules: [RequiredRule( message: REQUIRED_FIELD_ERR_MSG)] )
        
        
        //set up text field delegates
        emailField.delegate = self
        passwordField.delegate = self
    
        //Set automatic sign in to true if it has not been set
        let ud = UserDefaults()
        if ud.value(forKey: USER_DEFAULTS_AUTO_LOGIN) == nil
        {
            ud.setValue(true, forKey: USER_DEFAULTS_AUTO_LOGIN)
        }
        
        //Check if user is already authenticated and log in if so
        let userDefaults = UserDefaults()
        userDefaults.setValue(true, forKey: USER_DEFAULTS_AUTO_LOGIN)
        if userDefaults.bool(forKey: USER_DEFAULTS_AUTO_LOGIN)
        {
            let user = FIRAuth.auth()?.currentUser
            if user != nil
            {
                activityIndicator.startAnimating()
                logInErrorLabel.isHidden = true
                logInErrorLabel.text = ""
                logInButton.isEnabled = false
                fetchUser()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //reset fields
        emailField.text = ""
        passwordField.text = ""
        
        //hide error labels
        logInErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        
        //enable log in button
        logInButton.isEnabled = true
        
        activityIndicator.stopAnimating()
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        activityIndicator.stopAnimating()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Inverts the colour of the status bar.
    override var preferredStatusBarStyle : UIStatusBarStyle
    {
        return UIStatusBarStyle.lightContent
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segue.identifier!
        {
        case LOGGED_IN_SEGUE:
            let dvc = segue.destination as! TabBarViewController
            dvc.currentUser = currentUser
            
        default:
            return
        }
    }
    
    

}
