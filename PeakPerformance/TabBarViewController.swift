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
    
    /// The current select tab view
    var currentSelectedIndex = 2
    
    @IBAction func unwindToTabBar( sender: UIStoryboardSegue){ }
    
    // MARK: - Methods
    
    func setIndexNumber( ) {
        self.selectedIndex = 0
        print("HVC: History View") // DEBUG
    }
    
    //MARK: - Overriden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(TabBarViewController.setIndexNumber), name: "changeIndex", object: nil)
        
        //set default tab to weekly goals view
        self.selectedIndex = currentSelectedIndex
        //set default tab to weekly goals view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
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
