//
//  HistoryTableViewCell.swift
//  PeakPerformance
//
//  Created by Bren on 6/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    
    // MARK: - Outlets
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var reviewReadyLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
