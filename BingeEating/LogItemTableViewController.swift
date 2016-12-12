//
//  LogItemTableViewController.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 11/9/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class LogItemTableViewController: UITableViewController, UITextFieldDelegate, BoolResponseDelegate, PickerSelectedDelegate, AreaFieldReturnsDelegate, WWCalendarTimeSelectorProtocol {
    
    var logQuestions: [NSDictionary]!
    var expandPicker: Bool = false
    var newLogItem = DailyLogItem()
    var isLogEditing = false
    var logIndex: Int?
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    lazy private var actitvityIndicator: CustomActivityIndicator = {
        return CustomActivityIndicator(image: UIImage(named: "Spinner.png")!)
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        logQuestions = []
        getQuestions()
        self.tableView.separatorStyle = .none
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dismissViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.submitLogItem))
        
    }
    
    func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getQuestions() {
        if let path = Bundle.main.path(forResource: "LogQuestions", ofType: "plist") {
            logQuestions = NSArray(contentsOfFile: path) as! [NSDictionary]!
            tableView.reloadData()
        }
    }
    
    func submitLogItem() {
        //Add item to log
        if newLogItem.foodAndDrink == " " || newLogItem.contextSetting == " " {
            Utility.showAlert(withTitle: "Error", withMessage: "Please enter all the fields", from: self, type: .error)
        }else {
            actitvityIndicator.startAnimating()
            if isLogEditing {
                appdelegate.dailyLogItems?[logIndex!] = newLogItem
            }else {
                if appdelegate.dailyLogItems == nil {
                    appdelegate.dailyLogItems = [newLogItem]
                }else {
                    appdelegate.dailyLogItems?.append(newLogItem)
                }
            }
            self.saveLogToServer()
        }
    }
    
    func saveLogToServer() {
        if appdelegate.token != nil {
        NetworkManager.sharedManager.postDailyLog(token: appdelegate.token!, dailylogItem:newLogItem, onSuccess: {
            self.actitvityIndicator.stopAnimating()
            self.dismissViewController()
        }, onError: { (errorDesc) in
            self.actitvityIndicator.stopAnimating()
            Utility.showAlert(withTitle: "Error", withMessage: errorDesc, from: self, type: .error)
        })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return logQuestions.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableCell = UITableViewCell()
        
        if let type = logQuestions[indexPath.section]["Type"] as? String {
            switch type {
            case BECellType.picker.rawValue:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath) as! PickerTableViewCell
                if !self.expandPicker {
                    cell.picker.alpha = 0
                }else {
                    cell.picker.alpha = 1
                }
                cell.cellLabel.text = logQuestions[indexPath.section]["Question"] as? String
                cell.cellValueLabel.text = Utility.getTime(fromDate: newLogItem.eatTime) ?? Utility.getDate(fromString: newLogItem.eatTime)
                cell.pickerDelegate = self
                tableCell = cell
            case BECellType.bool.rawValue:
                let cell = tableView.dequeueReusableCell(withIdentifier: "BoolCell", for: indexPath) as! BoolTableViewCell
                cell.questionLabel.text = logQuestions[indexPath.section]["Question"] as? String
                cell.delegate = self
                cell.section = indexPath.section
                tableCell = cell
                if isLogEditing {
                    if indexPath.section == 3 {
                        if newLogItem.didBinge! {
                            cell.yesButton.backgroundColor = Utility.lightPurpule
                        }else {
                            cell.noButton.backgroundColor = Utility.lightPurpule
                        }
                    }else {
                        if newLogItem.vomitOrLaxative! {
                            cell.yesButton.backgroundColor = Utility.lightPurpule
                        }else {
                            cell.noButton.backgroundColor = Utility.lightPurpule
                        }
                    }
                }
            case BECellType.textField.rawValue:
                let cell = tableView.dequeueReusableCell(withIdentifier: "FieldCell", for: indexPath)
                as! FieldTableViewCell
                cell.cellLabel.text = logQuestions[indexPath.section]["Question"] as? String
                //Hide attach image button
                cell.attachButton.alpha = 0
                cell.fieldTrailingConstraint.constant = -5
                cell.fieldDelegate = self
                cell.cellSection = indexPath.section
                cell.cellField.placeholder = logQuestions[indexPath.section]["Placeholder"] as? String
                if indexPath.section == 2 {
                    cell.cellField.keyboardType = .numberPad
                }
                
                if isLogEditing {
                     if indexPath.section == 2 {
                        cell.cellField.text = String(newLogItem.servings)
                    }else if indexPath.section == 5 {
                        cell.cellField.text = newLogItem.contextSetting
                    }
                }
                
                tableCell = cell
            case BECellType.textArea.rawValue:
                let cell = tableView.dequeueReusableCell(withIdentifier: "AreaCell", for: indexPath) as! AreaTableViewCell
                cell.cellLabel.text = logQuestions[indexPath.section]["Question"] as? String
                cell.areaDelegate = self
                cell.cellSection = indexPath.section
                cell.cellFieldArea.placeholder = logQuestions[indexPath.section]["Placeholder"] as? String
                if isLogEditing {
                    cell.cellFieldArea.text = newLogItem.feelings
                }
                tableCell = cell
            case BECellType.image.rawValue:
                let cell = tableView.dequeueReusableCell(withIdentifier: "FieldCell", for: indexPath) as! FieldTableViewCell
                cell.cellLabel.text = logQuestions[indexPath.section]["Question"] as? String
                cell.fieldDelegate = self
                cell.attachButton.alpha = 1
                cell.fieldTrailingConstraint.constant = -45
                cell.cellSection = indexPath.section
                cell.cellField.placeholder = logQuestions[indexPath.section]["Placeholder"] as? String
                if isLogEditing {
                    cell.cellField.text = newLogItem.foodAndDrink
                }
                tableCell = cell
            default:
                break
            }
        }
        return tableCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let type = logQuestions[indexPath.section]["Type"] as? String {
            if (type == BECellType.picker.rawValue && self.expandPicker) || type == BECellType.textArea.rawValue {
                return 150
            }else {
                
                return 65
            }
        }else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let type = logQuestions[indexPath.section]["Type"] as? String {
            if type == BECellType.picker.rawValue {
                self.showDatePicker()
            }
        }
    }
    
    func showDatePicker() {
        let timeSelector = WWCalendarTimeSelector.instantiate()
        timeSelector.delegate = self
        timeSelector.optionTopPanelTitle = "Choose Date & Time"
        self.present(timeSelector, animated: true, completion: nil)
    }
    
    //Date picker delegate
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        newLogItem.eatTime = formatter.string(from: date)
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
    }
 

    //MARK: - Bool response delegate
    func didChooseValue(sender: UIButton, questionSection: Int) {
        if sender.tag == 100 {
            //3 for question 4(Did you binge) and 4 for question 5(Any vomiting or laxative)
            //If order in LogQuestions.plist changes... change here too
            if questionSection == 3 {
                newLogItem.didBinge = true
            }else {
                newLogItem.vomitOrLaxative = true
            }
        }else {
            if questionSection == 3 {
                newLogItem.didBinge = false
            }else {
                newLogItem.vomitOrLaxative = false
            }
        }
    }
    
    func didSelectPickerValue(forCell cell: Int, selectedValue: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd "
        let dateString = formatter.string(from: Date())
        if let value = selectedValue as? String {
         newLogItem.eatTime = dateString + value
        }
    }
    
    //MARK: - AreaField Delegate
    func didEnterValue(forCell cell: Int, fieldValue: String) {
        if cell == 1 {
            newLogItem.foodAndDrink = fieldValue
        }else if cell == 2 {
            newLogItem.servings = Int(fieldValue) ?? 0
        }else if cell == 5 {
            newLogItem.contextSetting = fieldValue
        }else if cell == 6 {
            newLogItem.feelings = fieldValue
        }
    }
}


