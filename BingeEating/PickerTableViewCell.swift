//
//  PickerTableViewCell.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 11/9/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class PickerTableViewCell: UITableViewCell,UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellValueLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    var hours = "00"
    var minutes = "00"
    var dayNight = "AM"
    var pickerDelegate: PickerSelectedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        picker.delegate = self
        picker.dataSource = self
        //self.cellValueLabel.text = hours + ":" + minutes + dayNight
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: - UIPickerView Datasource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 12
        }else if component == 1 {
            return 12
        }else {
            return 2
        }
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(row + 1)
        }else if component == 1 {
            return String(row * 5)
        }else {
            if row == 0 {
                return "AM"
            }
            return "PM"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            hours = String(row + 1)
        }else if component == 1 {
            minutes = String(row * 5)
        }else {
            if row == 0 {
                dayNight = "AM"
            }
            dayNight = "PM"
        }
        self.cellValueLabel.text = hours + ":" + minutes + " " + dayNight
        pickerDelegate?.didSelectPickerValue(forCell: 0, selectedValue: self.cellValueLabel.text!)
    }

}
