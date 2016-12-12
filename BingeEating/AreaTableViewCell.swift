//
//  AreaTableViewCell.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 11/9/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class AreaTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellFieldArea: BECommonField!
    
    var areaDelegate: AreaFieldReturnsDelegate?
    var cellSection: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellFieldArea.delegate = self
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
        areaDelegate?.didEnterValue(forCell: cellSection!, fieldValue: textField.text ?? " ")
    }

}
