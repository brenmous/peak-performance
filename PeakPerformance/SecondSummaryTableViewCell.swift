//
//  SecondSummaryTableViewCell.swift
//  PeakPerformance
//
//  Created by Bren on 12/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit

class SecondSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var goalTextLabel: UILabel!
    @IBOutlet weak var kickItTextView: UITextView!
    @IBOutlet weak var klaIconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
