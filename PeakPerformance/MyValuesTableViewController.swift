//
//  MyValuesTableViewController.swift
//  PeakPerformance
//
//  Created by Benjamin Chiong on 9/1/16.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit
import SideMenu
import Firebase


class MyValuesTableViewController: UITableViewController {

    /// The currently authenticated user.
    var currentUser: User?
    
    /// This view controller's data service.
    let dataService = DataService( )
    
// MARK: IBOutlet
    
    @IBOutlet weak var myValuesTextView: UITextView!
    
    @IBOutlet weak var myValueTextView2: UITextView!
    
    @IBOutlet weak var myValuesTextView3: CustomizableTextView!
    
    @IBOutlet weak var myValuesTextView4: UITextView!
    
    @IBOutlet weak var myValuesTextView5: UITextView!
    
    @IBOutlet weak var myValuesTextView6: UITextView!
    
    @IBOutlet weak var myValuesTextView7: CustomizableTextView!
    
    @IBOutlet weak var myValuesTextView8: CustomizableTextView!
    @IBAction func saveMyValues(sender: AnyObject) {
        currentUser!.values[KLA_FAMILY] = myValuesTextView.text
        currentUser!.values[KLA_FRIENDSSOCIAL] = myValueTextView2.text
        currentUser!.values[KLA_PARTNER] = myValuesTextView3.text
        currentUser!.values[KLA_WORKBUSINESS] = myValuesTextView4.text
        currentUser!.values[KLA_HEALTHFITNESS] = myValuesTextView5.text
        currentUser!.values[KLA_PERSONALDEV] = myValuesTextView6.text
        currentUser!.values[KLA_FINANCIAL] = myValuesTextView7.text
        currentUser!.values[KLA_EMOSPIRITUAL] = myValuesTextView8.text
        
        guard let cu = currentUser else
        {
           return
        }
        cu.values[KLA_FRIENDSSOCIAL] = myValueTextView2.text
        dataService.saveValues(cu)
        print("This is my financial goal \(cu.values[KLA_FINANCIAL]!)")
    }
    
    @IBAction func menuButtonPressed(sender: UIBarButtonItem) {
                presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }

    /// Updates text views with details from the current my values (if available)
    func updateTextViews( )
    {
        guard let cu =  currentUser else
        {
            return
        }
        myValuesTextView.text = cu.values[KLA_FAMILY]
        myValueTextView2.text = cu.values[KLA_FRIENDSSOCIAL]
        myValuesTextView3.text = cu.values[KLA_PARTNER]
        myValuesTextView4.text = cu.values[KLA_WORKBUSINESS]
        myValuesTextView5.text = cu.values[KLA_HEALTHFITNESS]
        myValuesTextView6.text = cu.values[KLA_PERSONALDEV]
        myValuesTextView7.text = cu.values[KLA_FINANCIAL]
        myValuesTextView8.text = cu.values[KLA_EMOSPIRITUAL]
        print("textviews updated \(cu.values[KLA_FRIENDSSOCIAL])")
    }
    // MARK: Overridden methods
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if currentUser != nil
        {
            self.updateTextViews( )
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let tbvc = self.tabBarController as! TabBarViewController
        
        guard let cu = tbvc.currentUser else
        {
            return
        }
        self.currentUser = cu
        
        print("DVC: got user \(cu.email) with \(cu.values.count) values")


    }
    


}
