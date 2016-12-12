//
//  CommonFieldTableCell.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 12/1/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class CommonFieldTableCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellField: UITextField!
    @IBOutlet weak var infoButton: UIButton!
    
    var cellDelegate: AreaFieldReturnsDelegate?
    
    var section = 0 {
        didSet {
            infoButton.tag = section
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        cellField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        cellDelegate?.didEnterValue(forCell: section, fieldValue: textField.text ?? "0")
    }
    
}
