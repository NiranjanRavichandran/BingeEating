//
//  GameViewController.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 12/13/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, ABSteppedProgressBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressBar: ABSteppedProgressBar!
    @IBOutlet weak var optionsTableView: UITableView!
    
    var selectedCell: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.addSlideMenu(for: self)
        self.title = "Trivia Game"
        
        progressBar.delegate = self
        progressBar.backgroundColor = Utility.lightGrey
        progressBar.isUserInteractionEnabled = false
        
        questionLabel.clipsToBounds = true
        questionLabel.layer.cornerRadius = 8
        optionsTableView.backgroundColor = UIColor.clear
        optionsTableView.separatorStyle = .none
        optionsTableView.register(UINib(nibName: "OptionsTableViewCell", bundle: nil), forCellReuseIdentifier: "optionsCell")
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "scores.png"), style: .done, target: self, action: #selector(self.launchSocreView))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func launchSocreView() {
        self.show(ScoresTableViewController(), sender: self)
    }
    
    //MARK: - TableView Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionsCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! OptionsTableViewCell
        currentCell.optionLabel.backgroundColor = Utility.lightPurpule
        if selectedCell != nil {
            let selcell = tableView.cellForRow(at: selectedCell!) as! OptionsTableViewCell
            selcell.optionLabel.backgroundColor = Utility.bgBlue
        }
        selectedCell = indexPath
        progressBar.currentIndex += 1
    }
    
    //MARK: - Progressbar delegate
    func progressBar(_ progressBar: ABSteppedProgressBar, textAtIndex index: Int) -> String {
        return String(index+1)
    }

}
