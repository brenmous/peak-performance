//
//  DataService.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 18/07/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import Foundation
import Firebase // https://firebase.google.com


/**
    This class handles read/write to the Firebase realtime database.
  */
class DataService
{
    // MARK: - Properties
    let database = FIRDatabase.database()

    
    // MARK: - User Methods
    
    /**
        Saves a user's details to the database.
        This method is used only when creating a user for the first time at sign up and only saves personal info.

        - Parameters:
            - user: the user being saved.
    */
    func saveUser(_ user: User)
    {
        //self.database.goOnline()
        
        
        //Create child references from FIRDatabase.database().reference() to define the nodes that data will be stored under.
        // E.g. "Base -> Users -> UserID"
        let userRef = self.database.reference().child(USERS_REF_STRING).child(user.uid)

        //Create child references for each property and use setValue to store the corresponding value.
        userRef.child(FNAME_REF_STRING).setValue(user.fname)
        userRef.child(LNAME_REF_STRING).setValue(user.lname)
        userRef.child(ORG_REF_STRING).setValue(user.org)
        userRef.child(EMAIL_REF_STRING).setValue(user.email)
        
        //convert startDate to string
        let dateFormatter = DateFormatter( )
        dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
        let startDateString = dateFormatter.string(from: user.startDate as Date)
        
        userRef.child(STARTDATE_REF_STRING).setValue(startDateString)
        
        //self.database.goOffline()
    }
    
    /**
        Save's user's coach email to database.
        
        - Parameters:
            - user: user whose coach email to save.
    */
    func saveCoachEmail(_ user: User)
    {
        //self.database.goOnline()
        
        let userRef = self.database.reference().child(USERS_REF_STRING).child(user.uid)
        userRef.child(COACH_EMAIL_REF_STRING).setValue(user.coachEmail)

        //self.database.goOffline()
    }
    
    /** 
        Save's user's current year of program to database.
 
        - Parameters:
            - user: owner of year being saved.
    */
    func saveUserYear(_ user: User)
    {
        //self.database.goOnline()
        
        let userRef = self.database.reference().child(USERS_REF_STRING).child(user.uid)
        userRef.child(USER_YEAR_REF_STRING).setValue(user.year)
        
        //self.database.goOffline()
    }
    
