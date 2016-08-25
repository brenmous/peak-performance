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

//TODO: Create constants for Firebase DB reference strings.
//TODO: Experiment with abstracting load/save methods for user content.
class DataService  //: SignUpDataService, LogInDataService
{
    // MARK: - Properties
    
    /// Base reference to the Firebase DB.
    let baseRef = FIRDatabase.database().reference()
    
    // MARK: - User Methods
    
    /**
        Saves a user's details to the database.
        This method is used only when creating a user for the first time at sign up and only saves personal info.
        Depending on if we allow users to change their details, then this will also be used in that situation.

        - Parameters:
            - user: the user being saved.
    */
    func saveUser(user: User) {
        
        //Create child references from baseRef to define the nodes that data will be stored under.
        // E.g. the two lines below specify "Base -> Users -> UserID"
        let usersRef = baseRef.child(USERS_REF_STRING)
        let userRef = usersRef.child(user.uid)
        
        //Create child references for each property and use setValue to store the corresponding value.
        userRef.child(FNAME_REF_STRING).setValue(user.fname)
        userRef.child(LNAME_REF_STRING).setValue(user.lname)
        userRef.child(ORG_REF_STRING).setValue(user.org)
        userRef.child(EMAIL_REF_STRING).setValue(user.email)
        print("DS: user stored in database") //DEBUG
        
    }
    
