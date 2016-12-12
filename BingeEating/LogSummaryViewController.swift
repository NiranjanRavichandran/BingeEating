//
//  LogSummaryViewController.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 11/10/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class LogSummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CAAnimationDelegate {
    
    var tableView: UITableView!
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var addButton: UIButton!
    let transition = PopAnimator()
    
    var isQuickLog = false
    var mask: CALayer!
    var launchAnimation: CABasicAnimation!
    var maskView: UIView!
    
    var isPreviousLogs: Bool = false
    var previousLogs: [DailyLogItem]?
    var prevPhyLogs: [PhysicalLogItem]?
    var dateOfLogs: String?
    
    lazy private var actitvityIndicator: CustomActivityIndicator = {
        return CustomActivityIndicator(image: UIImage(named: "Spinner.png")!)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Utility.lightGrey
        
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.backgroundColor = UIColor.white
//        tableView.separatorStyle = .none
        tableView.separatorColor = Utility.lightGrey
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "PhysicalItemTableCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        self.view.addSubview(self.tableView)

        if !isPreviousLogs {
            //Adding slide menu
            Utility.addSlideMenu(for: self)
            //Adding view logs button
            self.addViewLogsButton()
            self.title = "Today's Logs"
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.dateOfLogs = formatter.string(from: Date())
            self.fetchTodaysLogs()
        }else {
            self.title = "Previous Logs"
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dismissCurrentView))
        }
        self.fetchPhyLogs()
        
        if isQuickLog {
            self.tableView.alpha = 0
            maskView = UIView(frame: UIScreen.main.bounds)
            maskView.backgroundColor = Utility.lightPurpule
            self.view.addSubview(maskView)
            
            mask = CALayer()
            mask.backgroundColor = UIColor.white.cgColor
            mask.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            mask.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
            mask.cornerRadius = 150
            mask.position = CGPoint(x: self.view.bounds.width - 50, y: self.view.bounds.height - 50)
            self.maskView.layer.mask = mask
            
            //Launch animation
            animateIncreaseSize()
        }else {
            self.tableView.alpha = 1
        }
        
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Send.png"), style: .done, target: self, action: #selector(self.submitDailyLogToServer))
        
    }
    
    func fetchPhyLogs() {
        if appdelegate.token != nil {
        NetworkManager.sharedManager.getPhyLogs(token: appdelegate.token!, date: dateOfLogs ?? " ", onSuccess: { (phyLogs) in
            if phyLogs.count > 0 {
                if self.isPreviousLogs {
                    self.prevPhyLogs = phyLogs
                }else {
                    self.appdelegate.physicalActItem = phyLogs
                }
                self.tableView.reloadSections([1], with: .fade)
            }
        }, onError: { (errorDesc) in
            Utility.showAlert(withTitle: "Oops", withMessage: errorDesc, from: self, type: .error)
        })
        }
    }
    
    func fetchTodaysLogs() {
        if appdelegate.token != nil {
            NetworkManager.sharedManager.getDailyLog(token: appdelegate.token!, forDate: self.dateOfLogs!, onSuccess: { (logs) in
                self.appdelegate.dailyLogItems = logs
                self.tableView.reloadSections([0], with: .fade)
            }, onError: { (errDesc) in
                Utility.showAlert(withTitle: "Oops", withMessage: errDesc, from: self, type: .error)
            })
        }
    }
    
    func addViewLogsButton() {
        let buttonView = UIView(frame: self.view.bounds)
        buttonView.backgroundColor = UIColor.clear
        let button = BEPurpleButton(frame: CGRect(x: 0, y: 0, width: 200, height: 35))
        button.setTitle("View Previous Logs", for: .normal)
        button.center.x = buttonView.center.x
        button.center.y = buttonView.frame.height - 100
        button.addTarget(self, action: #selector(self.showLogs), for: .touchUpInside)
        button.layer.masksToBounds = false
        button.addShadow()
        tableView.addSubview(button)
        buttonView.isUserInteractionEnabled = false
        self.view.addSubview(buttonView)
    }
    
    func showLogs() {
        //Push view to show logs
        self.show(DailyLogViewController(), sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func dismissCurrentView() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPreviousLogs {
            if section == 0 {
                return previousLogs?.count ?? 0
            }
            return prevPhyLogs?.count ?? 0
        }else {
            if section == 0 {
                return appdelegate.dailyLogItems?.count ?? 0
            }
            return appdelegate.physicalActItem?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! PhysicalItemTableCell
        if indexPath.section == 0 {
            let dailyLogItem: DailyLogItem? = isPreviousLogs ? previousLogs?[indexPath.row] : appdelegate.dailyLogItems?[indexPath.row]
            tableCell.foodItemLabel.text = dailyLogItem?.foodAndDrink
            tableCell.timeLabel.text = Utility.getTime(fromDate: dailyLogItem?.eatTime ?? " ") ?? Utility.getDate(fromString: dailyLogItem?.eatTime)
        }else {
            let phyLogItem = isPreviousLogs ? prevPhyLogs?[indexPath.row] : appdelegate.physicalActItem?[indexPath.row]
            tableCell.foodItemLabel.text = phyLogItem?.typeOfActivity
            tableCell.timeLabel.text = String(describing: phyLogItem?.duration ?? 0) + " Minutes"
        }
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: tableView.bounds)
        headerView.frame.size.height = 45
        headerView.backgroundColor = Utility.lightGrey
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width - 50, height: 45))
        titleLabel.font = UIFont(name: "Helvetica", size: 15)
        titleLabel.textColor = Utility.darkBlue
        let addButton = UIButton(frame: CGRect(x: tableView.frame.width - 50, y: 5, width: 35, height: 35))
        addButton.setImage(UIImage(named: "Add.png"), for: .normal)
        headerView.addSubview(titleLabel)
        headerView.addSubview(addButton)
        if section == 0 {
            addButton.tag = 500
            titleLabel.text = "  Food and Drink Consumed"
        }else {
            addButton.tag = 501
            titleLabel.text = "  Physical Activity"
        }
        addButton.addTarget(self, action: #selector(self.addNewItem(sender:)), for: .touchUpInside)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    //MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let editLogVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: BEStoryboardID.dailyLog.rawValue) as! LogItemTableViewController
            editLogVC.isLogEditing = true
            editLogVC.newLogItem = isPreviousLogs ? previousLogs![indexPath.row] : appdelegate.dailyLogItems![indexPath.row]
            self.present(UINavigationController(rootViewController: editLogVC), animated: true, completion: nil)
        }else {
            let editPhyLog = PhysicalActivityViewController()
            editPhyLog.isEditLog = true
            editPhyLog.logIndex = indexPath.row
            editPhyLog.newActitvityItem = isPreviousLogs ? prevPhyLogs![indexPath.row] : appdelegate.physicalActItem![indexPath.row]
            self.present(UINavigationController(rootViewController: editPhyLog), animated: true, completion: nil)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                self.appdelegate.dailyLogItems?.remove(at: indexPath.row)
            }else {
                self.appdelegate.physicalActItem?.remove(at: indexPath.row)
            }
            self.tableView.reloadData()
        }
    }
    //MARK: - Helper functions
    
    func addNewItem(sender: UIButton) {
        addButton = sender
        var presentVC: UINavigationController!
        if sender.tag == 500 {
            let logVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: BEStoryboardID.dailyLog.rawValue) as! LogItemTableViewController
            //Delegate for custom transition animation
            presentVC = UINavigationController(rootViewController: logVC)
        }else {
            presentVC = UINavigationController(rootViewController: PhysicalActivityViewController())
        }
          presentVC.transitioningDelegate = self
        self.present(presentVC, animated: true, completion: nil)
    }
    
    //******* Implementation not used *********
