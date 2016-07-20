//
//  LoginViewController.swift
//  FirebaseTest
//
//  Created by Bren on 17/07/2016.
//  Copyright © 2016 Bren. All rights reserved.
//

import UIKit
import Firebase

protocol LogInDataService
{
    func loadUser( uid: String ) -> User
}

class LoginViewController: UIViewController {

    var currentUser: User?
    var dataService: DataService?
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func logInButtonPressed(sender: AnyObject) {
        self.login( )
    }
    
    func login( )
    {
        FIRAuth.auth()?.signInWithEmail( userNameField.text!, password: passwordField.text!, completion:  {
            user, error in
            
            if let error = error
            {
                print("error loggin in: " + error.localizedDescription)
            }
            //login successfull
            else
            {
                print("logged in")
                
                //get user details and make user object
                if let user = FIRAuth.auth( )?.currentUser
                {
                    let uid = user.uid as String
                    self.currentUser = self.dataService!.loadUser( uid )
                    self.performSegueWithIdentifier( "loggedIn", sender: self )
                    
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set up data service
        self.dataService = DataService( )
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
