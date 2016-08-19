//
//  WeeklyGoalTableViewCell.swift
//  PeakPerformance
//
//  Created by Bren on 19/08/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

protocol GoalTableViewCellDelegate
{
    func completeButtonPressed( cell: WeeklyGoalTableViewCell )
}

import UIKit

class WeeklyGoalTableViewCell: UITableViewCell {

    var delegate: GoalTableViewCellDelegate?
    
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
