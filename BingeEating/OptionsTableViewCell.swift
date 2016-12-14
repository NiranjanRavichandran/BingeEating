//
//  OptionsTableViewCell.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 12/13/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        optionLabel.layer.cornerRadius = (self.frame.height - 8)  / 2
        optionLabel.clipsToBounds = true
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
