//
//  WeeklyGoalsViewController.swift
//  PeakPerformance
//
//  Created by Bren on 23/07/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit

class WeeklyGoalsViewController: UIViewController {

    /// The currently authenticated user.
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user == nil
        {
            print ("no user :(")
        }
        else
        {
            print ("current user is " + "\(user!.fname)" )
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
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
