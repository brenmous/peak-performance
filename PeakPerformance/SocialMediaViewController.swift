//
//  SocialMediaViewController.swift
//  PeakPerformance
//
//  Created by Bren on 8/10/2016.
//  Copyright © 2016 CtrlAltDesign. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit

class SocialMediaViewController: UIViewController
{
    // MARK: - Properties
    
    // MARK: - Outlets
    
    @IBOutlet weak var twitterSwitch: UISwitch!
    
    @IBAction func twitterSwitchSwitched(sender: AnyObject?)
    {
        if twitterSwitch.on
        {
            Twitter.sharedInstance().logInWithCompletion { (session, error) in
                guard session != nil else
                {
                    print("SocialMediaViewController - twitterSwitchSwitched(): \(error?.localizedDescription)")
                    NSUserDefaults().setValue(false, forKey: USER_DEFAULTS_TWITTER)
                    return
                }
                print("Signed in as \(session!.userName)")
                NSUserDefaults().setValue(true, forKey: USER_DEFAULTS_TWITTER)
                self.twitterSwitch.on = true
            }
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        twitterSwitch.on = NSUserDefaults().boolForKey(USER_DEFAULTS_TWITTER)
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
