//
//  MonthlyGoalsViewController.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 24/07/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//


import UIKit
import SideMenu // https://github.com/jonkykong/SideMenu
import TwitterKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}
 // https://fabric.io/kits/ios/twitterkit


/**
 Class that controls the monthly goals view.
 */
class MonthlyGoalsViewController: UITableViewController, MonthlyGoalDetailViewControllerDelegate, MonthlyGoalTableViewCellDelegate
{
    
    // MARK: - Properties
    
    /// DataService instance for interacting with Firebase database.
    let dataService = DataService()
    
    /// The currently authenticated user.
    var currentUser: User?
    
    
    // MARK: - Outlets
    
    //progress bar
    @IBOutlet weak var progressBarMG: UIProgressView!
    @IBOutlet weak var progressViewLabel: UILabel!
    
    
    // MARK: - Actions
    
    @IBAction func editButtonPressed(_ sender: AnyObject)
    {
        self.tableView.setEditing(tableView.isEditing != true, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: AnyObject)
    {
        performSegue(withIdentifier: ADD_MONTHLY_GOAL_SEGUE, sender: self)
    }
    
    @IBAction func menuButtonPressed(_ sender: AnyObject)
    {
        //Side Menu
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func unwindFromMGDVC( _ segue: UIStoryboardSegue ){ }
    
    
    // MARK: - Methods
    
    /// Updates progress bar with the current date and progress value.
    func updateProgressBar( )
    {
        progressViewLabel.text = Date().monthlyProgressString()
        progressBarMG.progress = Date().monthlyProgressValue()
    }
    
    /**
     Adds a new goal to the array and saves it to the database.
     
     - Parameters:
     - weeklyGoal: the newly created weeklygoal
     */
    func addNewGoal( _ monthlyGoal: MonthlyGoal )
    {
        guard let cu = currentUser else
        {
            //user not available? handle it here
            return
        }
        cu.monthlyGoals.append(monthlyGoal)
        dataService.saveGoal(cu.uid, goal: monthlyGoal)
        createMonthlyGoalDueSoonNotification(monthlyGoal)
    }
    
    /**
     Updates the values of the weekly goal that is currently being editied and saves it to the database.
     
     - Parameters:
     - weeklyGoal: the edited weekly goal.
     */
    func saveModifiedGoal(_ monthlyGoal: MonthlyGoal)
    {
        guard let cu = currentUser else
        {
            //user not available handle it HANDLE IT!
            return
        }
        self.dataService.saveGoal(cu.uid, goal: monthlyGoal)
        removeMonthlyGoalDueSoonNotification(monthlyGoal)
    }
    
    /**
     Marks a goal as complete, updates it in the database and organises the table to reflect change.
     
     - Parameters:
     - goal: the goal being completed.
     */
    func completeGoal( _ goal: MonthlyGoal )
    {
        goal.complete = true
        self.saveModifiedGoal(goal)
        removeMonthlyGoalDueSoonNotification(goal)
        sortMonthlyGoals()
        self.tableView.reloadData()
    }
    
    func completeButtonPressed( _ cell: MonthlyGoalTableViewCell )
    {
        //get weekly goal from cell
        guard let indexPath = self.tableView.indexPath(for: cell) else
        {
            //couldn't get index path of cell
            return
        }
        guard let cu = self.currentUser else
        {
            //couldn't get user
            return
        }
        let mg = cu.monthlyGoals[indexPath.row]
        
        //goal completion confirm alert controller
        present(goalCompleteAlertController(mg), animated: true, completion: nil)
    }
    
    /// Sorts the user's monthly goal array.
    func sortMonthlyGoals()
    {
        guard let cu = currentUser else { return }
        cu.monthlyGoals.sort(by: {$0.deadline.compare($1.deadline as Date) == .orderedAscending})
        cu.monthlyGoals.sort(by: {!$0.complete && $1.complete})
    }
    
    /// Shares completed goals on social media if user has enabled them in settings.
    func shareOnSocialMedia(_ goal: MonthlyGoal)
    {
        if UserDefaults().bool(forKey: USER_DEFAULTS_TWITTER)
        {
            let composer = TWTRComposer()
            composer.setText(TWITTER_MESSAGE_MONTHLY_GOAL(goal))
            composer.show(from: self) { (result) in
            }
        }
    }
    
    // MARK: - Local notifications
    
    /**
        Sechedules an iOS local notification that alerts user when monthly goals are close to due.
 
        - Parameters:
            - monthlyGoal: the goal to create a notification for.
    */
    func createMonthlyGoalDueSoonNotification(_ monthlyGoal: MonthlyGoal)
    {
        let notification = UILocalNotification()
        notification.alertBody = MG_NOTIFICATION_BODY(monthlyGoal)
        let calendar = Calendar.current
        // - FIXME:
        notification.fireDate = (calendar as NSCalendar).date(byAdding: .day, value: MG_NOTIFICATION_FIREDATE, to: monthlyGoal.deadline as Date, options: [])
        notification.userInfo = [MG_NOTIFICATION_ID: monthlyGoal.gid]
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    /**
        Deschedules the iOS local notification for a speicifed monthly goal.
 
        - Parameters:
            - monthlyGoal: goal to remove notification for.
     */
    func removeMonthlyGoalDueSoonNotification(_ monthlyGoal: MonthlyGoal)
    {
        guard let notifications = UIApplication.shared.scheduledLocalNotifications else { return }
        for notification in notifications
        {
            guard let key = notification.userInfo![MG_NOTIFICATION_ID] else { continue }
            if key as! String == monthlyGoal.gid
            {
                UIApplication.shared.cancelLocalNotification(notification)
                return
            }
        }
    }
    
    /**
        Updates a monthly goal notification's fire date.
    
        - Parameters:
            - monthlyGoal: the goal to update the notification for.
    */
    func updateMonthlyGoalDueSoonNotificationFireDate(_ monthlyGoal: MonthlyGoal)
    {
        guard let notifications = UIApplication.shared.scheduledLocalNotifications else { return }
        for notification in notifications
        {
            guard let key = notification.userInfo![MG_NOTIFICATION_ID] else { continue }
            if key as! String == monthlyGoal.gid
            {
                removeMonthlyGoalDueSoonNotification(monthlyGoal)
                createMonthlyGoalDueSoonNotification(monthlyGoal)
                return
            }
        }
    }
    
    // MARK: - Alert controllers
    func goalCompleteAlertController(_ goal: MonthlyGoal) -> UIAlertController
    {
        let goalCompleteAlertController = UIAlertController( title: COMPLETION_ALERT_TITLE, message: COMPLETION_ALERT_MSG_MONTHLY, preferredStyle: .alert )
        let confirm = UIAlertAction(title: COMPLETION_ALERT_CONFIRM_MONTHLY, style: .default ) { (action) in
            self.completeGoal(goal)
            self.shareOnSocialMedia(goal)
        }
        let cancel = UIAlertAction(title: COMPLETION_ALERT_CANCEL, style: .cancel, handler: nil )
        goalCompleteAlertController.addAction( confirm ); goalCompleteAlertController.addAction( cancel );
        return goalCompleteAlertController
    }
    
    
    // MARK: - Overridden methods
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if self.currentUser == nil
        {
            //Get data from tab bar view controller
            let tbvc = self.tabBarController as! TabBarViewController
            
            guard let cu = tbvc.currentUser else
            {
                return
            }
            self.currentUser = cu
        }
        
        //disable editing in case user left view while in edit mode
        self.tableView.setEditing(false, animated: true)
        
       
        
        for goal in currentUser!.monthlyGoals
        {
            goal.checkIfDue()
        }
        
        sortMonthlyGoals()
   
        
        //update progress bar
        updateProgressBar()
        
        //Side Menu
        SideMenuManager.setUpSideMenu(self.storyboard!, user: self.currentUser!) //func declaration is in SideMenuViewController
        
        //check if a yearly review is needed
        if self.currentUser!.checkYearlyReview()
        {
            self.currentUser!.allMonthlyReviewsFromLastYear()
            self.present(UIAlertController.AnnualReviewAlert(self.tabBarController as! TabBarViewController), animated: true, completion: nil)
        }
            //only check for monthly reviews if the year hasn't changed, because if it has we know we need 12 months of reviews
        else
        {
            //check if a monthly review is needed
            if self.currentUser!.checkMonthlyReview()
            {
                self.present(UIAlertController.getReviewAlert(self.tabBarController as! TabBarViewController), animated: true, completion: nil)
            }
        }

        
        // set up badge and menu bar button item
        self.setUpLeftBarButtonItem( String(self.currentUser!.numberOfUnreviwedSummaries()) )
        
        self.tableView.reloadData()
    }

    
    // MARK: - Table view data source
    
    // SOWMYA //
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        
        if (currentUser?.monthlyGoals.count) > 0 {
            
            self.tableView!.backgroundView = nil
            numOfSections = 1
            tableView.separatorStyle = .singleLine
            
        } else {
            
            // Creating and editing label to display when there are no Weekly Goals
            var weeklyPlaceholderView : UIImageView
            weeklyPlaceholderView  = UIImageView(frame:CGRect(x: 0, y: 0, width: self.tableView!.bounds.size.width, height: self.tableView!.bounds.size.height));
            weeklyPlaceholderView.image = UIImage(named:MONTHLY_PLACEHOLDER)
            weeklyPlaceholderView.contentMode = .scaleAspectFill
            self.tableView.backgroundView = weeklyPlaceholderView
            tableView.separatorStyle = .none
            
        }
        
        return numOfSections
    }
    // END SOWMYA //
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currentUser!.monthlyGoals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "monthlyGoalCell", for: indexPath) as! MonthlyGoalTableViewCell
        let goal = currentUser!.monthlyGoals[indexPath.row]

