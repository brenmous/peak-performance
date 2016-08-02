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
        //userRef.child("username").setValue(user.username)
        userRef.child(EMAIL_REF_STRING).setValue(user.email)
        print("DS: user stored in database") //DEBUG
        
    }
    
    /**
        Loads a user from the database and creates a user object.

        - Parameters:
            - uid: the user's unique ID.
            - completion: the completion block that passes back the completed user.
    */
    func loadUser( uid: String, completion: ( user: User, weeklyGoalIDStrings: [String] ) -> Void ) {
        
        //As with saving, create references to the nodes we want to retrieve data from.
        let usersRef = baseRef.child(USERS_REF_STRING)
        let userRef = usersRef.child(uid)
        
        //This is the asynchronous method for retrieving data.
        //Because it's async, we have to do any manipulation etc. of the data and pass back it with the completion block within the "withBlock" closure.
        //Otherwise, the program will race off while the fetch is still happening.
        userRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            print( "DS: fetching user" ) //DEBUG
            let fname = snapshot.value![FNAME_REF_STRING] as! String
            let lname = snapshot.value![LNAME_REF_STRING] as! String
            let org = snapshot.value![ORG_REF_STRING] as! String
            //let username = snapshot.value!["username"] as! String
            let email = snapshot.value![EMAIL_REF_STRING] as! String
            let weeklyGoalIDs = snapshot.value![WEEKLYGOALS_REF_STRING]
            var weeklyGoalIDStrings = [String]( )
            
            //If data doesn't exist in the database, the snapshot will be nil.
            //Make sure to check before accessing these optional snapshots.
            //WeeklyGoalIDs is a dictionary because we have saved it as an index (see comments in saveWeeklyGoals)...
            if let wgids = weeklyGoalIDs as? [String:Bool]
            {
                for wgid in wgids
                {
                    //... so wgid.0 is the value we actually want.
                    weeklyGoalIDStrings.append( wgid.0 )
                }
            }
            let user = User(fname: fname, lname: lname, org: org, email: email, uid: uid ) //weeklyGoals: weeklyGoalIDStrings )
            
            completion( user: user, weeklyGoalIDStrings: weeklyGoalIDStrings ) //passing the created and user and content IDs back using the completion block
            
            print( "DS: user \(user.email) fetched" ) //DEBUG
        })        
    }
    
    
    
    // MARK: - Goal Methods
    /**
        Saves a goal to the database.
        The goals are stored in their own nodes under their IDs, and the goal IDs are also stored under the node of the user that owns them.
        Firebase snapshots capture all data within a node, so only storing the IDs under User means we can iterate through and retrieve
        only the goals that we need (if necessary).
    
        - Parameters:
            - uid: the user ID of the user the goal belongs to.
            - goal: the goal being saved.
    */
    func saveGoal( uid: String, goal: Goal )
    {
        let usersRef = baseRef.child(USERS_REF_STRING)
        let userRef = usersRef.child(uid)
        var userGoalRef = FIRDatabaseReference()
        var goalsRef = FIRDatabaseReference()
        if goal is WeeklyGoal
        {
            userGoalRef = userRef.child(WEEKLYGOALS_REF_STRING)
            goalsRef = baseRef.child(WEEKLYGOALS_REF_STRING)
        }
        else if goal is MonthlyGoal
        {
            userGoalRef = userRef.child(MONTHLYGOAL_REF_STRING)
            goalsRef = baseRef.child(MONTHLYGOAL_REF_STRING)
        }
        
        //save weekly goal ID under user info in database
        //When saving an ID etc. for indexing purposes, the child reference is really the value we want and the setValue parameter is arbitrary.
        //So in this case, child(weeklyGoal.wgid) is the info we actually care about.
        userGoalRef.child(goal.gid).setValue(true)
        print("DS: saved goal \(goal.gid) under uid" ) //DEBUG
        
        //save weekly goal info under weekly goals in database
        let goalRef = goalsRef.child(goal.gid)
        goalRef.child(GOALTEXT_REF_STRING).setValue(goal.goalText)
        goalRef.child(KLA_REF_STRING).setValue(goal.kla)
        goalRef.child(UID_REF_STRING).setValue(uid)
        //converting deadline from NSDate to String
        let dateFormatter = NSDateFormatter( )
        dateFormatter.dateFormat = "dd/MM/yyyy"
        goalRef.child(DEADLINE_REF_STRING).setValue(dateFormatter.stringFromDate(goal.deadline) )
        print("DS: saved goal \(goal.gid) under gid" ) //DEBUG
    }
    
    /**
        Loads a user's weekly goal from the database and creates a WeeklyGoal object.

        - Parameters:
            - weeklyGoalID: the ID of the weekly goal being loaded.
            - completion: the block that the created goal is accessed from.
     */
    func loadWeeklyGoal( weeklyGoalID: String, completion: ( weeklyGoal: WeeklyGoal ) -> Void )
    {
        let weeklyGoalsRef = baseRef.child(WEEKLYGOALS_REF_STRING)
        let weeklyGoalRef = weeklyGoalsRef.child(weeklyGoalID)
        
        weeklyGoalRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let goalText = snapshot.value![GOALTEXT_REF_STRING] as! String
            let keyLifeArea = snapshot.value![KLA_REF_STRING] as! String
            let deadline = snapshot.value![DEADLINE_REF_STRING] as! String
            let weeklyGoal = WeeklyGoal(goalText: goalText, kla: keyLifeArea, deadline: deadline, gid: weeklyGoalID )
            completion( weeklyGoal: weeklyGoal )
            print("DS: fetched weekly goal \(weeklyGoal.gid)") //DEBUG
        })
    }
    
    /**
        Removes a user's weekly goal from the database.
     
        - Parameters:
            - uid: ID of user that owns the weekly goal.
            - weeklyGoalID: ID of the weekly goal being removed.
     */
    func removeWeeklyGoal( uid: String, weeklyGoalID: String )
    {
        //remove weekly goal ID from user node
        let usersRef = baseRef.child(USERS_REF_STRING)
        let userRef = usersRef.child(uid)
        let goalRef = userRef.child(WEEKLYGOALS_REF_STRING)
        goalRef.child(weeklyGoalID).removeValue()
        
        //remove weekly goal from weekly goals node
        let weeklyGoalsRef = baseRef.child(WEEKLYGOALS_REF_STRING)
        let weeklyGoalRef = weeklyGoalsRef.child(weeklyGoalID)
        weeklyGoalRef.removeValue()
    }

}