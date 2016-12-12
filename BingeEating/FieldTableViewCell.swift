//
//  FieldTableViewCell.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 11/9/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class FieldTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var fieldTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellField: UITextField!
    @IBOutlet weak var attachButton: UIButton!
    
    var fieldDelegate: AreaFieldReturnsDelegate?
    var cellSection: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.fieldTrailingConstraint.constant = 0
        attachButton.addTarget(self, action: #selector(self.lauchAttachImage), for: .touchUpInside)
        cellField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func lauchAttachImage() {
        let topVC = Utility.getTopMostVC()
        topVC?.present(UINavigationController(rootViewController: AddPhotoViewController()), animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        fieldDelegate?.didEnterValue(forCell: cellSection!, fieldValue: textField.text ?? " ")
    }

}
