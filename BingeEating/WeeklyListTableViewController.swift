//
//  WeeklyListTableViewController.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 12/1/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class WeeklyListTableViewController: UITableViewController {
    
    var weeklyLogsList: [WeeklyLog]?
    let appdelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Weekly Logs"
        Utility.addSlideMenu(for: self)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getWeeklyLogs()
    }
    
    func getWeeklyLogs() {
        NetworkManager.sharedManager.getWeeklyLog(token: appdelegate.token!, onSuccess: { (logs) in
            self.weeklyLogsList = logs
            self.tableView.reloadData()
        }) { (errorDesc) in
            Utility.showAlert(withTitle: "Error", withMessage: errorDesc, from: self, type: .error)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Week " + String(indexPath.row + 1)
        cell.backgroundColor = Utility.lightGrey
        cell.textLabel?.textColor = Utility.bgBlue
        cell.accessoryType = .disclosureIndicator
        if let filtered = weeklyLogsList?.filter({$0.week == (indexPath.row+1)}) {
            if filtered.count > 0 {
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weeklyVC = WeeklyLogViewController()
        if let filterWeek = weeklyLogsList?.filter({$0.week == (indexPath.row+1)}) {
            if filterWeek.count > 0 {
                weeklyVC.isEditLog = true
                weeklyVC.newLog = filterWeek.first
            }else {
                weeklyVC.isEditLog = false
            }
        }else {
            weeklyVC.isEditLog = false
        }
        weeklyVC.week = indexPath.row + 1
        self.navigationController?.pushViewController(weeklyVC, animated: true)
    }
}
