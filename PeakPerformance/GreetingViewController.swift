//
//  GreetingViewController.swift
//  PeakPerformance
//
//  Created by Benjamin Chiong on 8/9/16.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit

protocol GreetingViewControllerDelegate {
    func getFirstName() -> String
    func lastPageDone()
}

class GreetingViewController: UIViewController {
    
    var delegate: GreetingViewControllerDelegate?

    @IBOutlet weak var userName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       userName.text = delegate?.getFirstName()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func tutorialDidSkip(_ sender: UIButton) {
        if delegate != nil {
            delegate?.lastPageDone()
        }
        
    }


}


