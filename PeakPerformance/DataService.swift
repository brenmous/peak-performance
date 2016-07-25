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

        - Parameters:
            - user: the user being saved.
    */
    func saveUser(user: User) {
        
        let usersRef = baseRef.child("users")
        let userRef = usersRef.child(user.uid)
        userRef.child("fname").setValue(user.fname)
        userRef.child("lname").setValue(user.lname)
        userRef.child("org").setValue(user.org)
        userRef.child("username").setValue(user.username)
        userRef.child("email").setValue(user.email)
        print("DS: user stored in database") //DEBUG
        
    }
    
    /**
        Loads a user from the database and creates a user object.

        - Parameters:
            - uid: the user's unique ID.

        - Returns: the user object.
    */
    func loadUser( uid: String ) -> User {
        
        let usersRef = baseRef.child("users")
        let userRef = usersRef.child(uid)
        var fname = ""
        var lname = ""
        var org = ""
        var username = ""
        var email = ""
        var weeklyGoalIDs: [String]? = nil
        var weeklyGoals = [WeeklyGoal]()
        
        userRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            fname = snapshot.value!["fname"] as! String
            lname = snapshot.value!["lname"] as! String
            org = snapshot.value!["org"] as! String
            username = snapshot.value!["username"] as! String
            email = snapshot.value!["email"] as! String
            weeklyGoalIDs = snapshot.value!["weeklyGoals"] as! [String]?
                
        })
        
        
        
        if let wgIDs = weeklyGoalIDs
        {
            weeklyGoals = loadWeeklyGoals( wgIDs )
        }
        else
        {
            print("DS: no weekly goals found for user") //DEBUG
        }
        
        print("DS: user details fetched from database") //DEBUG
        return User(fname: fname, lname: lname, org: org, email: email, username: username, uid: uid, weeklyGoals: weeklyGoals )
        
    }
    
    // MARK: - Weekly Goal Methods
    
    /**
        Loads a user's weekly goals from the database and creates an array of weekly goals.

        - Parameters:
            - weeklyGoalIDs: array of weekly goal IDs.

        - Returns: an array containing the user's weekly goals.
     */
    func loadWeeklyGoals( weeklyGoalIDs: [String] ) -> [WeeklyGoal]
    {
        let weeklyGoalsRef = baseRef.child("weeklyGoals")
        var weeklyGoals = [WeeklyGoal]()
        for goalID in weeklyGoalIDs
        {
            let weeklyGoalRef = weeklyGoalsRef.child(goalID)
            var goalText = ""
            var keyLifeArea = KeyLifeArea.Empty
            var deadline = ""
            
            weeklyGoalRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                goalText = snapshot.value!["goalText"] as! String
                keyLifeArea = snapshot.value!["keyLifeArea"] as! KeyLifeArea
                deadline = snapshot.value!["deadline"] as! String
            })
            
            let weeklyGoal = WeeklyGoal(goalText: goalText, kla: keyLifeArea, deadline: deadline, wgid: goalID )
            weeklyGoals.append( weeklyGoal )
        }
        
        print("DS: weekly goals fetched from database") //DEBUG
        return weeklyGoals
    }
    
    /**
        Saves a weekly goal to the database.
    
        - Parameters:
            - uid: the user ID of the user the goal belongs to.
            - weeklyGoal: the goal being saved.
     */
    func saveWeeklyGoal( uid: String, weeklyGoal: WeeklyGoal )
    {
        //save weekly goal ID under user info in database
        let usersRef = baseRef.child("users")
        let userRef = usersRef.child(uid)
        userRef.child("weeklyGoals").setValue(weeklyGoal.wgid)
        
        //save weekly goal info under weekly goals in database
        let weeklyGoalsRef = baseRef.child("weeklyGoals")
        let weeklyGoalRef = weeklyGoalsRef.child(weeklyGoal.wgid)
        weeklyGoalRef.child("goalText").setValue(weeklyGoal.goalText)
        weeklyGoalRef.child("kla").setValue(weeklyGoal.kla.rawValue)
        let dateFormatter = NSDateFormatter( )
        dateFormatter.dateFormat = "dd/MM/yyyy"
        weeklyGoalRef.child("deadline").setValue(dateFormatter.stringFromDate(weeklyGoal.deadline) )
    }

    
}