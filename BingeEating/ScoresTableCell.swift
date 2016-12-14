//
//  ScoresTableCell.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 12/13/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class ScoresTableCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let random = arc4random_uniform(4)
        icon.image = UIImage(named: "female\(random > 0 ? random : (random + 1)).png")
        self.selectionStyle = .none
        self.containerView.layer.cornerRadius = self.containerView.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
