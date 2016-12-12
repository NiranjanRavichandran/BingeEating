//
//  PhysicalActivityViewController.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 11/10/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class PhysicalActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, PickerSelectedDelegate, AreaFieldReturnsDelegate, WWCalendarTimeSelectorProtocol {
    
    var tableView: UITableView!
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var newActitvityItem = PhysicalLogItem()
    var isEditLog = false
    var logIndex: Int?
    
    lazy private var actitvityIndicator: CustomActivityIndicator = {
        return CustomActivityIndicator(image: UIImage(named: "Spinner.png")!)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "TimePickerTableCell", bundle: nil), forCellReuseIdentifier: "PickerTableCell")
        tableView.register(UINib(nibName: "TextAreaTableCell", bundle: nil), forCellReuseIdentifier: "AreaTableCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dismissViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.addActivity))
    }
    
    func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addActivity() {
        //to be chnaged later
        if newActitvityItem.typeOfActivity == " " {
            Utility.showAlert(withTitle: "Error", withMessage: "Please enter all values", from: self, type: .warning)
        }else {
            actitvityIndicator.startAnimating()
            if isEditLog {
                appdelegate.physicalActItem?[logIndex!] = newActitvityItem
            }else {
                if appdelegate.physicalActItem == nil {
                    appdelegate.physicalActItem = [newActitvityItem]
                }else {
                    appdelegate.physicalActItem?.append(newActitvityItem)
                }
            }
            saveLogToServer()
        }
    }
    
    func saveLogToServer() {
        if appdelegate.token != nil {
            NetworkManager.sharedManager.postPhysicalActivity(token: appdelegate.token!, activityItem: newActitvityItem, onSuccess: {
                self.dismissViewController()
                self.actitvityIndicator.stopAnimating()
            }, onError: { (errDesc) in
                self.actitvityIndicator.stopAnimating()
                Utility.showAlert(withTitle: "Oops", withMessage: errDesc, from: self, type: .alert)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Tableview Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableCell = UITableViewCell()
        
        if indexPath.section == 0 || indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PickerTableCell", for: indexPath) as! TimePickerTableCell
            if indexPath.section == 0 {
                cell.cellLabel.text = "Time"
                cell.isMinutes = false
                cell.valueLabel.text = Utility.getTime(fromDate: newActitvityItem.time) ?? Utility.getDate(fromString: newActitvityItem.time)
            }else {
                cell.cellLabel.text = "Minutes Performed"
                cell.isMinutes = true
                cell.valueLabel.text = String(newActitvityItem.duration) + " Minutes"
            }
            cell.pickerDelegate = self
            tableCell = cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AreaTableCell", for: indexPath) as! TextAreaTableCell
            cell.cellLabel.text = "Type of Physical Activity"
            cell.cellField.placeholder = "Running, Swimming, Walking"
            cell.cellField.tag = 200
            cell.fieldDelegate = self
            if isEditLog {
                cell.cellField.text = newActitvityItem.typeOfActivity
            }
            tableCell = cell
        }
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 45
        }else if indexPath.section == 2 {
            return 150
        }else {
            return 90
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.showDatePicker()
        }
    }
    
    func showDatePicker() {
        let timeSelector = WWCalendarTimeSelector.instantiate()
        timeSelector.delegate = self
        timeSelector.optionTopPanelTitle = "Choose Date & Time"
        self.present(timeSelector, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.frame = self.view.bounds
    }
    
    //MARK: - Picker Selected delegate
    func didSelectPickerValue(forCell cell: Int, selectedValue: Any) {
        if cell == 0 {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd, "
            newActitvityItem.time = formatter.string(from: Date()) + (selectedValue as! String)
            
        }else {
            newActitvityItem.duration = Float(selectedValue as! Int)
        }
    }
    
    //MARK: - Date picker delegate
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        newActitvityItem.time = formatter.string(from: date)
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
    }
    
    //MARK: - TextField ended delegate
    func didEnterValue(forCell cell: Int, fieldValue: String) {
        newActitvityItem.typeOfActivity = fieldValue
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