    /**
        Loads a user from the database and creates a user object.
     
        - Parameters:
            - uid: the user's unique ID.
            - completion: the completion block that passes back the completed user.
     */
    func loadUser(_ uid: String, completion: @escaping (_ user: User) -> Void)
    {
        //self.database.goOnline()
        
        //As with saving, create references to the nodes we want to retrieve data from.
        let usersRef = self.database.reference().child(USERS_REF_STRING)
        let userRef = usersRef.child(uid)

        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let fname = value![FNAME_REF_STRING] as? String ?? ""
            let lname = snapshot.value(forKey: LNAME_REF_STRING) as! String
            let org = snapshot.value(forKey: ORG_REF_STRING) as! String
            let email = snapshot.value(forKey: EMAIL_REF_STRING) as! String
            let year = snapshot.hasChild(USER_YEAR_REF_STRING) ? snapshot.value(forKey: USER_YEAR_REF_STRING) as! Int : 0
            let coachEmail = snapshot.hasChild(COACH_EMAIL_REF_STRING) ? snapshot.value(forKey: COACH_EMAIL_REF_STRING) as! String : ""
            
            //convert start date to string
            let startDateString = snapshot.value(forKey: STARTDATE_REF_STRING)
            let dateFormatter = DateFormatter( )
            dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
            guard let startDate = dateFormatter.date(from: startDateString as! String) else
            {
                return
            }
            let user = User(fname: fname, lname: lname, org: org, email: email, uid: uid, startDate: startDate, coachEmail: coachEmail, year: year)

            completion(user)
        })
        //self.database.goOffline()
    }
    
    /**
        Removes a user's information from the database.
     
        - Parameters:
            - user: the user to remove.
     */
    func removeUser(_ user: User)
    {
        //self.database.goOnline()
        
        let ref = self.database.reference()
        let userRef = ref.child(USERS_REF_STRING).child(user.uid)
        userRef.removeValue()
        let dreamRef = ref.child(DREAMS_REF_STRING).child(user.uid)
        dreamRef.removeValue()
        let mgRef = ref.child(MONTHLYGOALS_REF_STRING).child(user.uid)
        mgRef.removeValue()
        let wgRef = ref.child(WEEKLYGOALS_REF_STRING).child(user.uid)
        wgRef.removeValue()
        let valuesRef = ref.child(VALUES_REF_STRING).child(user.uid)
        valuesRef.removeValue()
        let summariesRef = ref.child(SUMMARIES_REF_STRING).child(user.uid)
        summariesRef.removeValue()
        
        //self.database.goOffline()
    }
    
    
    // MARK: - Goal Methods
    /**
        Saves a goal to the database.
    
        - Parameters:
            - uid: the user ID of the user the goal belongs to.
            - goal: the goal being saved.
            - summaryGoal: whether the goal is part of a summary (removes UID child ref).
            - summaryDate: date of the summary for summary goals.
    */
    func saveGoal(_ uid: String, goal: Goal, summaryGoal: Bool = false, summaryDate: String = "")
    {
        //self.database.goOnline()
        
        var goalType = ""
        if goal is WeeklyGoal
        {
            goalType = WEEKLYGOALS_REF_STRING
        }
        else if goal is MonthlyGoal
        {
            goalType = MONTHLYGOALS_REF_STRING
        }
        
        var goalRef = self.database.reference().child(goalType).child(uid).child(goal.gid)
        //If the goal is part of a summary, we don't the need the UID child reference.
        if summaryGoal
        {
            goalRef = self.database.reference().child(SUMMARIES_REF_STRING).child(uid).child(summaryDate).child(goalType).child(goal.gid)
        }
        goalRef.child(GOALTEXT_REF_STRING).setValue(goal.goalText)
        goalRef.child(KLA_REF_STRING).setValue(goal.kla)
        goalRef.child(COMPLETE_REF_STRING).setValue(goal.complete)
        goalRef.child(KICKIT_REF_STRING).setValue(goal.kickItText)
        
        //convert deadline from NSDate to String
        let dateFormatter = DateFormatter( )
        if goal is WeeklyGoal
        {
            dateFormatter.dateFormat = DAY_MONTH_YEAR_FORMAT_STRING
        }
        else if goal is MonthlyGoal
        {
            dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
        }
        goalRef.child(DEADLINE_REF_STRING).setValue(dateFormatter.string(from: goal.deadline as Date) )
      
        //self.database.goOffline()
    }
    
    /**
        Loads a user's weekly goals from the database.
     
        - Parameters:
            - uid: user ID that the goals belong.
            - summary: the summary that the goals belong to. Nil if not part of a summary.
            - completion: the block that passes back the fetched goals.
     */
    func loadWeeklyGoals(_ uid: String, summary: MonthlySummary? = nil, completion: (( _ weeklyGoals: [WeeklyGoal] ) -> Void)?)
    {
        //self.database.goOnline()
        
        var weeklyGoals = [WeeklyGoal]()
        var weeklyGoalsRef = self.database.reference().child(WEEKLYGOALS_REF_STRING).child(uid)
        if summary != nil
        {
            let dateFormatter = DateFormatter( )
            dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
            let dateAsString = dateFormatter.string(from: summary!.date as Date)
            weeklyGoalsRef = self.database.reference().child(SUMMARIES_REF_STRING).child(uid).child(dateAsString).child(WEEKLYGOALS_REF_STRING)
        }
        weeklyGoalsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists()
            {
                for goalSnapshot in snapshot.children
                {
                    let goalText = (goalSnapshot as AnyObject).value(forKey: GOALTEXT_REF_STRING) as! String
                    let keyLifeArea = (goalSnapshot as AnyObject).value(forKey: KLA_REF_STRING) as! String
                    let complete = (goalSnapshot as AnyObject).value(forKey: COMPLETE_REF_STRING) as! Bool
                    let kickItText = (goalSnapshot as AnyObject).value(forKey: KICKIT_REF_STRING) as! String
                    let deadline = (goalSnapshot as AnyObject).value(forKey: DEADLINE_REF_STRING) as! String
                    let weeklyGoalID = String((goalSnapshot as AnyObject).key)
                    let weeklyGoal = WeeklyGoal(goalText: goalText, kla: keyLifeArea, deadline: deadline, gid: weeklyGoalID!, complete: complete, kickItText: kickItText)
                    weeklyGoals.append(weeklyGoal)
                }
                if summary != nil
                {
                    summary?.weeklyGoals = weeklyGoals
                    return
                }
                completion!( weeklyGoals )
                
            }
            else
            {
                if summary != nil
                {
                    return
                }
                completion!( weeklyGoals )
                
            }
        })
        
        //self.database.goOffline()
    }
    
    /**
        Loads a user's monthly goals from the database.
     
        - Parameters:
            - uid: user ID that the goals belong.
            - summary: the summary the goals belong to. Nil if goals are not part of a summary.
            - completion: the block that passes back the fetched goals.
     */
    func loadMonthlyGoals(_ uid: String, summary: MonthlySummary? = nil, completion: (( _ monthlyGoals: [MonthlyGoal] ) -> Void)?)
    {
        //self.database.goOnline()
        
        var monthlyGoals = [MonthlyGoal]( )
        var monthlyGoalsRef = self.database.reference().child(MONTHLYGOALS_REF_STRING).child(uid)
        if summary != nil
        {
            let dateFormatter = DateFormatter( )
            dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
            let dateAsString = dateFormatter.string(from: summary!.date as Date)
            monthlyGoalsRef = self.database.reference().child(SUMMARIES_REF_STRING).child(uid).child(dateAsString).child(MONTHLYGOALS_REF_STRING)
        }
        monthlyGoalsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists()
            {
                for goalSnapshot in snapshot.children
                {
                    let goalText = (goalSnapshot as AnyObject).value(forKey: GOALTEXT_REF_STRING) as! String
                    let keyLifeArea = (goalSnapshot as AnyObject).value(forKey: KLA_REF_STRING) as! String
                    let complete = (goalSnapshot as AnyObject).value(forKey: COMPLETE_REF_STRING) as! Bool
                    let kickItText = (goalSnapshot as AnyObject).value(forKey: KICKIT_REF_STRING) as! String
                    let deadline = (goalSnapshot as AnyObject).value(forKey: DEADLINE_REF_STRING) as! String
                    let gid = String((goalSnapshot as AnyObject).key)
                    let monthlyGoal = MonthlyGoal(goalText: goalText, kla: keyLifeArea, deadline: deadline, gid: gid!, complete: complete, kickItText: kickItText)
                    monthlyGoals.append(monthlyGoal)
                }
                if summary != nil
                {
                    summary?.monthlyGoals = monthlyGoals
                    return
                }
                completion!( monthlyGoals )
                
            }
            else
            {
                if summary != nil
                {
                    return
                }
                completion!( monthlyGoals )
                
            }
        })
        
        //self.database.goOffline()
    }
    
    
    /**
        Removes a user's weekly goal from the database.
     
        - Parameters:
            - uid: ID of user that owns the weekly goal.
            - goal: the goal being removed
     */
    func removeGoal(_ uid: String, goal: Goal)
    {
        //self.database.goOnline()
        
        var goalsRef : FIRDatabaseReference
        if goal is WeeklyGoal
        {
            goalsRef = self.database.reference().child(WEEKLYGOALS_REF_STRING)
        }
        else
        {
            goalsRef = self.database.reference().child(MONTHLYGOALS_REF_STRING)
        }
        
        let goalRef = goalsRef.child(uid).child(goal.gid)
        goalRef.removeValue( )
        
        //self.database.goOffline()
    }
    
    /**
        Removes all of a user's goals (weekly and monthly) from the database.
        
        - Parameters:
            - uid: ID of the user whose goals are being removed.
    */
    func removeAllGoals( _ uid: String )
    {
        //self.database.goOnline()
        
        self.database.reference().child(WEEKLYGOALS_REF_STRING).child(uid).removeValue()
        self.database.reference().child(MONTHLYGOALS_REF_STRING).child(uid).removeValue()
        
        //self.database.goOffline()
    }
    
    // MARK: - Dream methods
    
    /**
        Saves a dream to the database.
     
        - Parameters:
            - uid: the user ID of the user the goal belongs to.
            - dream: the dream being saved.
     */
    func saveDream(_ uid: String, dream: Dream)
    {
        //self.database.goOnline()
        
        let dreamsRef = self.database.reference().child(DREAMS_REF_STRING)
        
        let dreamRef = dreamsRef.child(uid).child(dream.did)
        dreamRef.child(DREAMTEXT_REF_STRING).setValue(dream.dreamDesc)
        
        //convert storage NSURL to string
        let urlString = dream.imageURL!.absoluteString
        dreamRef.child(DREAMURL_REF_STRING).setValue(urlString)
        
        //convert local NSURL to string
        let localURLString = dream.imageLocalURL!.absoluteString
        dreamRef.child(DREAMLOCALURL_REF_STRING).setValue(localURLString)
        
        //self.database.goOffline()
    }
    
    /**
        Loads a user's dreams from the database.
     
        - Parameters:
            - uid: user ID that the goals belong.
            - completion: the block that passes back the fetched goals.
     */
    func loadDreams(_ uid: String, completion: @escaping ( _ dreams: [Dream] ) -> Void)
    {
        //self.database.goOnline()
        
        var dreams = [Dream]()
        let dreamsRef = self.database.reference().child(DREAMS_REF_STRING).child(uid)
        dreamsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists()
            {
                for dreamSnapshot in snapshot.children
                {
                    let dreamText = (dreamSnapshot as AnyObject).value(forKey: DREAMTEXT_REF_STRING) as! String
                    let dreamURLString = (dreamSnapshot as AnyObject).value(forKey: DREAMURL_REF_STRING) as! String
                    let dreamURL = URL(string: dreamURLString)
                    let dreamLocalURLString = (dreamSnapshot as AnyObject).value(forKey: DREAMLOCALURL_REF_STRING) as! String
                    let dreamLocalURL = URL(string: dreamLocalURLString)
                    let did = String((dreamSnapshot as AnyObject).key)
                    let dream = Dream(dreamDesc: dreamText, imageURL: dreamURL, imageLocalURL: dreamLocalURL, did: did!)
                    dreams.append(dream)
                }
                completion( dreams )
                
            }
            else
            {
                completion( dreams )
                
            }
        })
        
        //self.database.goOffline()
    }
    
    /**
        Removes a user's dream from the database.
     
        - Parameters:
            - uid: ID of user that owns the weekly goal.
            - dream: the dream being removed
     */
    func removeDream( _ uid: String, dream: Dream )
    {
        //self.database.goOnline()
        self.database.reference().child(DREAMS_REF_STRING).child(uid).child(dream.did).removeValue()
        //self.database.goOffline()
    }
    
    
    // MARK: - MyValues methods
    
    /**
        Saves user's values to the database.
     
        - Parameters:
            - user: user whose values are being saved
     */
    func saveValues( _ user: User )
    {
        //self.database.goOnline()
        
        let ref = self.database.reference().child(VALUES_REF_STRING).child(user.uid)
       
        ref.child(KLA_FAMILY).setValue(user.values[KLA_FAMILY])
        ref.child(KLA_FINANCIAL).setValue(user.values[KLA_FINANCIAL])
        ref.child(KLA_PERSONALDEV).setValue(user.values[KLA_PERSONALDEV])
        ref.child(KLA_FRIENDSSOCIAL).setValue(user.values[KLA_FRIENDSSOCIAL])
        ref.child(KLA_HEALTHFITNESS).setValue(user.values[KLA_HEALTHFITNESS])
        ref.child(KLA_WORKBUSINESS).setValue(user.values[KLA_WORKBUSINESS])
        ref.child(KLA_EMOSPIRITUAL).setValue(user.values[KLA_EMOSPIRITUAL])
        ref.child(KLA_PARTNER).setValue(user.values[KLA_PARTNER])
        
        //self.database.goOffline()
    }
    
    /**
        Loads a user's values from the database.
     
        - Parameters:
            - uid: user ID that the goals belong.
            - completion: the block that passes back the fetched goals.
     */
    func loadValues(_ uid: String, completion: @escaping ( _ values: [String:String] ) -> Void)
    {
        //self.database.goOnline()
        
        var values = [ KLA_FAMILY: "", KLA_WORKBUSINESS: "", KLA_PERSONALDEV: "", KLA_FINANCIAL: "",
                       KLA_FRIENDSSOCIAL: "", KLA_HEALTHFITNESS: "", KLA_EMOSPIRITUAL: "", KLA_PARTNER: "" ]
        let ref = self.database.reference().child(VALUES_REF_STRING).child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists()
            {
                values[KLA_FAMILY] = snapshot.value(forKey: KLA_FAMILY) as? String
                values[KLA_FINANCIAL] = snapshot.value(forKey: KLA_FINANCIAL) as? String
                values[KLA_PERSONALDEV] = snapshot.value(forKey: KLA_PERSONALDEV) as? String
                values[KLA_FRIENDSSOCIAL] = snapshot.value(forKey: KLA_FRIENDSSOCIAL) as? String
                values[KLA_HEALTHFITNESS] = snapshot.value(forKey: KLA_HEALTHFITNESS) as? String
                values[KLA_WORKBUSINESS] = snapshot.value(forKey: KLA_WORKBUSINESS) as? String
                values[KLA_PARTNER] = snapshot.value(forKey: KLA_PARTNER) as? String
                values[KLA_EMOSPIRITUAL] = snapshot.value(forKey: KLA_EMOSPIRITUAL) as? String

                completion( values )
                
            }
            else
            {
                completion( values )
            }
        })
        
        //self.database.goOffline()
    }
    
    
    // MARK: - Monthly summary methods
    
    /**
        Saves user's initial summary ("current reality").
 
        - Parameters:
            - user: the user whose summary is being saved.
            - summary: the summary to save.
    */
    func saveCurrentRealitySummary(_ user: User, summary: CurrentRealitySummary)
    {
        //self.database.goOnline()
        
        let ref = self.database.reference().child(SUMMARIES_REF_STRING).child(user.uid).child(CURRENT_REALITY_SUMMARY_REF_STRING)
        
        for (kla,reason) in summary.klaReasons
        {
            ref.child("\(kla)Reason").setValue(reason)
        }
        for (kla,rating) in summary.klaRatings
        {
            ref.child(kla).setValue(String(rating))
        }
        
        //self.database.goOffline()
    }
    
    /**
        Save's a users 12 month summary to the database.
        
        - Parameters:
            - user: the user whose summary is being saved.
            - summary: the summary to save.
    */
    func saveYearlySummary(_ user: User, summary: YearlySummary )
    {
        //self.database.goOnline()
        
        let ref = self.database.reference().child(SUMMARIES_REF_STRING).child(user.uid).child(YEARLY_REVIEW_REF_STRING).child(String(user.year))
        ref.child(YEARLY_REVIEW_OBS_REF_STRING).setValue(summary.observedAboutPerformanceText)
        ref.child(YEARLY_REVIEW_CHA_REF_STRING).setValue(summary.changedMyPerformanceText)
        ref.child(YEARLY_REVIEW_DIFF_REF_STRING).setValue(summary.reasonsForDifferencesText)
        ref.child(SUMMARY_REVIEWED_REF_STRING).setValue(summary.reviewed)
        
        //self.database.goOffline()
    }
    
    /**
        Save's a user's monthly summary to the database.
        
        - Parameters:
            - user: the user whose summary is being saved.
            - summary: the summary to save.
    */
    func saveSummary(_ user: User, summary: MonthlySummary)
    {
        //self.database.goOnline()
        
        let dateFormatter = DateFormatter( )
        dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
        let dateAsString = dateFormatter.string(from: summary.date as Date)
        let ref = self.database.reference().child(SUMMARIES_REF_STRING).child(user.uid).child(dateAsString)
        
        ref.child(SUMMARY_WIW_REF_STRING).setValue(summary.whatIsWorking)
        ref.child(SUMMARY_WINOTW_REF_STRING).setValue(summary.whatIsNotWorking)
        ref.child(SUMMARY_WHII_REF_STRING).setValue(summary.whatHaveIImproved)
        ref.child(SUMMARY_DIHTC_REF_STRING).setValue(summary.doIHaveToChange)
        ref.child(SUMMARY_REVIEWED_REF_STRING).setValue(summary.reviewed)
        ref.child(SUMMARY_SENT_REF_STRING).setValue(summary.sent)
        
        //save weekly goals
        if !summary.weeklyGoals.isEmpty
        {
            for goal in summary.weeklyGoals
            {
                self.saveGoal(user.uid, goal: goal, summaryGoal: true, summaryDate: dateAsString )
            }
        }
        
        //save monthly goals
        if !summary.monthlyGoals.isEmpty
        {
            for goal in summary.monthlyGoals
            {
                self.saveGoal(user.uid, goal: goal, summaryGoal: true, summaryDate: dateAsString )
            }
        }
        
        //save ratings
        for (key,val) in summary.klaRatings
        {
            ref.child(key).setValue(String(val))
        }
        
        //self.database.goOffline()
    }
    
    /**
        Loads a user's initial summary ("current reality") from the database.
        
        - Parameters: 
            - user: the user whose summary is being loaded.
            - completion: completion block for passing back the loaded summary.
    */
    func loadCurrentRealitySummary(_ user: User, completion: @escaping ( _ summary: CurrentRealitySummary ) -> Void)
    {
        //self.database.goOnline()
        
        let ref = self.database.reference().child(SUMMARIES_REF_STRING).child(user.uid).child(CURRENT_REALITY_SUMMARY_REF_STRING)
        let summary = CurrentRealitySummary( )
        ref.observe(.value, with: { (snapshot) in
            if snapshot.exists()
            {
                //get both ratings and reasons
                for (kla,_) in summary.klaRatings
                {
                    summary.klaRatings[kla] = Double(snapshot.value(forKey: kla) as! String)
                    summary.klaReasons[kla] = snapshot.value(forKey: "\(kla)Reason") as? String
                }
            }
            completion( summary )
        })
        
        //self.database.goOffline()
    }
    
    /**
        Loads a user's 12 month summary from the database.
        
        - Parameters:
            - user: the user whose summary is being loaded.
            - completion: completion block for passing back the loaded summary.
    */
    func loadYearlySummaries(_ user: User, completion: @escaping ( _ summaries: [Int:YearlySummary?] ) -> Void)
    {
        //self.database.goOnline()
        
        let ref = self.database.reference().child(SUMMARIES_REF_STRING).child(user.uid).child(YEARLY_REVIEW_REF_STRING)
        var summaries = [Int:YearlySummary?]()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists()
            {
                for s in snapshot.children
                {
                    let summary = YearlySummary()
                    summary.reasonsForDifferencesText = (s as AnyObject).value(forKey: YEARLY_REVIEW_DIFF_REF_STRING) as! String
                    summary.changedMyPerformanceText = (s as AnyObject).value(forKey: YEARLY_REVIEW_CHA_REF_STRING) as! String
                    summary.observedAboutPerformanceText = (s as AnyObject).value(forKey: YEARLY_REVIEW_OBS_REF_STRING) as! String
                    summary.reviewed = (s as AnyObject).value(forKey: SUMMARY_REVIEWED_REF_STRING) as! Bool
                    summaries[Int((s as AnyObject).key)!] = summary
                    print("DS - loadYearlySummaries(): fetched summary for year \(Int((s as AnyObject).key)!), reviewed = \(summary.reviewed), changes = \(summary.changedMyPerformanceText)")
                }
            }
                completion(summaries)
        })
        
        //self.database.goOffline()
    }
    
    /**
        Loads a user's monthly summaries from the database.
        
        - Parameters:
            - user: the user whose summaries are being loaded.
            - completion: block for passing back the loaded summaries.
    */
    func loadSummaries(_ user: User, completion: @escaping ( _ summaries: [String:MonthlySummary?] ) -> Void)
    {
        //self.database.goOnline()
        
        var monthlySummaries = [String: MonthlySummary?]( )
        let ref = self.database.reference().child(SUMMARIES_REF_STRING).child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists()
            {
                for s in snapshot.children
                {
                    if String((s as AnyObject).key) == "initial" || String((s as AnyObject).key) == "yearly"
                    {
                        continue
                    }
                    
                    let dateString = (String((s as AnyObject).key))
                    let dateFormatter = DateFormatter( )
                    //change to MONTH_YEAR_FORMAT_STRING if we want all summaries from all time
                    dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
                    
                    let date = dateFormatter.date(from: dateString!)
                    let summary = MonthlySummary(date: date!)
                    summary.whatIsWorking = (s as AnyObject).value(forKey: SUMMARY_WIW_REF_STRING) as! String
                    summary.whatIsNotWorking = (s as AnyObject).value(forKey: SUMMARY_WINOTW_REF_STRING) as! String
                    summary.whatHaveIImproved = (s as AnyObject).value(forKey: SUMMARY_WHII_REF_STRING) as! String
                    summary.doIHaveToChange = (s as AnyObject).value(forKey: SUMMARY_DIHTC_REF_STRING) as! String
                    summary.reviewed = (s as AnyObject).value(forKey: SUMMARY_REVIEWED_REF_STRING) as! Bool
                    summary.sent = (s as AnyObject).hasChild(SUMMARY_SENT_REF_STRING) ? (s as AnyObject).value(forKey: SUMMARY_SENT_REF_STRING) as! Bool : false
                    
                    for (kla,_) in summary.klaRatings
                    {
                        summary.klaRatings[kla] = Double((s as AnyObject).value(forKey: kla) as! String)
                    }
                    
                    if (s as AnyObject).hasChild(WEEKLYGOALS_REF_STRING)
                    {
                        self.loadWeeklyGoals(user.uid, summary: summary, completion: nil)
                    }
                    
                    if (s as AnyObject).hasChild(MONTHLYGOALS_REF_STRING)
                    {
                        self.loadMonthlyGoals(user.uid, summary: summary, completion: nil)
                    }
                    monthlySummaries[dateString!] = summary
                    
                }
                completion( monthlySummaries )
                return
            }
            else
            {
                completion( monthlySummaries )
                return
            }
        })
        
        //self.database.goOffline()
    }
    
    /**
        Removes all of a user's summaries from the database.
        
        - Parameters: 
            - user: the user whose summaries are being removed.
    */
    func removeAllMonthlySummaries(_ user: User)
    {
        //self.database.goOnline()
        self.database.reference().child(SUMMARIES_REF_STRING).child(user.uid).removeValue()
        //self.database.goOffline()
    }
}
