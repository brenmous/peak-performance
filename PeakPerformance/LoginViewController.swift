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

/**
    Protocol for specifying log in DataService requirements.
 */
protocol LogInDataService
{
    func loadUser( uid: String ) -> User
}


/**
    Class that controls the Log In view.
 */
class LoginViewController: UIViewController, UITextFieldDelegate {
 
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
    
    
    // MARK: - Actions
    
    @IBAction func logInButtonPressed(sender: AnyObject)
    {
        self.login( )
    }
    
    //@IBAction func signUpButtonPressed(sender: AnyObject) {}
    
    //@IBAction func resetPasswordButtonPressed(sender: AnyObject) {}
    
    
    
    // MARK: - Methods
    
    /// Attempts to authenticate a user using supplied details.
    func login()
    {
        FIRAuth.auth()?.signInWithEmail( emailField.text!, password: passwordField.text!, completion:  {
            user, error in
            
            if let error = error
            {
                //notify user of bad input/error somewhere here
                print("error logging in: " + error.localizedDescription)
                if error == FIRAuthErrorCode.ErrorCodeUserNotFound
                {
                    
                }
            }
            else
            {
                print("logged in")
                if let user = FIRAuth.auth( )?.currentUser
                {
                    let uid = user.uid as String
                    self.currentUser = self.dataService.loadUser( uid )
                }
                
            }
        })
        //self.performSegueWithIdentifier( "loggedIn", sender: self )
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.login()
        return true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //hide error labels
        logInErrorLabel.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loggedIn"
        {
            let dvc = segue.destinationViewController as! TabBarViewController
            dvc.currentUser = self.currentUser
        }
        else if segue.identifier == "signUp"
        {
            //let dvc = segue.destinationViewController as! SignUpViewController
        }
    } */
    

}
