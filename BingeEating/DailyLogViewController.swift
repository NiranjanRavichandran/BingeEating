//
//  DailyLogViewController.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 11/10/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class DailyLogViewController: UIViewController, WWCalendarTimeSelectorProtocol {
    
    var dateButton: UIButton!
//    var selectedDate: String?
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    lazy private var actitvityIndicator: CustomActivityIndicator = {
        return CustomActivityIndicator(image: UIImage(named: "Spinner.png")!)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Utility.lightGrey
        
        let infoLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
        infoLabel.text = "Choose date to view logs"
        infoLabel.textColor = Utility.bgBlue.withAlphaComponent(0.7)
        infoLabel.center.x = self.view.center.x
        infoLabel.center.y = self.view.center.y - 120
        infoLabel.textAlignment = .center
        
        dateButton = BEPurpleButton(frame: CGRect(x: 0, y: 0, width: 160, height: 35))
        dateButton.setTitle("Choose date", for: .normal)
        dateButton.center = self.view.center
        dateButton.center.y -= 50
        dateButton.addTarget(self, action: #selector(self.showDatePicker), for: .touchUpInside)

        self.view.addSubview(dateButton)
        self.view.addSubview(infoLabel)
    }
    
    func showDatePicker() {
        let timeSelector = WWCalendarTimeSelector.instantiate()
        timeSelector.delegate = self
        timeSelector.optionStyles.showTime(false)
        timeSelector.optionTopPanelTitle = "Choose a date"
        self.present(timeSelector, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        if date > Date() {
            self.dismiss(animated: true, completion: { 
                Utility.showAlert(withTitle: "Alert", withMessage: "Please choose another date. You cannot view future logs.", from: self, type: .time)
            })
        }else {
            self.actitvityIndicator.startAnimating()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let selectedDate = formatter.string(from: date)
            
            let dispFormatter = DateFormatter()
            dispFormatter.dateFormat = "MMM dd, yyyy"
            let dispDate: String = dispFormatter.string(from: date)
            dateButton.setTitle(dispDate, for: .normal)
            if appdelegate.token != nil {
            NetworkManager.sharedManager.getDailyLog(token: appdelegate.token!, forDate: selectedDate, onSuccess: { (dailyLogs) in
                print("***", dailyLogs)
                self.actitvityIndicator.stopAnimating()
                let logSummary = LogSummaryViewController()
                logSummary.isPreviousLogs = true
                logSummary.previousLogs = dailyLogs
                logSummary.dateOfLogs = selectedDate
                self.present(UINavigationController(rootViewController: logSummary), animated: true, completion: nil)
                
            }, onError: { (errorDesc) in
                self.actitvityIndicator.stopAnimating()
                Utility.showAlert(withTitle: "Error", withMessage: errorDesc, from: self, type: .error)
            })
            }
        }
    }


}
