//
//  TabBarViewController.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 23/07/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
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
        // BEN //
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(TabBarViewController.setIndexNumber), name: "changeIndex", object: nil)
        // END BEN //

        self.selectedIndex = currentSelectedIndex
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
    }
}
