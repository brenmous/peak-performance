//
//  MonthlyGoalTableViewCell.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 20/08/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

protocol MonthlyGoalTableViewCellDelegate
{
    func completeButtonPressed( _ cell: MonthlyGoalTableViewCell )
}

import UIKit

class MonthlyGoalTableViewCell: UITableViewCell
{

    var delegate: MonthlyGoalTableViewCellDelegate?

    @IBOutlet weak var dueLabelIcon: UIImageView!
    @IBOutlet weak var goalTextLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var doneCircle: UIImageView!
    

    @IBAction func tickButtonToComplete(_ sender: AnyObject) {
        delegate?.completeButtonPressed(self)
    }
    
    @IBAction func completeButtonPressed(_ sender: AnyObject)
    {
        delegate?.completeButtonPressed(self)
    }
}
