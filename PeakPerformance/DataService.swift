//
//  DataService.swift
//  PeakPerformance
//
//  Created by Bren on 18/07/2016.
//  Copyright © 2016 Bren. All rights reserved.
//

import Foundation
import Firebase


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
    func saveUser(user: User)
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
        let dateFormatter = NSDateFormatter( )
        dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
        let startDateString = dateFormatter.stringFromDate(user.startDate)
        
        userRef.child(STARTDATE_REF_STRING).setValue(startDateString)
        
        //self.database.goOffline()
    }
    
    /**
        Save's user's coach email to database.
        
        - Parameters:
            - user: user whose coach email to save.
    */
    func saveCoachEmail(user: User)
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
    func saveUserYear(user: User)
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
    func loadUser(uid: String, completion: (user: User) -> Void)
    {
        //self.database.goOnline()
        
        //As with saving, create references to the nodes we want to retrieve data from.
        let usersRef = self.database.reference().child(USERS_REF_STRING)
        let userRef = usersRef.child(uid)

        userRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let fname = snapshot.value![FNAME_REF_STRING] as! String
            let lname = snapshot.value![LNAME_REF_STRING] as! String
            let org = snapshot.value![ORG_REF_STRING] as! String
            let email = snapshot.value![EMAIL_REF_STRING] as! String
            let year = snapshot.hasChild(USER_YEAR_REF_STRING) ? snapshot.value![USER_YEAR_REF_STRING] as! Int : 0
            let coachEmail = snapshot.hasChild(COACH_EMAIL_REF_STRING) ? snapshot.value![COACH_EMAIL_REF_STRING] as! String : ""
            
            //convert start date to string
            let startDateString = snapshot.value![STARTDATE_REF_STRING]
            let dateFormatter = NSDateFormatter( )
            dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
            guard let startDate = dateFormatter.dateFromString(startDateString as! String) else
            {
                print("DS: could not convert user start date") //DEBUG
                return
            }
        
            let user = User(fname: fname, lname: lname, org: org, email: email, uid: uid, startDate: startDate, coachEmail: coachEmail, year: year)

            completion( user: user )
        })
        //self.database.goOffline()
    }
    
    /**
        Removes a user's information from the database.
     
        - Parameters:
            - user: the user to remove.
     */
    func removeUser(user: User)
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
    func saveGoal(uid: String, goal: Goal, summaryGoal: Bool = false, summaryDate: String = "")
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
        let dateFormatter = NSDateFormatter( )
        if goal is WeeklyGoal
        {
            dateFormatter.dateFormat = DAY_MONTH_YEAR_FORMAT_STRING
        }
        else if goal is MonthlyGoal
        {
            dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
        }
        goalRef.child(DEADLINE_REF_STRING).setValue(dateFormatter.stringFromDate(goal.deadline) )
      
        //self.database.goOffline()
    }
    
    /**
        Loads a user's weekly goals from the database.
     
        - Parameters:
            - uid: user ID that the goals belong.
            - summary: the summary that the goals belong to. Nil if not part of a summary.
            - completion: the block that passes back the fetched goals.
     */
    func loadWeeklyGoals(uid: String, summary: MonthlySummary? = nil, completion: (( weeklyGoals: [WeeklyGoal] ) -> Void)?)
    {
        //self.database.goOnline()
        
        var weeklyGoals = [WeeklyGoal]()
        var weeklyGoalsRef = self.database.reference().child(WEEKLYGOALS_REF_STRING).child(uid)
        if summary != nil
        {
            let dateFormatter = NSDateFormatter( )
            dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
            let dateAsString = dateFormatter.stringFromDate(summary!.date)
            weeklyGoalsRef = self.database.reference().child(SUMMARIES_REF_STRING).child(uid).child(dateAsString).child(WEEKLYGOALS_REF_STRING)
        }
        weeklyGoalsRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.exists()
            {
                for goalSnapshot in snapshot.children
                {
                    let goalText = goalSnapshot.value![GOALTEXT_REF_STRING] as! String
                    let keyLifeArea = goalSnapshot.value![KLA_REF_STRING] as! String
                    let complete = goalSnapshot.value![COMPLETE_REF_STRING] as! Bool
                    let kickItText = goalSnapshot.value![KICKIT_REF_STRING] as! String
                    let deadline = goalSnapshot.value![DEADLINE_REF_STRING] as! String
                    let weeklyGoalID = String(goalSnapshot.key)
                    let weeklyGoal = WeeklyGoal(goalText: goalText, kla: keyLifeArea, deadline: deadline, gid: weeklyGoalID, complete: complete, kickItText: kickItText)
                    weeklyGoals.append(weeklyGoal)
                }
                if summary != nil
                {
                    summary?.weeklyGoals = weeklyGoals
                    return
                }
                completion!( weeklyGoals: weeklyGoals )
                
            }
            else
            {
                if summary != nil
                {
                    return
                }
                completion!( weeklyGoals: weeklyGoals )
                
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
    func loadMonthlyGoals(uid: String, summary: MonthlySummary? = nil, completion: (( monthlyGoals: [MonthlyGoal] ) -> Void)?)
    {
        //self.database.goOnline()
        
        var monthlyGoals = [MonthlyGoal]( )
        var monthlyGoalsRef = self.database.reference().child(MONTHLYGOALS_REF_STRING).child(uid)
        if summary != nil
        {
            let dateFormatter = NSDateFormatter( )
            dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
            let dateAsString = dateFormatter.stringFromDate(summary!.date)
            monthlyGoalsRef = self.database.reference().child(SUMMARIES_REF_STRING).child(uid).child(dateAsString).child(MONTHLYGOALS_REF_STRING)
        }
        monthlyGoalsRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.exists()
            {
                for goalSnapshot in snapshot.children
                {
                    let goalText = goalSnapshot.value![GOALTEXT_REF_STRING] as! String
                    let keyLifeArea = goalSnapshot.value![KLA_REF_STRING] as! String
                    let complete = goalSnapshot.value![COMPLETE_REF_STRING] as! Bool
                    let kickItText = goalSnapshot.value![KICKIT_REF_STRING] as! String
                    let deadline = goalSnapshot.value![DEADLINE_REF_STRING] as! String
                    let gid = String(goalSnapshot.key)
                    let monthlyGoal = MonthlyGoal(goalText: goalText, kla: keyLifeArea, deadline: deadline, gid: gid, complete: complete, kickItText: kickItText)
                    monthlyGoals.append(monthlyGoal)
                }
                if summary != nil
                {
                    summary?.monthlyGoals = monthlyGoals
                    return
                }
                completion!( monthlyGoals: monthlyGoals )
                
            }
            else
            {
                if summary != nil
                {
                    return
                }
                completion!( monthlyGoals: monthlyGoals )
                
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
    func removeGoal(uid: String, goal: Goal)
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
    func removeAllGoals( uid: String )
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
    func saveDream(uid: String, dream: Dream)
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
    func loadDreams(uid: String, completion: ( dreams: [Dream] ) -> Void)
    {
        //self.database.goOnline()
        
        var dreams = [Dream]()
        let dreamsRef = self.database.reference().child(DREAMS_REF_STRING).child(uid)
        dreamsRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.exists()
            {
                for dreamSnapshot in snapshot.children
                {
                    let dreamText = dreamSnapshot.value![DREAMTEXT_REF_STRING] as! String
                    let dreamURLString = dreamSnapshot.value![DREAMURL_REF_STRING] as! String
                    let dreamURL = NSURL(string: dreamURLString)
                    let dreamLocalURLString = dreamSnapshot.value![DREAMLOCALURL_REF_STRING] as! String
                    let dreamLocalURL = NSURL(string: dreamLocalURLString)
                    let did = String(dreamSnapshot.key)
                    let dream = Dream(dreamDesc: dreamText, imageURL: dreamURL, imageLocalURL: dreamLocalURL, did: did)
                    dreams.append(dream)
                }
                completion( dreams: dreams )
                
            }
            else
            {
                completion( dreams: dreams )
                
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
    func removeDream( uid: String, dream: Dream )
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
    func saveValues( user: User )
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
    func loadValues(uid: String, completion: ( values: [String:String] ) -> Void)
    {
        //self.database.goOnline()
        
        var values = [ KLA_FAMILY: "", KLA_WORKBUSINESS: "", KLA_PERSONALDEV: "", KLA_FINANCIAL: "",
                       KLA_FRIENDSSOCIAL: "", KLA_HEALTHFITNESS: "", KLA_EMOSPIRITUAL: "", KLA_PARTNER: "" ]
        let ref = self.database.reference().child(VALUES_REF_STRING).child(uid)
        ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.exists()
            {
                values[KLA_FAMILY] = snapshot.value![KLA_FAMILY] as? String
                values[KLA_FINANCIAL] = snapshot.value![KLA_FINANCIAL] as? String
                values[KLA_PERSONALDEV] = snapshot.value![KLA_PERSONALDEV] as? String
                values[KLA_FRIENDSSOCIAL] = snapshot.value![KLA_FRIENDSSOCIAL] as? String
                values[KLA_HEALTHFITNESS] = snapshot.value![KLA_HEALTHFITNESS] as? String
                values[KLA_WORKBUSINESS] = snapshot.value![KLA_WORKBUSINESS] as? String
                values[KLA_PARTNER] = snapshot.value![KLA_PARTNER] as? String
                values[KLA_EMOSPIRITUAL] = snapshot.value![KLA_EMOSPIRITUAL] as? String

                completion( values: values )
                
            }
            else
            {
                completion( values: values )
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
    func saveCurrentRealitySummary(user: User, summary: CurrentRealitySummary)
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
    func saveYearlySummary(user: User, summary: YearlySummary )
    {
        //self.database.goOnline()
        
        let ref = self.database.reference().child(SUMMARIES_REF_STRING).child(user.uid).child(YEARLY_REVIEW_REF_STRING)
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
    func saveSummary(user: User, summary: MonthlySummary)
    {
        //self.database.goOnline()
        
        let dateFormatter = NSDateFormatter( )
        dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
        let dateAsString = dateFormatter.stringFromDate(summary.date)
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
    func loadCurrentRealitySummary(user: User, completion: ( summary: CurrentRealitySummary ) -> Void)
    {
        //self.database.goOnline()
        
        let ref = self.database.reference().child(SUMMARIES_REF_STRING).child(user.uid).child(CURRENT_REALITY_SUMMARY_REF_STRING)
        let summary = CurrentRealitySummary( )
        ref.observeEventType(.Value, withBlock: { (snapshot) in
            if snapshot.exists()
            {
                //get both ratings and reasons
                for (kla,_) in summary.klaRatings
                {
                    summary.klaRatings[kla] = Double(snapshot.value![kla] as! String)
                    summary.klaReasons[kla] = snapshot.value!["\(kla)Reason"] as? String
                }
            }
            completion( summary: summary )
        })
        
        //self.database.goOffline()
    }
    
    /**
        Loads a user's 12 month summary from the database.
        
        - Parameters:
            - user: the user whose summary is being loaded.
            - completion: completion block for passing back the loaded summary.
    */
    func loadYearlySummary(user: User, completion: ( summary: YearlySummary ) -> Void)
    {
        //self.database.goOnline()
        
        let ref = self.database.reference().child(SUMMARIES_REF_STRING).child(user.uid).child(YEARLY_REVIEW_REF_STRING)
        let summary = YearlySummary()
        ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.exists()
            {
                summary.reasonsForDifferencesText = snapshot.value![YEARLY_REVIEW_DIFF_REF_STRING] as! String
                summary.changedMyPerformanceText = snapshot.value![YEARLY_REVIEW_CHA_REF_STRING] as! String
                summary.observedAboutPerformanceText = snapshot.value![YEARLY_REVIEW_OBS_REF_STRING] as! String
            }
            completion( summary: summary )
        })
        
        //self.database.goOffline()
    }
    
    /**
        Loads a user's monthly summaries from the database.
        
        - Parameters:
            - user: the user whose summaries are being loaded.
            - completion: block for passing back the loaded summaries.
    */
    func loadSummaries(user: User, completion: ( summaries: [String:MonthlySummary?] ) -> Void)
    {
        //self.database.goOnline()
        
        var monthlySummaries = [String: MonthlySummary?]( )
        let ref = self.database.reference().child(SUMMARIES_REF_STRING).child(user.uid)
        ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.exists()
            {
                for s in snapshot.children
                {
                    if String(s.key) == "initial" || String(s.key) == "yearly"
                    {
                        continue
                    }
                    
                    let dateString = (String(s.key).componentsSeparatedByString(" "))[0]
                    print("DS: fetching summary for \(dateString)")
                    let dateFormatter = NSDateFormatter( )
                    //change to MONTH_YEAR_FORMAT_STRING if we want all summaries from all time
                    dateFormatter.dateFormat = MONTH_FORMAT_STRING
                    
                    let date = dateFormatter.dateFromString(dateString)
                    let summary = MonthlySummary(date: date!)
                    summary.whatIsWorking = s.value![SUMMARY_WIW_REF_STRING] as! String
                    summary.whatIsNotWorking = s.value![SUMMARY_WINOTW_REF_STRING] as! String
                    summary.whatHaveIImproved = s.value![SUMMARY_WHII_REF_STRING] as! String
                    summary.doIHaveToChange = s.value![SUMMARY_DIHTC_REF_STRING] as! String
                    summary.reviewed = s.value![SUMMARY_REVIEWED_REF_STRING] as! Bool
                    summary.sent = s.hasChild(SUMMARY_SENT_REF_STRING) ? s.value![SUMMARY_SENT_REF_STRING] as! Bool : false
                    
                    for (kla,_) in summary.klaRatings
                    {
                        summary.klaRatings[kla] = Double(s.value![kla] as! String)
                    }
                    
                    if s.hasChild(WEEKLYGOALS_REF_STRING)
                    {
                        self.loadWeeklyGoals(user.uid, summary: summary, completion: nil)
                    }
                    
                    if s.hasChild(MONTHLYGOALS_REF_STRING)
                    {
                        self.loadMonthlyGoals(user.uid, summary: summary, completion: nil)
                    }
                    monthlySummaries[dateString] = summary
                    
                }
                completion( summaries: monthlySummaries )
                return
            }
            else
            {
                completion( summaries: monthlySummaries )
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
    func removeAllMonthlySummaries(user: User)
    {
        //self.database.goOnline()
        self.database.reference().child(SUMMARIES_REF_STRING).child(user.uid).removeValue()
        //self.database.goOffline()
    }
}