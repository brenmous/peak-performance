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
class DataService       //: SignUpDataService, LogInDataService
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
        
        //converting deadline from NSDate to String
        let dateFormatter = NSDateFormatter( )
        dateFormatter.dateFormat = "dd/MM/yyyy"
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
                    let deadline = goalSnapshot.value![DEADLINE_REF_STRING] as! String
                    let weeklyGoalID = String(goalSnapshot.key)
                    let weeklyGoal = WeeklyGoal(goalText: goalText, kla: keyLifeArea, deadline: deadline, gid: weeklyGoalID )
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
                    let deadline = goalSnapshot.value![DEADLINE_REF_STRING] as! String
                    let gid = String(goalSnapshot.key)
                    let monthlyGoal = MonthlyGoal(goalText: goalText, kla: keyLifeArea, deadline: deadline, gid: gid )
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

}