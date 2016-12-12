//
//  AppoinmentsTableViewController.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 11/10/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class AppoinmentsTableViewController: UITableViewController {
    
    let times = ["10:30", "9:15"]
    let dates = ["10/12/2016", "18/12/2016"]
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var appointments: [[String: Any]]?
    let formatter = DateFormatter()
    let myFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Appointments"
        
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 290
            let menuButton = UIBarButtonItem(image: UIImage(named: "menu.png"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            self.navigationItem.leftBarButtonItem = menuButton
            
        }
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        self.refreshControl = refresh
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        getAppointments()
    }
    
    func pullToRefresh() {
        getAppointments()
    }
    
    func getAppointments() {
        NetworkManager.sharedManager.getAppointments(token: appdelegate.token!, onSuccess: { (appts) in
                //Handle new appointments
            self.appointments = appts
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }) { (errorDesc) in
            Utility.showAlert(withTitle: "Oops", withMessage: errorDesc, from: self, type: .error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as! AppointmentTableCell
        if let dateStr = appointments?[indexPath.row]["AppointmentTime"] as? String {
            let newDate = formatter.date(from: dateStr)
            myFormatter.dateFormat = "h:mm a"
            tableCell.timeLabel.text = myFormatter.string(from: newDate ?? Date())
            myFormatter.dateFormat = "MMM dd, yyyy"
            tableCell.dateLabel.text = myFormatter.string(from: newDate ?? Date())
        }
        
        return tableCell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = UILabel(frame: tableView.bounds)
        title.frame.size.height = 40
        title.font = UIFont(name: "Helvetica", size: 16)
        title.textColor = Utility.darkBlue
        title.text = "  Upcoming Appointments"
        return title
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    

}
