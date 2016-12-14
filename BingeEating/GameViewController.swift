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
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var questions = [Question]()
    var index: Int = 0
    var score: Int = 0
    
    lazy private var actitvityIndicator: CustomActivityIndicator = {
        return CustomActivityIndicator(image: UIImage(named: "Spinner.png")!)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.addSlideMenu(for: self)
        self.title = "Trivia Game"
        
        progressBar.delegate = self
        progressBar.backgroundColor = Utility.lightGrey
        progressBar.isUserInteractionEnabled = false
        progressBar.currentIndex = -1
        progressBar.numberOfPoints = 5
        
        questionLabel.clipsToBounds = true
        questionLabel.layer.cornerRadius = 8
        optionsTableView.backgroundColor = UIColor.clear
        optionsTableView.separatorStyle = .none
        optionsTableView.register(UINib(nibName: "OptionsTableViewCell", bundle: nil), forCellReuseIdentifier: "optionsCell")
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "scores.png"), style: .done, target: self, action: #selector(self.launchSocreView))
        self.getQuestions()
    }
    
    func getQuestions() {
        if appdelegate.token != nil {
            NetworkManager.sharedManager.getTriviaQuestions(token: appdelegate.token!, onSuccess: { (list) in
                self.questions = list
                self.loadQuestion()
            }, onError: { (errDesc) in

                Utility.showAlert(withTitle: "Oops", withMessage: errDesc, from: self, type: .error)
            })
        }
    }
    
    func loadQuestion() {
        if questions.count > 0 && index < questions.count {
            self.questionLabel.text =  self.questions[index].question
            self.optionsTableView.reloadData()
        }else {
            //Update score & load scores view
            self.launchSocreView()
        }
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
        return questions.count > 0 ? questions[index].options.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionsCell", for: indexPath) as! OptionsTableViewCell
        cell.optionLabel.text = questions[index].options[indexPath.row]
        cell.optionLabel.backgroundColor = Utility.bgBlue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! OptionsTableViewCell
        currentCell.optionLabel.backgroundColor = Utility.lightPurpule
        /*if selectedCell != nil {
            let selcell = tableView.cellForRow(at: selectedCell!) as! OptionsTableViewCell
            selcell.optionLabel.backgroundColor = Utility.bgBlue
        }
        selectedCell = indexPath */
        if indexPath.row == questions[index].answer {
            Utility.showAlert(withTitle: "Yay", withMessage: "Correct answer! you got 10 points.", from: self, type: .alert)
            self.score += 10
        }else {
            Utility.showAlert(withTitle: "Oops", withMessage: "The correct answer is \(questions[index].options[questions[index].answer])", from: self, type: .error)
        }
        index += 1
        progressBar.currentIndex += 1
        loadQuestion()
    }
    
    //MARK: - Progressbar delegate
    func progressBar(_ progressBar: ABSteppedProgressBar, textAtIndex index: Int) -> String {
        return String(index+1)
    }

}
