//
//  ScoresTableViewController.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 12/13/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class ScoresTableViewController: UITableViewController {
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var scores = [Int]()
    
    lazy private var actitvityIndicator: CustomActivityIndicator = {
        return CustomActivityIndicator(image: UIImage(named: "Spinner.png")!)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Leaderboards"
        tableView.register(UINib(nibName: "ScoresTableCell", bundle: nil), forCellReuseIdentifier: "scoreCell")
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let confettiView = ConfettiView(frame: self.view.bounds)
        self.view.addSubview(confettiView)
        confettiView.startConfetti()
        self.getAllScores()
        actitvityIndicator.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAllScores() {
        if appdelegate.token != nil {
            NetworkManager.sharedManager.getAllScore(token: appdelegate.token!, onSuccess: { (socreList) in
                self.scores = socreList.sorted(by: >)
                self.tableView.reloadData()
                self.actitvityIndicator.stopAnimating()
            }, onError: { (errDesc) in
                self.actitvityIndicator.stopAnimating()
                Utility.showAlert(withTitle: "Oops", withMessage: errDesc, from: self, type: .error)
            })
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath) as! ScoresTableCell
        cell.nameLabel.text = "User \(indexPath.row + 1)"
        cell.scoreLabel.text = "\(scores[indexPath.row])"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
 

}
