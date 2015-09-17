//
//  CommonTableViewCell.swift
//  SafetyFirst
//
//  Created by Vincent Pacul on 24/7/15.
//  Copyright (c) 2015 Vincent Pacul. All rights reserved.
//

import UIKit

class CommonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileDateCreatedField: UILabel!
    @IBOutlet weak var profileTitleCell: UILabel!
    @IBOutlet weak var purposeDateCreatedField: UILabel!
    @IBOutlet weak var purposeTitleCell: UILabel!
    @IBOutlet weak var detailPurposeDateCreatedField: UILabel!
    @IBOutlet weak var detailPurposeTitleCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
