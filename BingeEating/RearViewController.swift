//
//  RearViewController.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 11/3/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class RearViewController: UITableViewController {
    
    let menuItems = ["Home", "Daily Log", "Weekly Log", "Appointments", "My Progress", "Notes", "Games", "Logout"]
    var selectedIndexPath: IndexPath?
    var currentVC: UIViewController?
    var selectedcellView: UIView!
    let appdelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.separatorStyle = .none
        self.view.backgroundColor = Utility.lightGrey
        selectedcellView = UIView(frame: tableView.bounds)
        selectedcellView.backgroundColor = UIColor.white
        selectedcellView.tintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.imageView?.image = UIImage(named: menuItems[indexPath.row])
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.backgroundColor = Utility.lightGrey
        cell.selectedBackgroundView = selectedcellView
        cell.selectedBackgroundView?.tintColor = UIColor.white
        cell.textLabel?.textColor = UIColor.darkGray
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var newFrontView: UIViewController?
        if selectedIndexPath == indexPath {
            newFrontView = currentVC
        }else {
            if indexPath.row == 0 {
             let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: BEStoryboardID.home.rawValue) as? HomeViewController
                newFrontView = homeVC
            }else if indexPath.row == 1 {

                let logVC = LogSummaryViewController()
                newFrontView = logVC
                
            }else if indexPath.row == 2 {
                newFrontView = WeeklyListTableViewController()
            }else if indexPath.row == 3 {
                
                let apptVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: BEStoryboardID.appointments.rawValue) as?AppoinmentsTableViewController
                newFrontView = apptVC
                
            }else if indexPath.row == 4 {
                let progressVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: BEStoryboardID.progress.rawValue) as? ProgressViewController
                newFrontView = progressVc
            }else if indexPath.row == 5 {
                //Show Notes View
                newFrontView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: BEStoryboardID.notes.rawValue) as? NotesViewController
                
            }else if indexPath.row == 7{
                //Call Logout
                self.logoutUser()
            }
        }
        
        if newFrontView != nil {
            currentVC = newFrontView
            revealViewController().pushFrontViewController(UINavigationController(rootViewController: newFrontView!), animated: true)
        }
        selectedIndexPath = indexPath
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func logoutUser() {
        self.appdelegate.token = nil
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

}
