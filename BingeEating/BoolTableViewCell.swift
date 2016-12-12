//
//  BoolTableViewCell.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 11/9/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

protocol BoolResponseDelegate {
    func didChooseValue(sender: UIButton, questionSection: Int)
}

class BoolTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    var delegate: BoolResponseDelegate?
    var section: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        yesButton.layer.cornerRadius = 22
        yesButton.tag = 100
        noButton.layer.cornerRadius = 22
        noButton.tag = 101
        yesButton.addTarget(self, action: #selector(self.didPressButton(sender:)), for: .touchUpInside)
        noButton.addTarget(self, action: #selector(self.didPressButton(sender:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func didPressButton(sender: UIButton) {
        sender.backgroundColor = Utility.lightPurpule
        if sender.tag == 100 {
            noButton.backgroundColor = Utility.darkBlue
        }else {
            yesButton.backgroundColor = Utility.darkBlue
        }
        delegate?.didChooseValue(sender: sender, questionSection: section!)
    }

}
