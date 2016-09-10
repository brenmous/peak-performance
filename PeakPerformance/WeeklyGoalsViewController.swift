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
    
    /// This view controller's data service.
    let dataService = DataService( )
    
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
        let dateTracker = DateTracker( )
        progressViewLabel.text = dateTracker.getWeeklyProgressString()
        progressViewWG.progress = dateTracker.getWeeklyProgressValue()
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
        dataService.saveGoal(cu.uid, goal: weeklyGoal)
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
        dataService.saveGoal(cu.uid, goal: weeklyGoal)
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
            self.completeGoal(wg, kickItText: kickItText) }
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
                //no user fix it man, goddamn you fix it what do i pay you for?!?!
                return
            }
            self.currentUser = cu
            print("WGVC: got user \(currentUser!.email) with \(cu.weeklyGoals.count) weekly goals") //DEBUG
        }
        
        //disable editing in case user left view while in edit mode
        self.tableView.setEditing(false, animated: true)
        
        //sort completed goals and place them at end of array
        currentUser!.weeklyGoals.sortInPlace({!$0.complete && $1.complete})
        
        //update progress bar
        updateProgressView()
        
        //set up side menu
        SideMenuManager.setUpSideMenu(self.storyboard!, user: currentUser! ) //func declaration is in SideMenuViewController

        //check if a monthly review is needed
        let alert = MonthlyReviewHelper(user: self.currentUser!).checkMonthlyReview()
        if alert != nil
        {
            self.presentViewController(alert!, animated: true, completion: nil)
        }

        //reload the view
        self.tableView.reloadData()
        
        
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        DateTracker( ).getCurrentYearAsString()
    
    }
 
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //only count goals with summarised = false
        return currentUser!.weeklyGoals.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> GoalTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("weeklyGoalCell", forIndexPath: indexPath) as! GoalTableViewCell
        let goal = currentUser!.weeklyGoals[indexPath.row]
    
        
        // Configure the cell...
        var klaIcon: String
        let kla = goal.kla
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
 

        cell.goalTextLabel!.text = goal.goalText
        cell.imageView!.image = UIImage(named: klaIcon)
        cell.delegate = self
        
        if ( goal.complete )
        {
            cell.completeButton.hidden = true
            cell.completeButton.enabled = false
            cell.accessoryType = .Checkmark
        }
        else
        {
            cell.completeButton.hidden = false
            cell.completeButton.enabled = true
            cell.accessoryType = .None
        }
        

        
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
            dataService.removeGoal(cu.uid, goal: cu.weeklyGoals[indexPath.row]) // remove goal
            cu.weeklyGoals.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        else if editingStyle == .Insert
        {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
