//
//  SocialMediaViewController.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 8/10/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit

class SocialMediaViewController: UIViewController
{
    // MARK: - Properties
    
    // MARK: - Outlets
    
    @IBOutlet weak var twitterSwitch: UISwitch!
    
    
    // MARK: - Actions

    /// Updates whether Twitter is enabled and if so asks user to login in via Twitter API.
    @IBAction func twitterSwitchSwitched(_ sender: AnyObject?)
    {
        if twitterSwitch.isOn
        {
            Twitter.sharedInstance().logIn { (session, error) in
                guard session != nil else
                {
                    UserDefaults().setValue(false, forKey: USER_DEFAULTS_TWITTER)
                    return
                }
                UserDefaults().setValue(true, forKey: USER_DEFAULTS_TWITTER)
                self.twitterSwitch.isOn = true
            }
        }
    }

    // MARK: - Overriden methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        twitterSwitch.isOn = UserDefaults().bool(forKey: USER_DEFAULTS_TWITTER)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
