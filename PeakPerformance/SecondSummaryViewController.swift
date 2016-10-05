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
    
    // MARK: - Overriden methods
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Nav bar back button
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 54/255, green: 54/255, blue: 52/255, alpha: 1);
        
        //rearrange weekly goals into nested arrays representing weeks of the month
        let daysInMonth = NSDate( ).numberOfDaysInCurrentMonth()
        
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
        
        //sort completed goals and place them at end of array
        for index in 0...weeklyGoalsByWeek.count - 1
        {
            if !weeklyGoalsByWeek[index].isEmpty
            {
                weeklyGoalsByWeek[index].sortInPlace({$0.complete && !$1.complete})
            }
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
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let font = UIFont.systemFontOfSize(14, weight: UIFontWeightSemibold)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = font
        header.textLabel?.textColor = UIColor.init(red: 54/255, green: 54/255, blue: 52/255, alpha: 1);
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // number of weeks in month
        return self.weeklyGoalsByWeek.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //if there were no goals for that week, make a section for a "no goals" label
        if self.weeklyGoalsByWeek[section].count == 0
        {
            return 1
        }
        
        // return number of goals in each week
        return self.weeklyGoalsByWeek[section].count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if !self.weeklyGoalsByWeek[indexPath.section].isEmpty
        {
            let goal = self.weeklyGoalsByWeek[indexPath.section][indexPath.row]
            if !goal.kickItText.isEmpty
            {
                return 130 //TODO: - Make row height constants
            }
        }
        return 53
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> SecondSummaryTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("summaryCell", forIndexPath: indexPath) as! SecondSummaryTableViewCell

        //no goals for this week so present "no goal" label
        if self.weeklyGoalsByWeek[indexPath.section].isEmpty
        {
            var frame: CGRect = cell.goalTextLabel.frame
            frame.origin.x = 20
            cell.goalTextLabel.frame = frame
            cell.goalTextLabel.translatesAutoresizingMaskIntoConstraints = true
            cell.goalTextLabel.text = "No goals for this week." //TODO: - Make constant
            cell.goalTextLabel.textColor = UIColor.lightGrayColor()
            cell.userInteractionEnabled = false
            cell.selectionStyle = .None
            return cell
        }
        
        let goal = self.weeklyGoalsByWeek[indexPath.section][indexPath.row]
        
        // Configure the cell...
        
        cell.kickItTextView.hidden = true
        
        var klaIcon = ""
        let kla = goal.kla
        
        if goal.complete
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
            
            if !goal.kickItText.isEmpty
            {
                cell.kickItTextView.text = "Kick it to the next level: \(goal.kickItText)"
                cell.kickItTextView.hidden = false
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
        
        cell.goalTextLabel.text = goal.goalText
        cell.klaIconImageView.image = UIImage(named: klaIcon)
        cell.userInteractionEnabled = false
        cell.selectionStyle = .None
        
        return cell
    }


}
