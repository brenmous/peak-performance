//
//  LastPageTutorialViewController.swift
//  PeakPerformance
//
//  Created by Benjamin Chiong on 8/9/16.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit

protocol LastPageTutorialViewControllerDelegate {
        func lastPageDone()
}

class LastPageTutorialViewController: UIViewController {

    // Mark: IBAction
    var delegate: LastPageTutorialViewControllerDelegate?
    
    @IBAction func tutorialFinished(_ sender: AnyObject) {
        if delegate != nil {
        delegate?.lastPageDone()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
