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
        let usersRef = baseRef.child("users")
        let userRef = usersRef.child(user.uid)
        
        //Create child references for each property and use setValue to store the corresponding value.
        userRef.child("fname").setValue(user.fname)
        userRef.child("lname").setValue(user.lname)
        userRef.child("org").setValue(user.org)
        //userRef.child("username").setValue(user.username)
        userRef.child("email").setValue(user.email)
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
        let usersRef = baseRef.child("users")
        let userRef = usersRef.child(uid)
        
        //This is the asynchronous method for retrieving data.
        //Because it's async, we have to do any manipulation etc. of the data and pass back it with the completion block within the "withBlock" closure.
        //Otherwise, the program will race off while the fetch is still happening.
        userRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            print( "DS: fetching user" ) //DEBUG
            let fname = snapshot.value!["fname"] as! String
            let lname = snapshot.value!["lname"] as! String
            let org = snapshot.value!["org"] as! String
            //let username = snapshot.value!["username"] as! String
            let email = snapshot.value!["email"] as! String
            let weeklyGoalIDs = snapshot.value!["weeklyGoals"]
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
            let user = User(fname: fname, lname: lname, org: org, email: email, uid: uid, weeklyGoals: weeklyGoalIDStrings )
            
            completion( user: user ) //passing the created user back using the completion block
            
            print( "DS: user \(user.email) fetched" ) //DEBUG
        })        
    }
    
    // MARK: - Weekly Goal Methods
    
    /**
        Loads a user's weekly goals from the database and creates an array of WeeklyGoal objects.

        - Parameters:
            - weeklyGoalID: an array of weekly goal IDs.
     */
    //WIP
    func loadWeeklyGoal( weeklyGoalID: String, completion: ( weeklyGoal: WeeklyGoal ) -> Void )
    {
        let weeklyGoalsRef = baseRef.child("weeklyGoals")
        let weeklyGoalRef = weeklyGoalsRef.child(weeklyGoalID)
        
        weeklyGoalRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let goalText = snapshot.value!["goalText"] as! String
            let keyLifeArea = snapshot.value!["kla"] as! String
            let deadline = snapshot.value!["deadline"] as! String
            let weeklyGoal = WeeklyGoal(goalText: goalText, kla: keyLifeArea, deadline: deadline, wgid: weeklyGoalID )
            completion( weeklyGoal: weeklyGoal )
            print("DS: fetched weekly goal \(weeklyGoal.wgid)") //DEBUG
        })
    }
    
    /**
        Saves a weekly goal to the database.
        The goals are stored in their own nodes under their IDs, and the goal IDs are also stored under the node of the user that owns them.
        Firebase snapshots capture all data within a node, so only storing the IDs under User means we can iterate through and retrieve
        only the goals that we need (if necessary).
    
        - Parameters:
            - uid: the user ID of the user the goal belongs to.
            - weeklyGoal: the goal being saved.
     */
    func saveWeeklyGoal( uid: String, weeklyGoal: WeeklyGoal )
    {
        //save weekly goal ID under user info in database
        let usersRef = baseRef.child("users")
        let userRef = usersRef.child(uid)
        let goalRef = userRef.child("weeklyGoals")
        //When saving an ID etc. for indexing purposes, the child reference is really the value we want and the setValue parameter is arbitrary.
        //So in this case, child(weeklyGoal.wgid) is the info we actually care about.
        goalRef.child(weeklyGoal.wgid).setValue(true)
        print("DS: saved weeklygoal under user ID" ) //DEBUG
        
        //save weekly goal info under weekly goals in database
        let weeklyGoalsRef = baseRef.child("weeklyGoals")
        let weeklyGoalRef = weeklyGoalsRef.child(weeklyGoal.wgid)
        weeklyGoalRef.child("goalText").setValue(weeklyGoal.goalText)
        weeklyGoalRef.child("kla").setValue(weeklyGoal.kla)
        weeklyGoalRef.child("uid").setValue(uid)
        //converting deadline from NSDate to String
        let dateFormatter = NSDateFormatter( )
        dateFormatter.dateFormat = "dd/MM/yyyy"
        weeklyGoalRef.child("deadline").setValue(dateFormatter.stringFromDate(weeklyGoal.deadline) )
        print("DS: saved weeklygoal under wgid" ) //DEBUG
    }

    
}