//    func submitDailyLogToServer(){
//        if appdelegate.dailyLogItems?.count == nil {
//            Utility.showAlert(withTitle: "Error", withMessage: "Please add an activity to log", from: self, type: .error)
//        }else {
//            if appdelegate.token == nil {
//                //Call logout here
//            }else {
//                
//                //Post to server
//                actitvityIndicator.startAnimating()
//                
//                NetworkManager.sharedManager.postDailyLog(token: appdelegate.token!, dailylogItem: appdelegate.dailyLogItems!.first, onSuccess: {
//                    //Hanlde success
//                    self.actitvityIndicator.stopAnimating()
//                }, onError: { (errorDesc) in
//                    self.actitvityIndicator.stopAnimating()
//                    Utility.showAlert(withTitle: "Oops!", withMessage: errorDesc, from: self, type: .error)
//                })
//            }
//        }
//    }
//    
    func activtiyLogSuccess() {
        let alert = UIAlertController(title: "Success", message: "Your activity was logged", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: BEStoryboardID.home.rawValue) as? HomeViewController
            self.revealViewController().pushFrontViewController(UINavigationController(rootViewController: homeVC!), animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        self.tableView.frame = self.view.bounds
    }
    
    func animateIncreaseSize() {
        
        launchAnimation = CABasicAnimation(keyPath: "bounds")
        launchAnimation.duration = 1
        
        launchAnimation.fromValue = NSValue(cgRect: mask.bounds)
        launchAnimation.toValue = NSValue(cgRect: CGRect(x: mask.frame.origin.x, y: mask.frame.origin.y, width: 4000, height: 4000))
        
        launchAnimation.fillMode = kCAFillModeForwards
        launchAnimation.isRemovedOnCompletion = false
        
        mask.add(launchAnimation, forKey: "bounds")
        
        //Removing overlayview after animation
        UIView.animate(withDuration: 1.0, animations: {
            self.maskView.alpha = 0
            self.tableView.alpha = 1
        }) { _ in
            self.maskView.removeFromSuperview()
        }
    }
    
    //MARK: - CAAnimation delegate
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        if flag {
            animateIncreaseSize()
        }
    }
}

extension LogSummaryViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = addButton.superview!.convert(addButton.frame, to: nil)
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
    
    
}
