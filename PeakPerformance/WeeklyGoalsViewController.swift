//
//  WeeklyGoalsViewController.swift
//  PeakPerformance
//
//  Created by Bren on 24/07/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit


/**
    Class that controls the weekly goals view.
  */
class WeeklyGoalsViewController: UITableViewController, WeeklyGoalDetailViewControllerDelegate {

    // MARK: - Properties

    /// The currently authenticated user.
    var currentUser: User?
    
    /// The user's weekly goals.
    var weeklyGoals = [WeeklyGoal]( )

    
    // MARK: - Actions
    
    @IBAction func editButtonPressed(sender: AnyObject)
    {
        self.tableView.setEditing(true, animated: true)
    }
    
    @IBAction func addButtonPressed(sender: AnyObject)
    {
       performSegueWithIdentifier(ADD_WEEKLY_GOAL_SEGUE, sender: self)
    }
    
    @IBAction func menuButtonPressed(sender: AnyObject) {
    }
    
    
    // MARK: - Methods
    
    func addNewGoal( weeklyGoal: WeeklyGoal )
    {
        weeklyGoals.append(weeklyGoal)
        let tbvc = self.tabBarController as! TabBarViewController
        tbvc.weeklyGoals.append(weeklyGoal)
        tbvc.dataService.saveGoal((currentUser?.uid)!, goal: weeklyGoal)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //Get data from tab bar view controller
        let tbvc = self.tabBarController as! TabBarViewController
        
        if let cu = tbvc.currentUser
        {
            self.currentUser = cu
        }
        self.weeklyGoals = tbvc.weeklyGoals
        tableView.reloadData( )
        print("WGVC: got user \(currentUser!.email) with \(weeklyGoals.count) weekly goals") //DEBUG
        print("WGVC: \(tableView.numberOfRowsInSection(0)) rows in table") //DEBUG
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return weeklyGoals.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("weeklyGoalCell", forIndexPath: indexPath)
        let goal = weeklyGoals[indexPath.row]
        
        // Configure the cell...
        cell.textLabel!.text = goal.gid //whatever we want the goal to be called

        //TODO: set image as KLA icon
        /*
        //var klaIcon =
        let kla = goal.kla
        switch kla
        {
            case KLA_FAMILY:
                klaIcon = familyIcon
            
            etc.
            
        }
        */
        
        //TODO: add checkbox in here somewhere
        
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
            let tbvc = self.tabBarController as! TabBarViewController
            if let cu = self.currentUser
            {
                tbvc.dataService.removeWeeklyGoal( cu.uid, weeklyGoalID: weeklyGoals[indexPath.row].gid )
            }
            weeklyGoals.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        else if editingStyle == .Insert
        {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ADD_WEEKLY_GOAL_SEGUE
        {
            let dvc = segue.destinationViewController as! WeeklyGoalDetailViewController
            dvc.delegate = self
            dvc.currentUser = self.currentUser
        }
    }
    

}
