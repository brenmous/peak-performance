//
//  SecondSummaryViewController.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 12/09/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit

class SecondSummaryViewController: UITableViewController {

    // MARK: - Properties
    var summary: MonthlySummary?
    
    var weeklyGoalsByWeek = [[WeeklyGoal](),[WeeklyGoal](),[WeeklyGoal](),[WeeklyGoal](),[WeeklyGoal]()]
    
    
    // MARK: - Overriden methods
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Nav bar back button
        self.navigationController?.navigationBar.tintColor = PEAK_NAV_BAR_COLOR
        
        //rearrange weekly goals into nested arrays representing weeks of the month
        let daysInMonth = Date( ).numberOfDaysInCurrentMonth()
        
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
        
        //place goals in their respective subararrays depending on the week of their deadline
        for goal in s.weeklyGoals
        {
            weeklyGoalsByWeek[goal.getWeekOfGoal() - 1].append(goal)
        }
        
        //sort completed goals and place them at end of array
        for index in 0...weeklyGoalsByWeek.count - 1
        {
            if !weeklyGoalsByWeek[index].isEmpty
            {
                weeklyGoalsByWeek[index].sort(by: {$0.complete && !$1.complete})
            }
        }
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "Week \(section + 1)"
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = font
        header.textLabel?.textColor = PEAK_NAV_BAR_COLOR
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // number of weeks in month
        return self.weeklyGoalsByWeek.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        //if there were no goals for that week, make a section for a "no goals" label
        if self.weeklyGoalsByWeek[section].count == 0
        {
            return 1
        }
        
        // return number of goals in each week
        return self.weeklyGoalsByWeek[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if !self.weeklyGoalsByWeek[indexPath.section].isEmpty
        {
            let goal = self.weeklyGoalsByWeek[indexPath.section][indexPath.row]
            if !goal.kickItText.isEmpty
            {
                return CGFloat(ROWHEIGHT_KICK_IT)
            }
        }
        return CGFloat(ROWHEIGHT_NO_KICK_IT)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> SecondSummaryTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath) as! SecondSummaryTableViewCell
 
        
        //no goals for this week so present "no goal" label
        if self.weeklyGoalsByWeek[indexPath.section].isEmpty
        {
            var frame: CGRect = cell.goalTextLabel.frame
            frame.origin.x = 20
            cell.goalTextLabel.frame = frame
            cell.goalTextLabel.translatesAutoresizingMaskIntoConstraints = true
            cell.goalTextLabel.text = NO_WEEKLY_GOALS_MESSAGE
            cell.goalTextLabel.textColor = UIColor.lightGray
            cell.isUserInteractionEnabled = false
            cell.selectionStyle = .none

  
            return cell
        }
        
        let goal = self.weeklyGoalsByWeek[indexPath.section][indexPath.row]
        
        // Only displays separator when there are goals to show
        for week in weeklyGoalsByWeek {
            if !week .isEmpty {
                tableView.separatorStyle = .singleLine
                cell.separatorInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0)
            }
        }

        // Configure the cell...
        
        cell.kickItTextView.isHidden = true
        
        var klaIcon = ""
        let kla = goal.kla
        
        if goal.complete
        {
            cell.goalTextLabel.textColor = PEAK_BLACK
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
            
            if !goal.kickItText.isEmpty
            {
                cell.kickItTextView.text = "Kick it to the next level: \(goal.kickItText)"
                cell.kickItTextView.isHidden = false
            }
         
            
        }
        else
        {
            cell.accessoryType = .none
            cell.goalTextLabel.textColor = UIColor.lightGray
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
        
        cell.goalTextLabel.text = goal.goalText
        cell.klaIconImageView.image = UIImage(named: klaIcon)
        cell.isUserInteractionEnabled = false
        cell.selectionStyle = .none
        return cell
    }
}
