//
//  TutorialViewController.swift
//  PeakPerformance
//
//  Created by Benjamin Chiong on 8/8/16.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
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
    
    @IBAction func skipTutorial(_ sender: AnyObject) {
        self.performSegue( withIdentifier: GO_TO_INITIAL_SETUP, sender: self )
    }
    
    // Mark: Delegate Methods
    
    /**
     Segues to the tabview controller
     
     */
    func lastPageDone() {
        self.performSegue( withIdentifier: GO_TO_INITIAL_SETUP, sender: self )
        
    }
    
    func getFirstName() -> String {
        return (currentUser?.fname)!
    }

    // Mark: Public functions for PageViewController
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = pages.index(of: viewController.restorationIdentifier!) {
            if index > 0 {
                return viewControllerAtIndex(index - 1)
                
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let index = pages.index(of: viewController.restorationIdentifier!) {
            if index < pages.count - 1 {
                return viewControllerAtIndex(index + 1)
            }
        }
        return nil
    }
    
    // Mark: Public Functions for Page Control
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
                return 0
    }
    
    /**
     Instantiates the view controller from an array of identifiers through indexing
     
     Parameter:
     - index of the array
    */
    
    func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        let vc = storyboard?.instantiateViewController(withIdentifier: pages[index])
        
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
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "tutorialPageViewController"){
            self.addChildViewController(vc)
            self.view.addSubview(vc.view)
            
            pageViewController = vc as! UIPageViewController
            pageViewController.dataSource = self
            pageViewController.delegate = self
            
            pageViewController.setViewControllers([viewControllerAtIndex(0)!], direction: .forward, animated: true, completion: nil)
            pageViewController.didMove(toParentViewController: self)
        
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == GO_TO_INITIAL_SETUP
        {
            let nav = segue.destination as! UINavigationController
            let dvc = nav.topViewController as! InitialSetupViewController
            dvc.currentUser = self.currentUser
        }
        
    }
 

}
