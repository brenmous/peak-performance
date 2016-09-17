//
//  WeeklyGoalTableViewCell.swift
//  PeakPerformance
//
//  Created by Bren on 19/08/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

//TODO: Rename this class to WeeklyGoalTableViewCell and carry out associated housekeeping. 


protocol GoalTableViewCellDelegate
{
    func completeButtonPressed( cell: GoalTableViewCell )
}

import UIKit

class GoalTableViewCell: UITableViewCell {

    var delegate: GoalTableViewCellDelegate?
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var dueImageIcon: UIImageView!
    @IBOutlet weak var goalTextLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!

    @IBAction func completeButtonPressed(sender: AnyObject)
    {
        
        delegate?.completeButtonPressed(self)
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