    /**
     Loads a user from the database and creates a user object.
     
     - Parameters:
     - uid: the user's unique ID.
     - completion: the completion block that passes back the completed user.
     */
    func loadUser( uid: String, completion: ( user: User ) -> Void ) {
        
        //As with saving, create references to the nodes we want to retrieve data from.
        let usersRef = baseRef.child(USERS_REF_STRING)
        let userRef = usersRef.child(uid)

        userRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            print( "DS: fetching user" ) //DEBUG
            let fname = snapshot.value![FNAME_REF_STRING] as! String
            let lname = snapshot.value![LNAME_REF_STRING] as! String
            let org = snapshot.value![ORG_REF_STRING] as! String
            let email = snapshot.value![EMAIL_REF_STRING] as! String

            let user = User(fname: fname, lname: lname, org: org, email: email, uid: uid ) //weeklyGoals: weeklyGoalIDStrings )

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
    */
    func saveGoal( uid: String, goal: Goal )
    {
        var goalsRef = FIRDatabaseReference()
        if goal is WeeklyGoal
        {
            goalsRef = baseRef.child(WEEKLYGOALS_REF_STRING)
        }
        else if goal is MonthlyGoal
        {
            goalsRef = baseRef.child(MONTHLYGOALS_REF_STRING)
        }
        
        let goalRef = goalsRef.child(uid).child(goal.gid)
        goalRef.child(GOALTEXT_REF_STRING).setValue(goal.goalText)
        goalRef.child(KLA_REF_STRING).setValue(goal.kla)
        goalRef.child(COMPLETE_REF_STRING).setValue(goal.complete)
        goalRef.child(KICKIT_REF_STRING).setValue(goal.kickItText)
        
        //converting deadline from NSDate to String
        let dateFormatter = NSDateFormatter( )
        if goal is WeeklyGoal
        {
            dateFormatter.dateFormat = "dd/MM/yyyy"
        }
        else if goal is MonthlyGoal
        {
            dateFormatter.dateFormat = "MMMM"
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
    func loadWeeklyGoals( uid: String, completion: ( weeklyGoals: [WeeklyGoal] ) -> Void )
    {
        
        var weeklyGoals = [WeeklyGoal]()
        let weeklyGoalsRef = baseRef.child(WEEKLYGOALS_REF_STRING).child(uid)
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
                    let weeklyGoal = WeeklyGoal(goalText: goalText, kla: keyLifeArea, deadline: deadline, gid: weeklyGoalID, complete: complete, kickItText: kickItText )
                    weeklyGoals.append(weeklyGoal)
                }
                print("DS: fetched weekly goals") //DEBUG
                completion( weeklyGoals: weeklyGoals )
                
            }
            else
            {
                print("DS: no weekly goals to fetch") //DEBUG
                completion( weeklyGoals: weeklyGoals )
                
            }
        })
    }
    
    /**
     Loads a user's monthly goals from the database.
     
     - Parameters:
     - uid: user ID that the goals belong.
     - completion: the block that passes back the fetched goals.
     */
    func loadMonthlyGoals( uid: String, completion: ( monthlyGoals: [MonthlyGoal] ) -> Void )
    {

        var monthlyGoals = [MonthlyGoal]( )
        let monthlyGoalsRef = baseRef.child(MONTHLYGOALS_REF_STRING).child(uid)
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
                    let monthlyGoal = MonthlyGoal(goalText: goalText, kla: keyLifeArea, deadline: deadline, gid: gid, complete: complete, kickItText: kickItText )
                    monthlyGoals.append(monthlyGoal)
                }
                print("DS: fetched monthly goals") //DEBUG
                completion( monthlyGoals: monthlyGoals )
                
            }
            else
            {
                print("DS: no monthly goals to fetch") //DEBUG
                completion( monthlyGoals: monthlyGoals )
                
            }
        })
    }
    
    
    /**
        Removes a user's weekly goal from the database.
     
        - Parameters:
            - uid: ID of user that owns the weekly goal.
            - goal: the goal being removed
     */
    func removeGoal( uid: String, goal: Goal )
    {
        var goalsRef = FIRDatabaseReference( )
        if goal is WeeklyGoal
        {
            goalsRef = baseRef.child(WEEKLYGOALS_REF_STRING)
        }
        else
        {
            goalsRef = baseRef.child(MONTHLYGOALS_REF_STRING)
        }
        
        let goalRef = goalsRef.child(uid).child(goal.gid)
        goalRef.removeValue( )
    }
    
    // MARK: - Dream methods
    
    /**
     Saves a dream to the database.
     
     - Parameters:
     - uid: the user ID of the user the goal belongs to.
     - dream: the goal being saved.
     */
    func saveDream( uid: String, dream: Dream )
    {
        let dreamsRef = baseRef.child(DREAMS_REF_STRING)
        
        let dreamRef = dreamsRef.child(uid).child(dream.did)
        dreamRef.child(DREAMTEXT_REF_STRING).setValue(dream.dreamDesc)
        
        //convert NSURL to string
        //let urlString = dream.dreamImg.absoluteString
        dreamRef.child(DREAMURL_REF_STRING).setValue(dream.dreamImg)
    }
    
    /**
     Loads a user's dreams from the database (what a strange thing).
     
     - Parameters:
     - uid: user ID that the goals belong.
     - completion: the block that passes back the fetched goals.
     */
    func loadDreams( uid: String, completion: ( dreams: [Dream] ) -> Void )
    {
        
        var dreams = [Dream]( )
        let dreamsRef = baseRef.child(DREAMS_REF_STRING).child(uid)
        dreamsRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.exists()
            {
                for dreamSnapshot in snapshot.children
                {
                    let dreamText = dreamSnapshot.value![DREAMTEXT_REF_STRING] as! String
                    let dreamUrl = dreamSnapshot.value![DREAMURL_REF_STRING] as! String
                    let did = String(dreamSnapshot.key)
                    let dream = Dream(dreamDesc: dreamText, dreamImg: dreamUrl, did: did)
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
    func removeDream( uid: String, dream: Dream )
    {
        baseRef.child(DREAMS_REF_STRING).child(uid).child(dream.did).removeValue()
    }
    
    
    // MARK: - MyValues methods
    
    /**
     Saves user's values to the database.
     
     - Parameters:
     - user: user whose values are being saved
     */
    func saveValues( user: User )
    {
        let ref = baseRef.child(VALUES_REF_STRING).child(user.uid)
       
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
    func loadValues( uid: String, completion: ( values: [String:String] ) -> Void )
    {
        
        var values = [ KLA_FAMILY: "", KLA_WORKBUSINESS: "", KLA_PERSONALDEV: "", KLA_FINANCIAL: "",
                       KLA_FRIENDSSOCIAL: "", KLA_HEALTHFITNESS: "", KLA_EMOSPIRITUAL: "", KLA_PARTNER: "" ]
        let ref = baseRef.child(VALUES_REF_STRING).child(uid)
        ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.exists()
            {
                for valueSnapshot in snapshot.children
                {
                    values[KLA_FAMILY] = valueSnapshot.value![KLA_FAMILY] as? String
                    values[KLA_FINANCIAL] = valueSnapshot.value![KLA_FINANCIAL] as? String
                    values[KLA_PERSONALDEV] = valueSnapshot.value![KLA_PERSONALDEV] as? String
                    values[KLA_FRIENDSSOCIAL] = valueSnapshot.value![KLA_FRIENDSSOCIAL] as? String
                    values[KLA_HEALTHFITNESS] = valueSnapshot.value![KLA_HEALTHFITNESS] as? String
                    values[KLA_WORKBUSINESS] = valueSnapshot.value![KLA_WORKBUSINESS] as? String
                    values[KLA_EMOSPIRITUAL] = valueSnapshot.value![KLA_EMOSPIRITUAL] as? String
                    values[KLA_EMOSPIRITUAL] = valueSnapshot.value![KLA_EMOSPIRITUAL] as? String
                    
                }
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
}