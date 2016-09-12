//
//  SecondSummaryViewController.swift
//  PeakPerformance
//
//  Created by Bren on 12/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit

class SecondSummaryViewController: UITableViewController {

    // MARK: - Properties
    var summary: MonthlySummary?
    
    var weeklyGoalsByWeek = [[WeeklyGoal](),[WeeklyGoal](),[WeeklyGoal](),[WeeklyGoal](),[WeeklyGoal]()]
    
    // MARK: - Actions
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //rearrange weekly goals into nested arrays representing weeks of the month
        let daysInMonth = DateTracker( ).getNumberOfDaysInCurrentMonth()
        
        //default array is for five weeks, change to four if February and non leap year
        if daysInMonth == 28
        {
            weeklyGoalsByWeek = [[WeeklyGoal](),[WeeklyGoal](),[WeeklyGoal](),[WeeklyGoal]()]
        }
        
        guard let s = self.summary else
        {
            print("SSVC: problem getting summary")
            return
        }
        
        //place goals in their respective subararys depending on the week of their deadline
        for goal in s.weeklyGoals
        {
            weeklyGoalsByWeek[goal.getWeekOfGoal() - 1].append(goal)
        }
        
        //sort subarrays by goal completion
        for var weekOfGoals in weeklyGoalsByWeek
        {
            weekOfGoals.sortInPlace({!$0.complete && $1.complete})
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "Week \(section + 1)"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // number of weeks in month
        return self.weeklyGoalsByWeek.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return number of goals in each week
        return self.weeklyGoalsByWeek[section].count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> SecondSummaryTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("summaryCell", forIndexPath: indexPath) as! SecondSummaryTableViewCell

        let goal = self.weeklyGoalsByWeek[indexPath.section][indexPath.row]
        
        // Configure the cell...
        var klaIcon = ""
        let kla = goal.kla
        
        if ( goal.complete )
        {
            cell.accessoryType = .Checkmark
            cell.goalTextLabel.textColor = UIColor.lightGrayColor()
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
        else
        {
            
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
            
        }
        
        cell.goalTextLabel!.text = goal.goalText
        cell.imageView!.image = UIImage(named: klaIcon)
        cell.userInteractionEnabled = false
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
