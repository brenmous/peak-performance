//
//  MonthlyGoalTableViewCell.swift
//  PeakPerformance
//
//  Created by Bren on 20/08/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

protocol MonthlyGoalTableViewCellDelegate
{
    func completeButtonPressed( cell: MonthlyGoalTableViewCell )
}

import UIKit

class MonthlyGoalTableViewCell: UITableViewCell {

    var delegate: MonthlyGoalTableViewCellDelegate?
    

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var dueLabelIcon: UIImageView!
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
