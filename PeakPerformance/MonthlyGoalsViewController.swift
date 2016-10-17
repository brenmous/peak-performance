//
//  MonthlyGoalsViewController.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 24/07/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//


import UIKit
import SideMenu // https://github.com/jonkykong/SideMenu
import TwitterKit // https://fabric.io/kits/ios/twitterkit


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
    
    @IBAction func editButtonPressed(sender: AnyObject)
    {
        self.tableView.setEditing(tableView.editing != true, animated: true)
    }
    
    @IBAction func addButtonPressed(sender: AnyObject)
    {
        performSegueWithIdentifier(ADD_MONTHLY_GOAL_SEGUE, sender: self)
    }
    
    @IBAction func menuButtonPressed(sender: AnyObject)
    {
        //Side Menu
        presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func unwindFromMGDVC( segue: UIStoryboardSegue ){ }
    
    
    // MARK: - Methods
    
    /// Updates progress bar with the current date and progress value.
    func updateProgressBar( )
    {
        progressViewLabel.text = NSDate().monthlyProgressString()
        progressBarMG.progress = NSDate().monthlyProgressValue()
    }
    
    /**
     Adds a new goal to the array and saves it to the database.
     
     - Parameters:
     - weeklyGoal: the newly created weeklygoal
     */
    func addNewGoal( monthlyGoal: MonthlyGoal )
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
    func saveModifiedGoal(monthlyGoal: MonthlyGoal)
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
    func completeGoal( goal: MonthlyGoal )
    {
        goal.complete = true
        self.saveModifiedGoal(goal)
        removeMonthlyGoalDueSoonNotification(goal)
        sortMonthlyGoals()
        self.tableView.reloadData()
    }
    
    func completeButtonPressed( cell: MonthlyGoalTableViewCell )
    {
        //get weekly goal from cell
        guard let indexPath = self.tableView.indexPathForCell(cell) else
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
        presentViewController(goalCompleteAlertController(mg), animated: true, completion: nil)
    }
    
    /// Sorts the user's monthly goal array.
    func sortMonthlyGoals()
    {
        guard let cu = currentUser else { return }
        cu.monthlyGoals.sortInPlace({$0.deadline.compare($1.deadline) == .OrderedAscending})
        cu.monthlyGoals.sortInPlace({!$0.complete && $1.complete})
    }
    
    /// Shares completed goals on social media if user has enabled them in settings.
    func shareOnSocialMedia(goal: MonthlyGoal)
    {
        if NSUserDefaults().boolForKey(USER_DEFAULTS_TWITTER)
        {
            let composer = TWTRComposer()
            composer.setText(TWITTER_MESSAGE_MONTHLY_GOAL(goal))
            composer.showFromViewController(self) { (result) in
            }
        }
    }
    
    // MARK: - Local notifications
    
    /**
        Sechedules an iOS local notification that alerts user when monthly goals are close to due.
 
        - Parameters:
            - monthlyGoal: the goal to create a notification for.
    */
    func createMonthlyGoalDueSoonNotification(monthlyGoal: MonthlyGoal)
    {
        let notification = UILocalNotification()
        notification.alertBody = MG_NOTIFICATION_BODY(monthlyGoal)
        let calendar = NSCalendar.currentCalendar()
        // - FIXME:
        notification.fireDate = calendar.dateByAddingUnit(.Day, value: MG_NOTIFICATION_FIREDATE, toDate: monthlyGoal.deadline, options: [])
        notification.userInfo = [MG_NOTIFICATION_ID: monthlyGoal.gid]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    /**
        Deschedules the iOS local notification for a speicifed monthly goal.
 
        - Parameters:
            - monthlyGoal: goal to remove notification for.
     */
    func removeMonthlyGoalDueSoonNotification(monthlyGoal: MonthlyGoal)
    {
        guard let notifications = UIApplication.sharedApplication().scheduledLocalNotifications else { return }
        for notification in notifications
        {
            guard let key = notification.userInfo![MG_NOTIFICATION_ID] else { continue }
            if key as! String == monthlyGoal.gid
            {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                return
            }
        }
    }
    
    /**
        Updates a monthly goal notification's fire date.
    
        - Parameters:
            - monthlyGoal: the goal to update the notification for.
    */
    func updateMonthlyGoalDueSoonNotificationFireDate(monthlyGoal: MonthlyGoal)
    {
        guard let notifications = UIApplication.sharedApplication().scheduledLocalNotifications else { return }
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
    func goalCompleteAlertController(goal: MonthlyGoal) -> UIAlertController
    {
        let goalCompleteAlertController = UIAlertController( title: COMPLETION_ALERT_TITLE, message: COMPLETION_ALERT_MSG_MONTHLY, preferredStyle: .Alert )
        let confirm = UIAlertAction(title: COMPLETION_ALERT_CONFIRM_MONTHLY, style: .Default ) { (action) in
            self.completeGoal(goal)
            self.shareOnSocialMedia(goal)
        }
        let cancel = UIAlertAction(title: COMPLETION_ALERT_CANCEL, style: .Cancel, handler: nil )
        goalCompleteAlertController.addAction( confirm ); goalCompleteAlertController.addAction( cancel );
        return goalCompleteAlertController
    }
    
    
    // MARK: - Overridden methods
    
    override func viewWillAppear(animated: Bool)
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

        
        // set up badge and menu bar button item
        self.setUpLeftBarButtonItem( String(self.currentUser!.numberOfUnreviwedSummaries()) )
        
        self.tableView.reloadData()
    }

    
    // MARK: - Table view data source
    
    // SOWMYA //
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        
        if (currentUser?.monthlyGoals.count) > 0 {
            
            self.tableView!.backgroundView = nil
            numOfSections = 1
            tableView.separatorStyle = .SingleLine
            
        } else {
            
            // Creating and editing label to display when there are no Weekly Goals
            var weeklyPlaceholderView : UIImageView
            weeklyPlaceholderView  = UIImageView(frame:CGRectMake(0, 0, self.tableView!.bounds.size.width, self.tableView!.bounds.size.height));
            weeklyPlaceholderView.image = UIImage(named:MONTHLY_PLACEHOLDER)
            weeklyPlaceholderView.contentMode = .ScaleAspectFill
            self.tableView.backgroundView = weeklyPlaceholderView
            tableView.separatorStyle = .None
            
        }
        
        return numOfSections
    }
    // END SOWMYA //
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currentUser!.monthlyGoals.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("monthlyGoalCell", forIndexPath: indexPath) as! MonthlyGoalTableViewCell
        let goal = currentUser!.monthlyGoals[indexPath.row]

        //Configure the cell
        let kla = goal.kla
        cell.goalTextLabel!.text = goal.goalText
        cell.delegate = self
        var klaIcon = ""
        var klaIconHighlighted = ""
        
        if  goal.complete
        {
            cell.userInteractionEnabled = false
            cell.completeButton.enabled = false
//            cell.accessoryType = .Checkmark
            cell.doneCircle.image = UIImage(named: "done-circle")
            cell.tintColor = UIColor.darkGrayColor()
            cell.goalTextLabel.textColor = UIColor.lightGrayColor()
            cell.dueLabelIcon.hidden = true
        
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
            cell.completeButton.enabled = true
            cell.userInteractionEnabled = true
            cell.doneCircle.image = UIImage(named: "not-done-circle")
            cell.accessoryType = .None
            cell.goalTextLabel.textColor = PEAK_BLACK
            cell.dueLabelIcon.hidden = false
            
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
                cell.dueLabelIcon.hidden = true
            }
        }
        
        // Image button for normal and highlighted
        let imageButton = UIImage(named: klaIcon)
        let highlightedImageButton = UIImage(named: klaIconHighlighted)
        cell.completeButton.setBackgroundImage(imageButton, forState: .Normal)
        cell.completeButton.setBackgroundImage(highlightedImageButton, forState: .Highlighted)
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        if currentUser!.monthlyGoals[indexPath.row].complete
        {
            return false
        }
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete
        {
            // Delete the row from the data source
            guard let cu = self.currentUser else { return }
            self.dataService.removeGoal(cu.uid, goal: cu.monthlyGoals[indexPath.row])
            cu.monthlyGoals.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // MARK: - Navigation


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier!
        {
        case ADD_MONTHLY_GOAL_SEGUE:
            let dvc = segue.destinationViewController as! MonthlyGoalDetailViewController
            dvc.delegate = self
            dvc.currentUser = self.currentUser
            
        case EDIT_MONTHLY_GOAL_SEGUE:
            let dvc = segue.destinationViewController as! MonthlyGoalDetailViewController
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

