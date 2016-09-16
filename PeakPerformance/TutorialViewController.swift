//
//  TutorialViewController.swift
//  PeakPerformance
//
//  Created by Benjamin Chiong on 8/8/16.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource,
LastPageTutorialViewControllerDelegate, GreetingViewControllerDelegate {
    
    var currentUser: User?
    var pageControl: UIPageControl!
    var pageViewController: UIPageViewController!
    var indexForPageControl: Int = 0
    var pages = ["congratulationsPage", "firstPageTutorial", "secondPageTutorial",
                 "thirdPageTutorial", "fourthPageTutorial", "fifthPageTutorial" ]
    // Mark: IBActions
    
    @IBAction func skipTutorial(sender: AnyObject) {
        self.performSegueWithIdentifier( GO_TO_INITIAL_SETUP, sender: self )
        print("skip button")
    }
    
    // Mark: Delegate Methods
    
    func lastPageDone() {
        print("Last page done")
        //TODO: segue to initial setup
        self.performSegueWithIdentifier( GO_TO_INITIAL_SETUP, sender: self )
        
    }
    
    func getFirstName() -> String {
        print("function works")
        return (currentUser?.fname)!
    }

    // Mark: Public functions for PageViewController
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let index = pages.indexOf(viewController.restorationIdentifier!) {
            if index > 0 {
                return viewControllerAtIndex(index - 1)
                
            }
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if let index = pages.indexOf(viewController.restorationIdentifier!) {
            if index < pages.count - 1 {
                return viewControllerAtIndex(index + 1)
            }
        }
        return nil
    }
    
    // Mark: Public Functions for Page Control
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
                return 0
    }
    
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        let vc = storyboard?.instantiateViewControllerWithIdentifier(pages[index])
        
        if pages[index] == "fifthPageTutorial" {
            (vc as! LastPageTutorialViewController).delegate = self
        } else if pages[index] == "congratulationsPage" {
            (vc as! GreetingViewController).delegate = self
        }
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let vc = viewControllerAtIndex(0)
        (vc as! GreetingViewController).delegate = self
        
        if let vc = storyboard?.instantiateViewControllerWithIdentifier("tutorialPageViewController"){
            self.addChildViewController(vc)
            self.view.addSubview(vc.view)
            
            pageViewController = vc as! UIPageViewController
            pageViewController.dataSource = self
            pageViewController.delegate = self
            
            pageViewController.setViewControllers([viewControllerAtIndex(0)!], direction: .Forward, animated: true, completion: nil)
            pageViewController.didMoveToParentViewController(self)
        
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == GO_TO_INITIAL_SETUP
        {
            let nav = segue.destinationViewController as! UINavigationController
            let dvc = nav.topViewController as! InitialSetupViewController
            dvc.currentUser = self.currentUser
        }
        
    }
 

}
