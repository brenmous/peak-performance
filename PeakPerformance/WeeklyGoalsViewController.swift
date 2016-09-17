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
class WeeklyGoalsViewController: UITableViewController, WeeklyGoalDetailViewControllerDelegate, GoalTableViewCellDelegate  {

    // MARK: - Properties

    /// The currently authenticated user.
    var currentUser: User?
  
    
    // MARK: Outlets
    
    //progress bar
    @IBOutlet weak var progressViewWG: UIProgressView!
    @IBOutlet weak var progressViewLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func editButtonPressed(sender: AnyObject)
    {
        self.tableView.setEditing(tableView.editing != true, animated: true) // :)
    }
    
    @IBAction func addButtonPressed(sender: AnyObject)
    {
       performSegueWithIdentifier(ADD_WEEKLY_GOAL_SEGUE, sender: self)
    }
    
    @IBAction func menuButtonPressed(sender: AnyObject) {
        
        presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func unwindFromWGDVC( segue: UIStoryboardSegue)
    {
    
    }
    
    
    // MARK: - Methods
    
    /// Updates the progress bar with the current date and progress value.
    func updateProgressView( )
    {
        progressViewLabel.text = NSDate().getWeeklyProgressString()
        progressViewWG.progress = NSDate().getWeeklyProgressValue()
    }
    
    /**
        Adds a new goal to the array and saves it to the database.
        
        - Parameters:
            - weeklyGoal: the newly created weeklygoal
    */
    func addNewGoal( weeklyGoal: WeeklyGoal )
    {
        guard let cu = currentUser else
        {
            //user not available? handle it here
            return
        }
        cu.weeklyGoals.append( weeklyGoal )
        DataService.saveGoal(cu.uid, goal: weeklyGoal)
    }
    
    /**
        Updates the values of the weekly goal that is currently being editied and saves it to the database.
 
        - Parameters:
            - weeklyGoal: the edited weekly goal.
    */
    func saveModifiedGoal(weeklyGoal: WeeklyGoal)
    {
        guard let cu = currentUser else
        {
            //user not available handle it HANDLE IT!
            return
        }
        DataService.saveGoal(cu.uid, goal: weeklyGoal)
    }
    
    /**
        Marks a goal as complete, updates it in the database and organises the table to reflect change.

        - Parameters:
            - goal: the goal being completed.
    */
    func completeGoal( goal: WeeklyGoal, kickItText: String )
    {
        goal.complete = true
        goal.kickItText = kickItText
        self.saveModifiedGoal(goal)
        print("WGVC: goal \(goal.gid) complete") //DEBUG
        
        //sort completed goals and place them at end of array
        guard let cu = currentUser else
        {
            return
        }
        cu.weeklyGoals.sortInPlace({!$0.complete && $1.complete})
        self.tableView.reloadData()
    }
    
    func completeButtonPressed( cell: GoalTableViewCell )
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
        let wg = cu.weeklyGoals[indexPath.row]
        
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
            print("WGVC: got user \(currentUser!.email) with \(cu.weeklyGoals.count) weekly goals") //DEBUG
        }
        
        //disable editing in case user left view while in edit mode
        self.tableView.setEditing(false, animated: true)
        
        //check for due goals
        for goal in self.currentUser!.weeklyGoals
        {
            goal.checkIfDue()
            if goal.due
            {
                print("\(goal.goalText) is overdue")
            }
        }
        
        //sort completed goals and place them at end of array
        currentUser!.weeklyGoals.sortInPlace({!$0.complete && $1.complete})
        
        //update progress bar
        updateProgressView()
        
        //set up side menu
        SideMenuManager.setUpSideMenu(self.storyboard!, user: currentUser! )

        //check if a monthly review is needed
        if self.currentUser!.checkMonthlyReview()
        {
            self.presentViewController(UIAlertController.getReviewAlert( ), animated: true, completion: nil)
        }

        self.setUpLeftBarButtonItem( String(self.currentUser!.numberOfUnreviwedSummaries()) )
        
        //reload the view
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
        
        
        if (currentUser?.weeklyGoals.count) > 0 {
            
            self.tableView!.backgroundView = nil
            numOfSections = 1
            tableView.separatorStyle = .SingleLine
            
        } else {
            
            // Creating and editing label to display when there are no Weekly Goals
            let weeklyGoalPlaceholderView: UILabel = UILabel(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
            weeklyGoalPlaceholderView.text = WEEKLY_GOALS_PLACEHOLDER;
            weeklyGoalPlaceholderView.textColor = UIColor.grayColor()
            weeklyGoalPlaceholderView.textAlignment = .Center
            weeklyGoalPlaceholderView.numberOfLines = 0
            weeklyGoalPlaceholderView.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            self.tableView.backgroundView = weeklyGoalPlaceholderView
            tableView.separatorStyle = .None
            
        }
        
        return numOfSections
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //only count goals with summarised == false
        return currentUser!.weeklyGoals.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> GoalTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("weeklyGoalCell", forIndexPath: indexPath) as! GoalTableViewCell
        let goal = currentUser!.weeklyGoals[indexPath.row]
    
        
        // Configure the cell...
        var klaIcon = ""
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
        }
        else if !goal.complete
        {
            cell.completeButton.hidden = false
            cell.completeButton.enabled = true
            cell.accessoryType = .None
            cell.goalTextLabel.textColor = UIColor.init(red: 54/255, green: 50/255, blue: 42/255, alpha: 1)
            switch kla
            {
            case KLA_FAMILY:
                klaIcon = "F.png"
                
            case KLA_WORKBUSINESS:
                klaIcon = "W.png"
                
            case KLA_PARTNER:
                klaIcon = "P.png"
                
            case KLA_FINANCIAL:
                klaIcon = "FI.png"
                
            case KLA_PERSONALDEV:
                klaIcon = "PD.png"
                
            case KLA_EMOSPIRITUAL:
                klaIcon = "ES.png"
                
            case KLA_HEALTHFITNESS:
                klaIcon = "H.png"
                
            case KLA_FRIENDSSOCIAL:
                klaIcon = "FR.png"
                
            default:
                klaIcon = "F.png"
            }
            
            if goal.due
            {
                //show due image
                cell.dueImageIcon.hidden = false
                
            } else {
                // hide image
                cell.dueImageIcon.hidden = true
               
            }

        }
        
        cell.goalTextLabel!.text = goal.goalText
        cell.imageView!.image = UIImage(named: klaIcon)
        cell.delegate = self
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            // Delete the row from the data source
            guard let cu = self.currentUser else
            {
                //no user! wuh oh!
                return
            }
            DataService.removeGoal(cu.uid, goal: cu.weeklyGoals[indexPath.row]) // remove goal
            cu.weeklyGoals.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // MARK: - Navigation
    
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ADD_WEEKLY_GOAL_SEGUE
        {
            let dvc = segue.destinationViewController as! WeeklyGoalDetailViewController
            dvc.delegate = self
            dvc.currentUser = self.currentUser
        }
        else if segue.identifier == EDIT_WEEKLY_GOAL_SEGUE
        {
            let dvc = segue.destinationViewController as! WeeklyGoalDetailViewController
            dvc.delegate = self
            dvc.currentUser = self.currentUser
            if let indexPath = self.tableView.indexPathForSelectedRow
            {
                dvc.currentGoal = currentUser!.weeklyGoals[indexPath.row]
            }
        }
        
    }
}
