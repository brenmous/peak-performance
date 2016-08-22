//
//  TabBarViewController.swift
//  PeakPerformance
//
//  Created by Bren on 23/07/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit

/**
    Class that controls the TabBar view.
 */
class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
    
    /// The currently authenticated user.
    var currentUser: User?
    
    
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool )
    {
        super.viewWillAppear(animated)
        
        //set default tab to weekly goals view
        self.selectedIndex = 3
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
