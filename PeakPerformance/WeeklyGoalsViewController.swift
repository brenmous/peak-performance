//
//  WeeklyGoalsViewController.swift
//  PeakPerformance
//
//  Created by Bren on 24/07/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit
import Firebase
import SideMenu //github.com/jonkeykong/SideMenu

/**
    Class that controls the weekly goals view.
  */
class WeeklyGoalsViewController: UITableViewController, WeeklyGoalDetailViewControllerDelegate, GoalTableViewCellDelegate
{

    // MARK: - Properties

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
    @IBAction func editButtonPressed(sender: AnyObject)
    {
        self.tableView.setEditing(tableView.editing != true, animated: true) // :)
    }
    
    @IBAction func addButtonPressed(sender: AnyObject)
    {
       performSegueWithIdentifier(ADD_WEEKLY_GOAL_SEGUE, sender: self)
    }
    
    @IBAction func menuButtonPressed(sender: AnyObject)
    {
        
        presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func unwindFromWGDVC( segue: UIStoryboardSegue){}
    
    
    // MARK: - Methods
    
    /// Updates the progress bar with the current date and progress value.
    func updateProgressView()
    {
        progressViewLabel.text = NSDate().weeklyProgressString()
        progressViewWG.progress = NSDate().weeklyProgressValue()
    }
    
    /**
        Adds a new goal to the array and saves it to the database.
        
        - Parameters:
            - weeklyGoal: the newly created weeklygoal
    */
    func addNewGoal(weeklyGoal: WeeklyGoal)
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
    func saveModifiedGoal(weeklyGoal: WeeklyGoal)
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
    func completeGoal(goal: WeeklyGoal, kickItText: String)
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
    func completeButtonPressed( cell: GoalTableViewCell )
    {
        //get weekly goal from cell
        guard let indexPath = self.tableView.indexPathForCell(cell) else { return }
        guard let cu = self.currentUser else { return }
        let wg = cu.weeklyGoals[indexPath.row]
    
        //TODO: place in UIAlertController extensions
        //goal completion confirm alert controller
        let goalCompleteAlertController = UIAlertController( title: COMPLETION_ALERT_TITLE, message: COMPLETION_ALERT_MSG, preferredStyle: .Alert )
        let confirm = UIAlertAction(title: COMPLETION_ALERT_CONFIRM, style: .Default ) { (action) in
            let kickItTextField = goalCompleteAlertController.textFields![0] as UITextField
            let kickItText = kickItTextField.text!
            self.completeGoal(wg, kickItText: kickItText)
        }
        let cancel = UIAlertAction(title: COMPLETION_ALERT_CANCEL, style: .Cancel, handler: nil )
        goalCompleteAlertController.addAction( confirm ); goalCompleteAlertController.addAction( cancel );
        goalCompleteAlertController.addTextFieldWithConfigurationHandler( ) { (textField) in
            textField.placeholder = KICKIT_PLACEHOLDER_STRING
        }
        presentViewController(goalCompleteAlertController, animated: true, completion: nil )
    }
    
    /// Sorts user's weekly goals.
    func sortWeeklyGoals()
    {
        guard let cu = currentUser else { return }
        cu.weeklyGoals.sortInPlace({$0.deadline.compare($1.deadline) == .OrderedAscending})
        cu.weeklyGoals.sortInPlace({!$0.complete && $1.complete})
    }
    
    // MARK: - Local notifications
    /**
     Schedules an iOS local notification that alerts user when a weekly goal is due soon.
     
     - Parameters:
     - weeklyGoal: the goal to create a notification for.
     */
    func createWeeklyGoalDueSoonNotification(weeklyGoal: WeeklyGoal)
    {
        let notification = UILocalNotification()
        notification.alertBody = WG_NOTIFICATION_BODY(weeklyGoal)
        
        /* Notification for due soon
         let calendar = NSCalendar.currentCalendar()
         notification.fireDate = calendar.dateByAddingUnit(.Day, value: -(weeklyGoal.daysTillDueSoon), toDate: weeklyGoal.deadline, options: [])
         */
        
        notification.fireDate = weeklyGoal.deadline
        notification.userInfo = [WG_NOTIFICATION_ID: weeklyGoal.gid]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        //DEBUG
        print("created notification: \(notification.alertBody) for date \(notification.fireDate)")
    }
    
    /**
     Deschedules the iOS local notification for a specified weekly goal.
     
     - Parameters:
     - weeklyGoal: the goal to remove the notification for.
     */
    func removeWeeklyGoalDueSoonNotification(weeklyGoal: WeeklyGoal)
    {
        guard let notifications = UIApplication.sharedApplication().scheduledLocalNotifications else { return }
        for notification in notifications
        {
            guard let key = notification.userInfo![WG_NOTIFICATION_ID] else { continue }
            if key as! String == weeklyGoal.gid
            {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                return
            }
        }
    }
    
    
    /**
     Updates a weekly goal notification's fire date.
     
     - Parameters:
     - weeklyGoal: the goal to update the notification for.
     */
    func updateWeeklyGoalDueSoonNotificationFireDate(weeklyGoal: WeeklyGoal)
    {
        guard let notifications = UIApplication.sharedApplication().scheduledLocalNotifications else { return }
        for notification in notifications
        {
            guard let key = notification.userInfo![WG_NOTIFICATION_ID] else { continue }
            if key as! String == weeklyGoal.gid
            {
                /* Notification for due soon
                 let calendar = NSCalendar.currentCalendar()
                 notification.fireDate = calendar.dateByAddingUnit(.Day, value: -(weeklyGoal.daysTillDueSoon), toDate: weeklyGoal.deadline, options: [])
                 */
                
                notification.fireDate = weeklyGoal.deadline
                return
            }
        }
    }
    
    // MARK: - Overridden methods

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
      
        if self.currentUser == nil
        {
            let tbvc = self.tabBarController as! TabBarViewController
            guard let cu = tbvc.currentUser else { return }
            self.currentUser = cu
            print("WGVC: got user \(currentUser!.email) with \(cu.weeklyGoals.count) weekly goals") //DEBUG
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
            self.presentViewController(UIAlertController.AnnualReviewAlert(self.tabBarController as! TabBarViewController), animated: true, completion: nil)
        }
            //only check for monthly reviews if the year hasn't changed, because if it has we know we need 12 months of reviews
        else
        {
            //check if a monthly review is needed
            if self.currentUser!.checkMonthlyReview()
            {
                self.presentViewController(UIAlertController.getReviewAlert(self.tabBarController as! TabBarViewController), animated: true, completion: nil)
            }
        }
        
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        var numOfSections = 0
        if (currentUser?.weeklyGoals.count) > 0
        {
            
            self.tableView!.backgroundView = nil
            numOfSections = 1
            tableView.separatorStyle = .SingleLine
            
        }
        else
        {
            let weeklyPlaceholderView  = UIImageView(frame:CGRectMake(0, 0, self.tableView!.bounds.size.width, self.tableView!.bounds.size.height));
            weeklyPlaceholderView.image = UIImage(named:WEEK_PLACEHOLDER)
            weeklyPlaceholderView.contentMode = .ScaleAspectFill
            self.tableView.backgroundView = weeklyPlaceholderView
            tableView.separatorStyle = .None
        }
        return numOfSections
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currentUser!.weeklyGoals.count
    }
    
