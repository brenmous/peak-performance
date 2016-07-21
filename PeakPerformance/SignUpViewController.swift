//
//  SignUpViewController.swift
//  PeakPerformance
//
//  Created by Bren on 17/07/2016.
//  Copyright © 2016 Bren. All rights reserved.
//

import UIKit
import Firebase
import SwiftValidator

/**
    Protocol for specifying Sign Up DataService.
 */
protocol SignUpDataService
{
    func saveUser( user: User )
}


/**
    Class that controls the Sign Up view.
 */
class SignUpViewController: UIViewController, ValidationDelegate {
    
    // MARK: - Properties
    
    /// The currently authenticated user.
    var currentUser: User?
    
    /// This view controller's DataService instance.
    let dataService = DataService( )
    
    /// This view controller's SwiftValidator instance.
    let validator = Validator( )
    
    
    // MARK: - Outlets
    
    //text fields
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var orgField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    //labels
    @IBOutlet weak var firstNameErrorLabel: UILabel!
    
    
    // MARK: - Actions
    
    @IBAction func signUpButtonPressed(sender: AnyObject)
    {
        //self.signUp()
        validator.validate(self)
    }
    
    
    
    // MARK: - Methods
    
    func validationSuccessful()
    {
        print ("validation successful")
        self.signUp()
    }
    
    func validationFailed(errors: [(Validatable, ValidationError)]) {
        /*for (field, error) in errors
        {
            if let field = field as? UITextField
            {
                field.layer.borderColor = UIColor.redColor().CGColor
                field.layer.borderWidth = 1.0
            }
            error.errorLabel?.text = error.errorMessage
            error.errorLabel?.hidden = false
        } */
        
        print ("validation failed")
    }
    
    /// Attempts to create a new Firebase user account with supplied email and password.
    func signUp()
    {
        //if ( self.validateFields( ) )
        //{
            //print("fields valid")
            
            FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!, completion: {
                user, error in
                if let error = error
                {
                    //Inform user of error here somewhere
                    print("error creating account: " + error.localizedDescription)
                }
                else
                {
                    print("account created")
                    self.firstLogin()
                }
            })
       // }
       // else
       // {
            //Inform user of bad input here somewhere
           // print("Invalid text in fields")
       // }

    }
    
    //delegate this back to Login VC???
    func firstLogin( )
    {
        FIRAuth.auth()?.signInWithEmail( emailField.text!, password: passwordField.text!, completion:  {
            user, error in
            
            if let error = error
            {
                print("error logging in: " + error.localizedDescription)
            }
            else
            {
                print("logged in")
                self.createUser( )
            }
        })
       // self.performSegueWithIdentifier( "signedUp", sender: self )
    }
    
    /// Creates a new user and save details to database.
    func createUser( )
    {
        if let user = FIRAuth.auth( )?.currentUser
        {
            //create new user object
            let fname = self.firstNameField.text!
            let lname = self.lastNameField.text!
            let org = self.orgField.text!
            let username = self.userNameField.text!
            let email = self.emailField.text!
            let uid = user.uid as String
            
            self.currentUser = User( fname: fname, lname: lname, org: org, email: email, username: username, uid: uid )
            
            self.dataService.saveUser( self.currentUser! )
        }
    }
    
    //this is where we will check our fields, check p/w strength etc. but for now we are just making sure no fields are empty
    func validateFields( ) -> Bool
    {
        if ( firstNameField.text!.isEmpty )
        {
            return false
        }
        if ( lastNameField.text!.isEmpty )
        {
            return false
        }
        if ( orgField.text!.isEmpty )
        {
            return false
        }
        if ( userNameField.text!.isEmpty )
        {
            return false
        }
        if ( emailField.text!.isEmpty )
        {
            return false
        }
        if ( passwordField.text!.isEmpty )
        {
            return false
        }
        
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        validator.styleTransformers(success: { (validationRule) -> Void in
            validationRule.errorLabel?.hidden = true
            validationRule.errorLabel?.text = ""
            if let textField = validationRule.field as? UITextField
            {
                textField.layer.borderColor = UIColor.greenColor().CGColor
                textField.layer.borderWidth = 0.5
            }
            
            }, error: { (validationError ) -> Void in
                validationError.errorLabel?.hidden = false
                validationError.errorLabel?.text = validationError.errorMessage
                if let textField = validationError.field as? UITextField
                {
                    textField.layer.borderColor = UIColor.redColor( ).CGColor
                    textField.layer.borderWidth = 1.0
                }
            })
        
        validator.registerField(firstNameField, errorLabel: firstNameErrorLabel, rules: [RequiredRule( message: "First name is required"), AlphaRule( message: "Only letters")] )
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //hide error labels
        firstNameErrorLabel.hidden = true
    }
    

    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dvc = segue.destinationViewController as! TabBarViewController
        dvc.currentUser = self.currentUser
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    } */
    

}
