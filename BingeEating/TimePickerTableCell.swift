//
//  TimePickerTableCell.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 11/10/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class TimePickerTableCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    var pickerDelegate: PickerSelectedDelegate?
    
    var isMinutes: Bool = false {
        didSet {
            picker.reloadAllComponents()
        }
    }
    
    var hours = "10"
    var minutes = "00"
    var dayNight = "AM"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        picker.dataSource = self
        picker.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if isMinutes {
            return 1
        }
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isMinutes {
            return 12
        }else {
            if component == 0 {
                return 12
            }else if component == 1 {
                return 12
            }else {
                return 2
            }
        }
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if !isMinutes {
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
        
        return String(row * 5)
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
        if isMinutes {
            self.valueLabel.text = String(row * 5) + " Minutes"
            pickerDelegate?.didSelectPickerValue(forCell: 2, selectedValue: row*5)
        }else {
            self.valueLabel.text = hours + ":" + minutes + " " + dayNight
            pickerDelegate?.didSelectPickerValue(forCell: 0, selectedValue: self.valueLabel.text ?? " ")
        }
        
    }
    
}
