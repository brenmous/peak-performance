//
//  SettingsViewController.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 23/09/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController
{

    // MARK: - Properties
    var currentUser: User?
    
    // MARK: - Actions
    
    /// Unwind segue to this view controller.
    @IBAction func unwindToSettings( _ sender: UIStoryboardSegue){}
    
    /// Sets UserDefaults for autologin based on state of switch.
    @IBAction func automaticLoginSwitched(_ sender: AnyObject)
    {
        let s = sender as! UISwitch
        let userDefaults = UserDefaults()
        userDefaults.setValue(s.isOn, forKey: USER_DEFAULTS_AUTO_LOGIN)
    }
    
    @IBAction func backButtonPressed( _ sender: AnyObject )
    {
        performSegue(withIdentifier: UNWIND_FROM_SETTINGS_SEGUE, sender: self)
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var automaticLoginSwitch: UISwitch!
    
    // MARK: - Overriden methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool )
    {
        super.viewWillAppear(animated)
        //set switch to reflect current autologin setting
        automaticLoginSwitch.isOn = UserDefaults().bool(forKey: USER_DEFAULTS_AUTO_LOGIN)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segue.identifier!
        {
        case GO_TO_CHANGE_PASSWORD_SEGUE:
            let dvc = segue.destination as! ChangePasswordViewController
            dvc.currentUser = currentUser
            
        case SETTINGS_TO_DELETE_ACCOUNT_SEGUE:
            let dvc = segue.destination as! DeleteAccountViewController
            dvc.currentUser = currentUser
            
        case SETTINGS_TO_COACH_EMAIL_SEGUE:
            let dvc = segue.destination as! CoachEmailViewController
            dvc.currentUser = currentUser
            
        case SETTINGS_TO_ABOUT_SEGUE:
            return
            
        default:
            return
        }
    }

}
