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

//TODO: - load goals in summary using existing methods
//TODO: - fix summary reference (summaries->user->year->month)
//TODO: - currenty reality save/load
class DataService  //: SignUpDataService, LogInDataService
{
    // MARK: - User Methods
    
    /**
        Saves a user's details to the database.
        This method is used only when creating a user for the first time at sign up and only saves personal info.
        Depending on if we allow users to change their details, then this will also be used in that situation.

        - Parameters:
            - user: the user being saved.
    */
    static func saveUser(user: User)
    {
        
        //Create child references from FIRDatabase.database().reference() to define the nodes that data will be stored under.
        // E.g. "Base -> Users -> UserID"
        let userRef = FIRDatabase.database().reference().child(USERS_REF_STRING).child(user.uid)
        
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
        
        print("DS: user stored in database") //DEBUG
        
    }
    
    /**
     Loads a user from the database and creates a user object.
     
     - Parameters:
     - uid: the user's unique ID.
     - completion: the completion block that passes back the completed user.
     */
    static func loadUser( uid: String, completion: ( user: User ) -> Void )
    {
        
        //As with saving, create references to the nodes we want to retrieve data from.
        let usersRef = FIRDatabase.database().reference().child(USERS_REF_STRING)
        let userRef = usersRef.child(uid)

        userRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            print( "DS: fetching user" ) //DEBUG
            let fname = snapshot.value![FNAME_REF_STRING] as! String
            let lname = snapshot.value![LNAME_REF_STRING] as! String
            let org = snapshot.value![ORG_REF_STRING] as! String
            let email = snapshot.value![EMAIL_REF_STRING] as! String
            
            // TODO: - Temp code for test accounts created before start date implementation. Remove before release.
            if !snapshot.hasChild(STARTDATE_REF_STRING)
            {
                print("DS: no start date in database - getting one now...")
                let startDate = NSDate( )
                let user = User( fname: fname, lname: lname, org: org, email: email, uid: uid, startDate: startDate )
                
                //convert startDate to string
                let dateFormatter = NSDateFormatter( )
                dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
                let startDateString = dateFormatter.stringFromDate(user.startDate)
                userRef.child(STARTDATE_REF_STRING).setValue(startDateString)
                
                completion( user: user )
                return
            }
            
            let startDateString = snapshot.value![STARTDATE_REF_STRING]
            //convert startDateString to NSDate
            let dateFormatter = NSDateFormatter( )
            dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
            guard let startDate = dateFormatter.dateFromString(startDateString as! String) else
            {
                print("DS: could not convert user start date") //DEBUG
                return
            }
        
            let user = User( fname: fname, lname: lname, org: org, email: email, uid: uid, startDate: startDate )

            completion( user: user ) //passing the created and user and content IDs back using the completion block
            
            print( "DS: user \(user.email) fetched" ) //DEBUG
        })
    }
    
    
    // MARK: - Goal Methods
    /**
        Saves a goal to the database.
    
        - Parameters:
            - uid: the user ID of the user the goal belongs to.
            - goal: the goal being saved.
            - summaryGoal: whether the goal is part of a summary (removes UID child ref).
    */
    static func saveGoal( uid: String, goal: Goal, summaryGoal: Bool = false, summaryDate: String = "" )
    {
        print("DS: saving goal")
        var goalType = ""
        if goal is WeeklyGoal
        {
           // goalsRef = FIRDatabase.database().reference().child(WEEKLYGOALS_REF_STRING)
            goalType = WEEKLYGOALS_REF_STRING
        }
        else if goal is MonthlyGoal
        {
            //goalsRef = FIRDatabase.database().reference().child(MONTHLYGOALS_REF_STRING)
            goalType = MONTHLYGOALS_REF_STRING
        }
        
        var goalRef = FIRDatabase.database().reference().child(goalType).child(uid).child(goal.gid)
        //If the goal is part of a summary, we don't the need the UID child reference.
        if summaryGoal
        {
            goalRef = FIRDatabase.database().reference().child(SUMMARIES_REF_STRING).child(uid).child(summaryDate).child(goalType).child(goal.gid)
        }
        goalRef.child(GOALTEXT_REF_STRING).setValue(goal.goalText)
        goalRef.child(KLA_REF_STRING).setValue(goal.kla)
        goalRef.child(COMPLETE_REF_STRING).setValue(goal.complete)
        goalRef.child(KICKIT_REF_STRING).setValue(goal.kickItText)
        
        //converting deadline from NSDate to String
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
        print("DS: saved goal \(goal.gid) under gid" ) //DEBUG
    }
    
    /**
        Loads a user's weekly goals from the database.
     
        - Parameters:
            - uid: user ID that the goals belong.
            - completion: the block that passes back the fetched goals.
     */
    static func loadWeeklyGoals( uid: String, summary: MonthlySummary? = nil, completion: (( weeklyGoals: [WeeklyGoal] ) -> Void)? )
    {
        
        var weeklyGoals = [WeeklyGoal]()
        var weeklyGoalsRef = FIRDatabase.database().reference().child(WEEKLYGOALS_REF_STRING).child(uid)
        if summary != nil
        {
            let dateFormatter = NSDateFormatter( )
            dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
            let dateAsString = dateFormatter.stringFromDate(summary!.date)
            weeklyGoalsRef = FIRDatabase.database().reference().child(SUMMARIES_REF_STRING).child(uid).child(dateAsString).child(WEEKLYGOALS_REF_STRING)
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
                    print("DS: fetched weekly goals for summary")
                    summary?.weeklyGoals = weeklyGoals
                    return
                }
                print("DS: fetched weekly goals") //DEBUG
                completion!( weeklyGoals: weeklyGoals )
                
            }
            else
            {
                if summary != nil
                {
                    print("DS: no weekly goals for summary")
                    return
                }
                print("DS: no weekly goals to fetch") //DEBUG
                completion!( weeklyGoals: weeklyGoals )
                
            }
        })
    }
    
    /**
     Loads a user's monthly goals from the database.
     
     - Parameters:
     - uid: user ID that the goals belong.
     - completion: the block that passes back the fetched goals.
     */
    static func loadMonthlyGoals( uid: String, summary: MonthlySummary? = nil, completion: (( monthlyGoals: [MonthlyGoal] ) -> Void)? )
    {

        var monthlyGoals = [MonthlyGoal]( )
        var monthlyGoalsRef = FIRDatabase.database().reference().child(MONTHLYGOALS_REF_STRING).child(uid)
        if summary != nil
        {
            let dateFormatter = NSDateFormatter( )
            dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
            let dateAsString = dateFormatter.stringFromDate(summary!.date)
            monthlyGoalsRef = FIRDatabase.database().reference().child(SUMMARIES_REF_STRING).child(uid).child(dateAsString).child(MONTHLYGOALS_REF_STRING)
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
                    print("DS: fetched monthly goals for summary")
                    summary?.monthlyGoals = monthlyGoals
                    return
                }
                print("DS: fetched monthly goals") //DEBUG
                completion!( monthlyGoals: monthlyGoals )
                
            }
            else
            {
                if summary != nil
                {
                    print("DS: no monthly goals for summary")
                    return
                }
                print("DS: no monthly goals to fetch") //DEBUG
                completion!( monthlyGoals: monthlyGoals )
                
            }
        })
    }
    
    
    /**
        Removes a user's weekly goal from the database.
     
        - Parameters:
            - uid: ID of user that owns the weekly goal.
            - goal: the goal being removed
     */
    static func removeGoal( uid: String, goal: Goal )
    {
        var goalsRef = FIRDatabase.database().reference()
        if goal is WeeklyGoal
        {
            goalsRef = FIRDatabase.database().reference().child(WEEKLYGOALS_REF_STRING)
        }
        else
        {
            goalsRef = FIRDatabase.database().reference().child(MONTHLYGOALS_REF_STRING)
        }
        
        let goalRef = goalsRef.child(uid).child(goal.gid)
        goalRef.removeValue( )
    }
    
    // MARK: - Dream methods
    
    /**
     Saves a dream to the database.
     
     - Parameters:
     - uid: the user ID of the user the goal belongs to.
     - dream: the dream being saved.
     */
    static func saveDream( uid: String, dream: Dream )
    {
        let dreamsRef = FIRDatabase.database().reference().child(DREAMS_REF_STRING)
        
        let dreamRef = dreamsRef.child(uid).child(dream.did)
        dreamRef.child(DREAMTEXT_REF_STRING).setValue(dream.dreamDesc)
        
        //convert storage NSURL to string
        let urlString = dream.imageURL!.absoluteString
        dreamRef.child(DREAMURL_REF_STRING).setValue(urlString)
        
        //convert local NSURL to string
        let localURLString = dream.imageLocalURL!.absoluteString
        dreamRef.child(DREAMLOCALURL_REF_STRING).setValue(localURLString)
    }
    
    /**
     Loads a user's dreams from the database (what a strange thing).
     
     - Parameters:
     - uid: user ID that the goals belong.
     - completion: the block that passes back the fetched goals.
     */
    static func loadDreams( uid: String, completion: ( dreams: [Dream] ) -> Void )
    {
        
        var dreams = [Dream]( )
        let dreamsRef = FIRDatabase.database().reference().child(DREAMS_REF_STRING).child(uid)
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
                print("DS: fetched dreams") //DEBUG
                completion( dreams: dreams )
                
            }
            else
            {
                print("DS: no dreams to fetch") //DEBUG
                completion( dreams: dreams )
                
            }
        })
    }
    
    /**
     Removes a user's dream from the database.
     
     - Parameters:
     - uid: ID of user that owns the weekly goal.
     - dream: the dream being removed
     */
    static func removeDream( uid: String, dream: Dream )
    {
        FIRDatabase.database().reference().child(DREAMS_REF_STRING).child(uid).child(dream.did).removeValue()
    }
    
    
    // MARK: - MyValues methods
    
    /**
     Saves user's values to the database.
     
     - Parameters:
     - user: user whose values are being saved
     */
    static func saveValues( user: User )
    {
        let ref = FIRDatabase.database().reference().child(VALUES_REF_STRING).child(user.uid)
       
        ref.child(KLA_FAMILY).setValue(user.values[KLA_FAMILY])
        ref.child(KLA_FINANCIAL).setValue(user.values[KLA_FINANCIAL])
        ref.child(KLA_PERSONALDEV).setValue(user.values[KLA_PERSONALDEV])
        ref.child(KLA_FRIENDSSOCIAL).setValue(user.values[KLA_FRIENDSSOCIAL])
        ref.child(KLA_HEALTHFITNESS).setValue(user.values[KLA_HEALTHFITNESS])
        ref.child(KLA_WORKBUSINESS).setValue(user.values[KLA_WORKBUSINESS])
        ref.child(KLA_EMOSPIRITUAL).setValue(user.values[KLA_EMOSPIRITUAL])
        ref.child(KLA_PARTNER).setValue(user.values[KLA_PARTNER])
    }
    
    /**
     Loads a user's values from the database.
     
     - Parameters:
     - uid: user ID that the goals belong.
     - completion: the block that passes back the fetched goals.
     */
    static func loadValues( uid: String, completion: ( values: [String:String] ) -> Void )
    {
        
        var values = [ KLA_FAMILY: "", KLA_WORKBUSINESS: "", KLA_PERSONALDEV: "", KLA_FINANCIAL: "",
                       KLA_FRIENDSSOCIAL: "", KLA_HEALTHFITNESS: "", KLA_EMOSPIRITUAL: "", KLA_PARTNER: "" ]
        let ref = FIRDatabase.database().reference().child(VALUES_REF_STRING).child(uid)
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
                
                
                
                print("DS: fetched values") //DEBUG

                completion( values: values )
                
            }
            else
            {
                print("DS: no values fetch") //DEBUG
                completion( values: values )
            }
            
            
        })
    }
    
    
    // MARK: - Monthly summary methods
    static func saveCurrentRealitySummary( user: User, summary: CurrentRealitySummary )
    {
        let ref = FIRDatabase.database().reference().child(SUMMARIES_REF_STRING).child(user.uid).child(CURRENT_REALITY_SUMMARY_REF_STRING)
        
        for (kla,reason) in summary.klaReasons
        {
            ref.child("\(kla)Reason").setValue(reason)
        }
        for (kla,rating) in summary.klaRatings
        {
            ref.child(kla).setValue(String(rating))
        }
        
        print("DS: saved CR summary")
    }
    
    static func saveSummary( user: User, summary: MonthlySummary )
    {
        let dateFormatter = NSDateFormatter( )
        dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
        let dateAsString = dateFormatter.stringFromDate(summary.date)
        let ref = FIRDatabase.database().reference().child(SUMMARIES_REF_STRING).child(user.uid).child(dateAsString)
        
        ref.child(SUMMARY_WIW_REF_STRING).setValue(summary.whatIsWorking)
        ref.child(SUMMARY_WINOTW_REF_STRING).setValue(summary.whatIsNotWorking)
        ref.child(SUMMARY_WHII_REF_STRING).setValue(summary.whatHaveIImproved)
        ref.child(SUMMARY_DIHTC_REF_STRING).setValue(summary.doIHaveToChange)
        ref.child(SUMMARY_REVIEWED_REF_STRING).setValue(summary.reviewed)
        
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
        
        print("DS: saved summary for \(dateAsString)")
    }
    
    static func loadCurrentRealitySummary( user: User, completion: ( summary: CurrentRealitySummary ) -> Void )
    {
        let ref = FIRDatabase.database().reference().child(SUMMARIES_REF_STRING).child(user.uid).child(CURRENT_REALITY_SUMMARY_REF_STRING)
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
            
        })
    }
    
    static func loadSummaries( user: User, completion: ( summaries: [String:MonthlySummary?] ) -> Void )
    {
        var monthlySummaries: [String: MonthlySummary?] =  ["January": nil, "February": nil, "March": nil, "April": nil,
                                 "May": nil, "June": nil, "July": nil, "August": nil, "September": nil,
                                 "October": nil, "November": nil, "December": nil]
        let ref = FIRDatabase.database().reference().child(SUMMARIES_REF_STRING).child(user.uid)
        ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.exists()
            {
                for s in snapshot.children
                {
                    
                    let dateString = String(s.key)
                    print("DS: fetching summary for \(dateString)")
                    let dateFormatter = NSDateFormatter( )
                    dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
                    let date = dateFormatter.dateFromString(dateString)
                    let summary = MonthlySummary(date: date!)
                    summary.whatIsWorking = s.value![SUMMARY_WIW_REF_STRING] as! String
                    summary.whatIsNotWorking = s.value![SUMMARY_WINOTW_REF_STRING] as! String
                    summary.whatHaveIImproved = s.value![SUMMARY_WHII_REF_STRING] as! String
                    summary.doIHaveToChange = s.value![SUMMARY_DIHTC_REF_STRING] as! String
                    summary.reviewed = s.value![SUMMARY_REVIEWED_REF_STRING] as! Bool
                    
                    for (kla,_) in summary.klaRatings
                    {
                        summary.klaRatings[kla] = Double(s.value![kla] as! String)
                    }
                    
                    /*
                    summary.klaRatings[KLA_FAMILY] = Double(s.value![KLA_FAMILY] as! String)
                    summary.klaRatings[KLA_FAMILY] = Double(s.value![KLA_FAMILY] as! String)
                    summary.klaRatings[KLA_PARTNER] = Double(s.value![KLA_PARTNER] as! String)
                    summary.klaRatings[KLA_FINANCIAL] = Double(s.value![KLA_FINANCIAL] as! String)
                    summary.klaRatings[KLA_PERSONALDEV] = Double(s.value![KLA_PERSONALDEV] as! String)
                    summary.klaRatings[KLA_EMOSPIRITUAL] = Double(s.value![KLA_EMOSPIRITUAL] as! String)
                    summary.klaRatings[KLA_WORKBUSINESS] = Double(s.value![KLA_WORKBUSINESS] as! String)
                    summary.klaRatings[KLA_FRIENDSSOCIAL] = Double(s.value![KLA_FRIENDSSOCIAL] as! String)
                    summary.klaRatings[KLA_HEALTHFITNESS] = Double(s.value![KLA_HEALTHFITNESS] as! String)
                    */
                    
                    self.loadWeeklyGoals(user.uid, summary: summary, completion: nil)
                    
                    self.loadMonthlyGoals(user.uid, summary: summary, completion: nil)
                    
                    //dateFormatter.dateFormat = MONTH_FORMAT_STRING
                    //let monthAsString = dateFormatter.stringFromDate(date!)
                    let dateStringArray = dateString.componentsSeparatedByString(" ")
                    let monthAsString = String(dateStringArray[0])
                    print("DS: summary fetched for \(dateString)")
                    monthlySummaries[monthAsString] = summary
                }
                print("DS: summaries fetched")
                completion( summaries: monthlySummaries )
            }
            else
            {
                print("DS: no summaries to fetch")
                completion( summaries: monthlySummaries )
            }
            
        })
    }
    
    
    
}