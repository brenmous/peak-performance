//
//  MonthlyGoalsViewController.swift
//  PeakPerformance
//
//  Created by Bren on 24/07/2016.
//  Copyright © 2016 derridale. All rights reserved.
//


import UIKit
import SideMenu

//TODO: - change complete alert controller (no kick it)
/**
 Class that controls the weekly goals view.
 */
class MonthlyGoalsViewController: UITableViewController, MonthlyGoalDetailViewControllerDelegate, MonthlyGoalTableViewCellDelegate {
    
    // MARK: - Properties
    
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
        DataService.saveGoal(cu.uid, goal: monthlyGoal)
    }
    
    /**
     Updates the values of the weekly goal that is currently being editied and saves it to the database.
     
     - Parameters:
     - weeklyGoal: the edited weekly goal.
     */
    func saveModifiedGoal(monthlyGoal: MonthlyGoal )
    {
        guard let cu = currentUser else
        {
            //user not available handle it HANDLE IT!
            return
        }
        DataService.saveGoal(cu.uid, goal: monthlyGoal)
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
        print("MGVC: goal \(goal.gid) complete!")
        
        //sort completed goals and place them at end of array
        guard let cu = currentUser else
        {
            return
        }
        cu.monthlyGoals.sortInPlace({!$0.complete && $1.complete})
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
        let goalCompleteAlertController = UIAlertController( title: COMPLETION_ALERT_TITLE, message: COMPLETION_ALERT_MSG_MONTHLY, preferredStyle: .Alert )
        let confirm = UIAlertAction(title: COMPLETION_ALERT_CONFIRM_MONTHLY, style: .Default ) { (action) in self.completeGoal(mg) }
        let cancel = UIAlertAction(title: COMPLETION_ALERT_CANCEL, style: .Cancel, handler: nil )
        goalCompleteAlertController.addAction( confirm ); goalCompleteAlertController.addAction( cancel );
        presentViewController(goalCompleteAlertController, animated: true, completion: nil )
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
                //no user fix it man, goddamn you fix it what do i pay you for?!?!
                return
            }
            self.currentUser = cu
            tableView.reloadData( )
            print("MGVC: got user \(currentUser!.email) with \(cu.monthlyGoals.count) monthly goals") //DEBUG
        }
        
        //disable editing in case user left view while in edit mode
        self.tableView.setEditing(false, animated: true)
        
        //sort completed goals and place them at end of array
        currentUser!.monthlyGoals.sortInPlace({!$0.complete && $1.complete})
        
        for goal in currentUser!.monthlyGoals
        {
            goal.checkIfDue()
        }
        
        //update progress bar
        updateProgressBar()
        
        //Side Menu
        SideMenuManager.setUpSideMenu(self.storyboard!, user: self.currentUser!) //func declaration is in SideMenuViewController
        
        //check if a monthly review is needed
        if self.currentUser!.checkMonthlyReview()
        {
            self.presentViewController(UIAlertController.getReviewAlert(self.tabBarController as! TabBarViewController ), animated: true, completion: nil)
        }
        
        // set up badge and menu bar button item
        self.setUpLeftBarButtonItem( String(self.currentUser!.numberOfUnreviwedSummaries()) )
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    
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
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currentUser!.monthlyGoals.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("monthlyGoalCell", forIndexPath: indexPath) as! MonthlyGoalTableViewCell
        let goal = currentUser!.monthlyGoals[indexPath.row]
        
    
        
        //Configure the cell
        var klaIcon = ""
        var klaIconDone = ""
        var klaIconHighlighted = ""
        let kla = goal.kla
        
        if  goal.complete
        {
            cell.userInteractionEnabled = false
            cell.completeButton.hidden = true
            cell.completeButton.enabled = false
            cell.accessoryType = .Checkmark
            cell.tintColor = UIColor.darkGrayColor()
            cell.goalTextLabel.textColor = UIColor.lightGrayColor()
            cell.dueLabelIcon.hidden = true
            
            switch kla
            {
            case KLA_FAMILY:
                klaIconDone = "F-done.png"
                
            case KLA_WORKBUSINESS:
                klaIconDone = "W-done.png"
                
            case KLA_PARTNER:
                klaIconDone = "P-done.png"
                
            case KLA_FINANCIAL:
                klaIconDone = "FI-done.png"
                
            case KLA_PERSONALDEV:
                klaIconDone = "PD-done.png"
                
            case KLA_EMOSPIRITUAL:
                klaIconDone = "ES-done.png"
                
            case KLA_HEALTHFITNESS:
                klaIconDone = "H-done.png"
                
            case KLA_FRIENDSSOCIAL:
                klaIconDone = "FR-done.png"
                
            default:
                klaIconDone = "F-done.png"
            }
            
            // use image instead of the button
            cell.iconImage.image = UIImage(named: klaIconDone)
        
        }
            
        else
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
            
            cell.dueLabelIcon.hidden = false
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
//        cell.completeButton.setImage(highlightedImageButton, forState: .Highlighted)
        
        cell.goalTextLabel!.text = goal.goalText
        cell.delegate = self
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete
        {
            // Delete the row from the data source
            guard let cu = self.currentUser else
            {
                //no user! wuh oh!
                return
            }
            DataService.removeGoal(cu.uid, goal: cu.monthlyGoals[indexPath.row])
            cu.monthlyGoals.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // MARK: - Navigation


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ADD_MONTHLY_GOAL_SEGUE
        {
            let dvc = segue.destinationViewController as! MonthlyGoalDetailViewController
            dvc.delegate = self
            dvc.currentUser = self.currentUser
        }
        else if segue.identifier == EDIT_MONTHLY_GOAL_SEGUE
        {
            let dvc = segue.destinationViewController as! MonthlyGoalDetailViewController
            dvc.delegate = self
            dvc.currentUser = self.currentUser
            if let indexPath = self.tableView.indexPathForSelectedRow
            {
                dvc.currentGoal = currentUser!.monthlyGoals[indexPath.row]
            }
        }
    }
    
    
}