        //Configure the cell
        let kla = goal.kla
        cell.goalTextLabel!.text = goal.goalText
        cell.delegate = self
        var klaIcon = ""
        var klaIconHighlighted = ""
        
        if  goal.complete
        {
            cell.isUserInteractionEnabled = false
            cell.completeButton.isEnabled = false
//            cell.accessoryType = .Checkmark
            cell.doneCircle.image = UIImage(named: "done-circle")
            cell.tintColor = UIColor.darkGray
            cell.goalTextLabel.textColor = UIColor.lightGray
            cell.dueLabelIcon.isHidden = true
        
            switch kla
            {
            case KLA_FAMILY:
                klaIcon = "F-done.png"
                
            case KLA_WORKBUSINESS:
                klaIcon = "W-done.png"
                
            case KLA_PARTNER:
                klaIcon = "P-done.png"
                
            case KLA_FINANCIAL:
                klaIcon = "FI-done.png"
                
            case KLA_PERSONALDEV:
                klaIcon = "PD-done.png"
                
            case KLA_EMOSPIRITUAL:
                klaIcon = "ES-done.png"
                
            case KLA_HEALTHFITNESS:
                klaIcon = "H-done.png"
                
            case KLA_FRIENDSSOCIAL:
                klaIcon = "FR-done.png"
                
            default:
                klaIcon = "F-done.png"
            }
        }
        else if !goal.complete
        {
            cell.completeButton.isEnabled = true
            cell.isUserInteractionEnabled = true
            cell.doneCircle.image = UIImage(named: "not-done-circle")
            cell.accessoryType = .none
            cell.goalTextLabel.textColor = PEAK_BLACK
            cell.dueLabelIcon.isHidden = false
            
            switch kla
            {
            case KLA_FAMILY:
                klaIcon = "F.png"
                klaIconHighlighted = "F-highlighted"
                
            case KLA_WORKBUSINESS:
                klaIcon = "W.png"
                klaIconHighlighted = "W-highlighted"
                
            case KLA_PARTNER:
                klaIcon = "P.png"
                klaIconHighlighted = "P-highlighted"
                
            case KLA_FINANCIAL:
                klaIcon = "FI.png"
                klaIconHighlighted = "FI-highlighted"
                
            case KLA_PERSONALDEV:
                klaIcon = "PD.png"
                klaIconHighlighted = "PD-highlighted"
                
            case KLA_EMOSPIRITUAL:
                klaIcon = "ES.png"
                klaIconHighlighted = "ES-highlighted"
            case KLA_HEALTHFITNESS:
                klaIcon = "H.png"
                klaIconHighlighted = "H-highlighted"
                
            case KLA_FRIENDSSOCIAL:
                klaIcon = "FR.png"
                klaIconHighlighted = "FR-highlighted"
                
            default:
                klaIcon = "F.png"
                klaIconHighlighted = "F-highlighted"
            }
    
            if goal.due == Goal.Due.overdue
            {
                //show due image
                cell.dueLabelIcon.image = UIImage(named: OVERDUE_ICON)
            }
            else if goal.due == Goal.Due.soon
            {
                //show soon image
                cell.dueLabelIcon.image = UIImage(named: DUE_SOON_ICON)
            }
            else
            {
                // hide image
                cell.dueLabelIcon.isHidden = true
            }
        }
        
        // Image button for normal and highlighted
        let imageButton = UIImage(named: klaIcon)
        let highlightedImageButton = UIImage(named: klaIconHighlighted)
        cell.completeButton.setBackgroundImage(imageButton, for: UIControlState())
        cell.completeButton.setBackgroundImage(highlightedImageButton, for: .highlighted)
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if currentUser!.monthlyGoals[indexPath.row].complete
        {
            return false
        }
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            // Delete the row from the data source
            guard let cu = self.currentUser else { return }
            self.dataService.removeGoal(cu.uid, goal: cu.monthlyGoals[indexPath.row])
            cu.monthlyGoals.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier!
        {
        case ADD_MONTHLY_GOAL_SEGUE:
            let dvc = segue.destination as! MonthlyGoalDetailViewController
            dvc.delegate = self
            dvc.currentUser = self.currentUser
            
        case EDIT_MONTHLY_GOAL_SEGUE:
            let dvc = segue.destination as! MonthlyGoalDetailViewController
            dvc.delegate = self
            dvc.currentUser = self.currentUser
            if let indexPath = self.tableView.indexPathForSelectedRow
            {
                dvc.currentGoal = currentUser!.monthlyGoals[indexPath.row]
            }
            
        default:
            return
        }
    }
}

