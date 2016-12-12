//
//  WeeklyLogViewController.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 12/1/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class WeeklyLogViewController: UIViewController, AreaFieldReturnsDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    let weeklyLogTitle = ["Binges", "V/L/D", "Good Days", "Weight", "F/V", "Physcical Activity", "Events"]
    var newLog: WeeklyLog!
    var isEditLog = false
    var info: [String]?
    var week = 0
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if newLog == nil {
            newLog = WeeklyLog()
        }
        self.view.backgroundColor = UIColor.white
        
        self.title = "Week " + String(week)
        tableView = UITableView(frame: self.view.bounds)

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Send.png"), style: .done, target: self, action: #selector(self.saveLogToServer))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "CommonFieldTableCell", bundle: nil), forCellReuseIdentifier: "CellField")
        self.view.addSubview(tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let path = Bundle.main.path(forResource: "WeeklyInfo", ofType: ".plist") {
            info = NSArray(contentsOfFile: path) as? [String]
        }
        
        if !isEditLog {
            //Get New weeklyLog
            NetworkManager.sharedManager.getNewWeeklyLog(token: appdelegate.token!, week: week, onSuccess: { (log) in
                self.newLog = log
                self.tableView.reloadData()
            }, onError: { (errorDesc) in
                Utility.showAlert(withTitle: "Error", withMessage: errorDesc, from: self, type: .error)
            })
        }
    }
    
    func saveLogToServer() {
        //Call Network Manager to save weekly log to server
        
        NetworkManager.sharedManager.postWeeklyLog(token: appdelegate.token!, logId: newLog.logId, binges: newLog.binges, vld: newLog.vld, physical: newLog.activites, fv: newLog.fv, goodDays: newLog.goodDays, events: newLog.events, onSuccess: {
            Utility.showAlert(withTitle: "Success", withMessage: "Your weekly log was saved", from: self, type: .alert)
        }) { (errorDesc) in
            Utility.showAlert(withTitle: "Error", withMessage: errorDesc, from: self, type: .error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return weeklyLogTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellField", for: indexPath) as! CommonFieldTableCell
        
        cell.cellDelegate = self
        cell.cellLabel.text = weeklyLogTitle[indexPath.section]
        cell.cellField.keyboardType = .numberPad
        cell.section = indexPath.section
        
        if indexPath.section == 6 {
            cell.cellField.keyboardType = .default
        }
        
        if isEditLog {
            switch indexPath.section {
            case 0:
                cell.cellField.placeholder = String(newLog.binges)
            case 1:
                cell.cellField.placeholder = String(newLog.vld)
            case 2:
                cell.cellField.placeholder = String(newLog.goodDays)
            case 3:
                cell.cellField.placeholder = String(newLog.weight)
            case 4:
                cell.cellField.placeholder = String(newLog.fv)
            case 5:
                cell.cellField.placeholder = String(newLog.activites)
            default:
                cell.cellField.placeholder =  newLog.events
            }
        }
        cell.infoButton.addTarget(self, action: #selector(self.showInfo(sender:)), for: .touchUpInside)
        return cell
    }
    
    func didEnterValue(forCell cell: Int, fieldValue: String) {
        if cell == 0 {
            newLog.binges = Int(fieldValue)
        }else if cell == 1 {
            newLog.vld = Int(fieldValue)
        }else if cell == 2 {
            newLog.goodDays = Int(fieldValue)
        }else if cell == 3 {
            newLog.weight = Int(fieldValue)
        }else if cell == 4 {
            newLog.fv = Int(fieldValue)
        }else if cell == 5 {
            newLog.activites = Int(fieldValue)
        }else  {
            newLog.events = fieldValue
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableView.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.frame = self.view.bounds
    }
    
    func showInfo(sender: UIButton) {
        if info != nil {
            Utility.showAlert(withTitle: "Info", withMessage: info![sender.tag], from: self, type: .alert)
        }
    }
}