    //TODO: Refactor
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> GoalTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("weeklyGoalCell", forIndexPath: indexPath) as! GoalTableViewCell
        let goal = currentUser!.weeklyGoals[indexPath.row]
    
        
        // Configure the cell...
        var klaIcon = ""
        var klaIconHighlighted = ""
        let kla = goal.kla
        
        if goal.complete
        {
            cell.userInteractionEnabled = false
            cell.completeButton.hidden = true
            cell.completeButton.enabled = false
            cell.accessoryType = .Checkmark
            cell.goalTextLabel.textColor = UIColor.lightGrayColor()
            cell.dueImageIcon.hidden = true

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
            
            // use image instead of the button
            cell.iconImage.image = UIImage(named: klaIcon)
            
        }
        else if !goal.complete
        {
            cell.completeButton.hidden = false
            cell.completeButton.enabled = true
            cell.userInteractionEnabled = true
            cell.accessoryType = .None
            cell.goalTextLabel.textColor = UIColor.init(red: 54/255, green: 50/255, blue: 42/255, alpha: 1)
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
            
            cell.dueImageIcon.hidden = false
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
                cell.dueImageIcon.hidden = true
               
            }

        }
        // Image button for normal and highlighted
        let imageButton = UIImage(named: klaIcon)
        let highlightedImageButton = UIImage(named: klaIconHighlighted)
        cell.completeButton.setBackgroundImage(imageButton, forState: .Normal)
        cell.completeButton.setBackgroundImage(highlightedImageButton, forState: .Highlighted)
    
        cell.goalTextLabel!.text = goal.goalText
        cell.delegate = self
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            // Delete the row from the data source
            guard let cu = self.currentUser else { return }
            let goal = cu.weeklyGoals[indexPath.row]
            self.dataService.removeGoal(cu.uid, goal: goal) // remove goal
            cu.weeklyGoals.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            removeWeeklyGoalDueSoonNotification(goal)
        }
    }
    
    // MARK: - Navigation
    
    //TODO: Change if to switch
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ADD_WEEKLY_GOAL_SEGUE
        {
            let dvc = segue.destinationViewController as! WeeklyGoalDetailViewController
            dvc.delegate = self
            dvc.currentUser = self.currentUser
            return
        }
        else if segue.identifier == EDIT_WEEKLY_GOAL_SEGUE
        {
            let dvc = segue.destinationViewController as! WeeklyGoalDetailViewController
            dvc.delegate = self
            dvc.currentUser = self.currentUser
            if let indexPath = self.tableView.indexPathForSelectedRow
            {
                dvc.currentGoal = currentUser!.weeklyGoals[indexPath.row]
                return
            }
        }
        
    }
}
