//
//  WeeklyGoalsViewController.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 24/07/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit
import Firebase // https://firebase.google.com
import SideMenu // https://github.com/jonkeykong/SideMenu
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
    Class that controls the weekly goals view.
  */
class WeeklyGoalsViewController: UITableViewController, WeeklyGoalDetailViewControllerDelegate, GoalTableViewCellDelegate
{

    // MARK: - Properties

    /// DataService instance for interacting with Firebase database.
    let dataService = DataService()
    
    /// The currently authenticated user.
    var currentUser: User?
  
    
    // MARK: Outlets
    
    /// Progress bar.
    @IBOutlet weak var progressViewWG: UIProgressView!
    
    /// Progress bar label.
    @IBOutlet weak var progressViewLabel: UILabel!
    
    // MARK: - Actions
    
    /// Toggle editing (for deleting goals).
    @IBAction func editButtonPressed(_ sender: AnyObject)
    {
        self.tableView.setEditing(tableView.isEditing != true, animated: true) // :)
    }
    
    @IBAction func addButtonPressed(_ sender: AnyObject)
    {
       performSegue(withIdentifier: ADD_WEEKLY_GOAL_SEGUE, sender: self)
    }
    
    @IBAction func menuButtonPressed(_ sender: AnyObject)
    {
        
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func unwindFromWGDVC( _ segue: UIStoryboardSegue){}
    
    
    // MARK: - Methods
    
    /// Updates the progress bar with the current date and progress value.
    func updateProgressView()
    {
        progressViewLabel.text = Date().weeklyProgressString()
        progressViewWG.progress = Date().weeklyProgressValue()
    }
    
    /**
        Adds a new goal to the array and saves it to the database.
        
        - Parameters:
            - weeklyGoal: the newly created weeklygoal
    */
    func addNewGoal(_ weeklyGoal: WeeklyGoal)
    {
        guard let cu = currentUser else { return }
        cu.weeklyGoals.append(weeklyGoal)
        dataService.saveGoal(cu.uid, goal: weeklyGoal)
        createWeeklyGoalDueSoonNotification(weeklyGoal)
    }
    
    /**
        Updates the values of the weekly goal that is currently being editied and saves it to the database.
 
        - Parameters:
            - weeklyGoal: the edited weekly goal.
    */
    func saveModifiedGoal(_ weeklyGoal: WeeklyGoal)
    {
        guard let cu = currentUser else { return }
        self.dataService.saveGoal(cu.uid, goal: weeklyGoal)
        updateWeeklyGoalDueSoonNotificationFireDate(weeklyGoal)
    }
    
    /**
        Marks a goal as complete, updates it in the database and organises the table to reflect change.

        - Parameters:
            - goal: the goal being completed.
    */
    func completeGoal(_ goal: WeeklyGoal, kickItText: String)
    {
        goal.complete = true
        goal.kickItText = kickItText
        saveModifiedGoal(goal)
        removeWeeklyGoalDueSoonNotification(goal)
        sortWeeklyGoals()
        self.tableView.reloadData()
    }
    
    /**
        Presents a view controller asking user to confirm goal completion.
 
        - Parameters:
            - cell: the selected table view cell.
    */
    func completeButtonPressed( _ cell: GoalTableViewCell )
    {
        //get weekly goal from cell
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        guard let cu = self.currentUser else { return }
        let wg = cu.weeklyGoals[indexPath.row]
    
        //goal completion confirm alert controller
        present(goalCompleteAlertController(wg), animated: true, completion: nil)
    }
    
    /// Sorts user's weekly goals.
    func sortWeeklyGoals()
    {
        guard let cu = currentUser else { return }
        cu.weeklyGoals.sort(by: {$0.deadline.compare($1.deadline as Date) == .orderedAscending})
        cu.weeklyGoals.sort(by: {!$0.complete && $1.complete})
    }
    
    /// Asks the user if they want to share their completed goal on social media (only occurs if they have set sharing to on in settings).
    func shareOnSocialMedia(_ goal: WeeklyGoal)
    {
        if UserDefaults().bool(forKey: USER_DEFAULTS_TWITTER)
        {
            let composer = TWTRComposer()
            composer.setText(TWITTER_MESSAGE_WEEKLY_GOAL(goal)) //FIXME: test, make constant
            composer.show(from: self) { (result) in
            }
        }
    }
    
    // MARK: - Local notifications
    /**
     Schedules an iOS local notification that alerts user when a weekly goal is due soon.
     
     - Parameters:
     - weeklyGoal: the goal to create a notification for.
     */
    func createWeeklyGoalDueSoonNotification(_ weeklyGoal: WeeklyGoal)
    {
        let notification = UILocalNotification()
        notification.alertBody = WG_NOTIFICATION_BODY(weeklyGoal)
        
        /* Notification for due soon
         let calendar = NSCalendar.currentCalendar()
         notification.fireDate = calendar.dateByAddingUnit(.Day, value: -(weeklyGoal.daysTillDueSoon), toDate: weeklyGoal.deadline, options: [])
         */
        
        notification.fireDate = weeklyGoal.deadline as Date
        notification.userInfo = [WG_NOTIFICATION_ID: weeklyGoal.gid]
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    /**
     Deschedules the iOS local notification for a specified weekly goal.
     
     - Parameters:
     - weeklyGoal: the goal to remove the notification for.
     */
    func removeWeeklyGoalDueSoonNotification(_ weeklyGoal: WeeklyGoal)
    {
        guard let notifications = UIApplication.shared.scheduledLocalNotifications else { return }
        for notification in notifications
        {
            guard let key = notification.userInfo![WG_NOTIFICATION_ID] else { continue }
            if key as! String == weeklyGoal.gid
            {
                UIApplication.shared.cancelLocalNotification(notification)
                return
            }
        }
    }
    
    
    /**
     Updates a weekly goal notification's fire date.
     
     - Parameters:
     - weeklyGoal: the goal to update the notification for.
     */
    func updateWeeklyGoalDueSoonNotificationFireDate(_ weeklyGoal: WeeklyGoal)
    {
        guard let notifications = UIApplication.shared.scheduledLocalNotifications else { return }
        for notification in notifications
        {
            guard let key = notification.userInfo![WG_NOTIFICATION_ID] else { continue }
            if key as! String == weeklyGoal.gid
            {
                removeWeeklyGoalDueSoonNotification(weeklyGoal)
                createWeeklyGoalDueSoonNotification(weeklyGoal)
                return
            }
        }
    }
    
    // MARK: - Alert controllers
    func goalCompleteAlertController(_ goal: WeeklyGoal) -> UIAlertController
    {
        let goalCompleteAlertController = UIAlertController( title: COMPLETION_ALERT_TITLE, message: COMPLETION_ALERT_MSG, preferredStyle: .alert )
        let confirm = UIAlertAction(title: COMPLETION_ALERT_CONFIRM, style: .default ) { (action) in
            let kickItTextField = goalCompleteAlertController.textFields![0] as UITextField
            let kickItText = kickItTextField.text!
            self.completeGoal(goal, kickItText: kickItText)
            self.shareOnSocialMedia(goal)
        }
        let cancel = UIAlertAction(title: COMPLETION_ALERT_CANCEL, style: .cancel, handler: nil )
        goalCompleteAlertController.addAction( confirm ); goalCompleteAlertController.addAction( cancel );
        goalCompleteAlertController.addTextField( ) { (textField) in
            textField.placeholder = KICKIT_PLACEHOLDER_STRING
        }
        return goalCompleteAlertController
    }
    
    // MARK: - Overridden methods

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
      
        if self.currentUser == nil
        {
            let tbvc = self.tabBarController as! TabBarViewController
            guard let cu = tbvc.currentUser else { return }
            self.currentUser = cu
        }
        
        //disable editing in case user left view while in edit mode
        self.tableView.setEditing(false, animated: true)
        
        for goal in self.currentUser!.weeklyGoals
        {
            goal.checkIfDue()
        }
  
        sortWeeklyGoals()
        
        updateProgressView()

        SideMenuManager.setUpSideMenu(self.storyboard!, user: currentUser!)
        
        self.setUpLeftBarButtonItem(String(self.currentUser!.numberOfUnreviwedSummaries()))
        
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
        
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections = 0
        if (currentUser?.weeklyGoals.count) > 0
        {
            
            self.tableView!.backgroundView = nil
            numOfSections = 1
            tableView.separatorStyle = .singleLine
            
        }
        else
        {
            let weeklyPlaceholderView  = UIImageView(frame:CGRect(x: 0, y: 0, width: self.tableView!.bounds.size.width, height: self.tableView!.bounds.size.height));
            weeklyPlaceholderView.image = UIImage(named:WEEK_PLACEHOLDER)
            weeklyPlaceholderView.contentMode = .scaleAspectFill
            self.tableView.backgroundView = weeklyPlaceholderView
            tableView.separatorStyle = .none
        }
        return numOfSections
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currentUser!.weeklyGoals.count
    }
    
    //TODO: Refactor
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> GoalTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weeklyGoalCell", for: indexPath) as! GoalTableViewCell
        let goal = currentUser!.weeklyGoals[indexPath.row]
    
        
        // Configure the cell
        var klaIcon = ""
        var klaIconHighlighted = ""
        let kla = goal.kla
        
        if goal.complete
        {
            cell.isUserInteractionEnabled = false
            cell.completeButton.isEnabled = false
            //cell.accessoryType = .Checkmark
            cell.doneCircle.image = UIImage(named: "done-circle")
            cell.tintColor = UIColor.darkGray
            cell.goalTextLabel.textColor = UIColor.lightGray
            cell.dueImageIcon.isHidden = true

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
            cell.completeButton.isHidden = false
            cell.completeButton.isEnabled = true
            cell.isUserInteractionEnabled = true
            cell.accessoryType = .none
            cell.goalTextLabel.textColor = PEAK_BLACK
            cell.doneCircle.image = UIImage(named: "not-done-circle")

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
            
            cell.dueImageIcon.isHidden = false
            
            if goal.due == Goal.Due.overdue
            {
                // show due image
                cell.dueImageIcon.image = UIImage(named: OVERDUE_ICON)

            }
            else if goal.due == Goal.Due.soon
            {
                //show due soon image
                cell.dueImageIcon.image = UIImage(named: DUE_SOON_ICON)
                
            }
            else
            {
                // hide image
                cell.dueImageIcon.isHidden = true
                
            }
            
        }
        // Image button for normal and highlighted
        let imageButton = UIImage(named: klaIcon)
        let highlightedImageButton = UIImage(named: klaIconHighlighted)
        
        cell.completeButton.setBackgroundImage(imageButton, for: UIControlState())
        cell.completeButton.setBackgroundImage(highlightedImageButton, for: .highlighted)
    
        cell.goalTextLabel!.text = goal.goalText
        cell.delegate = self
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if currentUser!.weeklyGoals[indexPath.row].complete
        {
            return false
        }
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            // Delete the row from the data source
            guard let cu = self.currentUser else { return }
            let goal = cu.weeklyGoals[indexPath.row]
            self.dataService.removeGoal(cu.uid, goal: goal) // remove goal
            cu.weeklyGoals.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            removeWeeklyGoalDueSoonNotification(goal)
        }
    }
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier!
        {
        case ADD_WEEKLY_GOAL_SEGUE:
            let dvc = segue.destination as! WeeklyGoalDetailViewController
            dvc.delegate = self
            dvc.currentUser = self.currentUser
            return
            
        case EDIT_WEEKLY_GOAL_SEGUE:
            let dvc = segue.destination as! WeeklyGoalDetailViewController
            dvc.delegate = self
            dvc.currentUser = self.currentUser
            if let indexPath = self.tableView.indexPathForSelectedRow
            {
                dvc.currentGoal = currentUser!.weeklyGoals[indexPath.row]
                return
            }
            
        default:
            return
        }
    }
}
