//
//  WeeklyGoalTableViewCell.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 19/08/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

protocol GoalTableViewCellDelegate
{
    func completeButtonPressed( cell: GoalTableViewCell )
}

import UIKit

class GoalTableViewCell: UITableViewCell {

    var delegate: GoalTableViewCellDelegate?
    

    @IBOutlet weak var dueImageIcon: UIImageView!
    @IBOutlet weak var goalTextLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var doneCircle: UIImageView!
    @IBOutlet weak var tickButton: UIButton!

    
    @IBAction func completeButtonPressed(sender: AnyObject)
    {
        
        delegate?.completeButtonPressed(self)
    }
    
    @IBAction func tickButtonToComplete(sender: AnyObject) {
        delegate?.completeButtonPressed(self)

    }
    
    
}
