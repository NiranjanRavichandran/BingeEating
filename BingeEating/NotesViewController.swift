//
//  NotesViewController.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 12/1/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate {

    @IBOutlet weak var notesTableView: UITableView!
    var segmentControl: UISegmentedControl!
    var webView: UIWebView!
    var userNotes: [User]?
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    var refreshControl: UIRefreshControl!
    
    lazy private var actitvityIndicator: CustomActivityIndicator = {
        return CustomActivityIndicator(image: UIImage(named: "Spinner.png")!)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Notes & Manual"
        segmentControl = UISegmentedControl(items: ["Notes", "Manual"])
        segmentControl.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        segmentControl.layer.borderWidth = 0
        segmentControl.backgroundColor = Utility.lightPurpule
        segmentControl.tintColor = Utility.lightGrey
        segmentControl.selectedSegmentIndex = -1
        segmentControl.selectedSegmentIndex = 0
//        segmentControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentControl.addTarget(self, action: #selector(self.segmentValueChanged), for: .valueChanged)
        
        self.navigationItem.titleView = segmentControl
        
        Utility.addSlideMenu(for: self)
        notesTableView.delegate = self
        notesTableView.dataSource = self
        notesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        webView = UIWebView(frame: notesTableView.frame)
        webView.delegate = self
        
        self.getUserNotes()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh Notes", attributes: [NSForegroundColorAttributeName: Utility.bgBlue])
        refreshControl.tintColor = UIColor.lightGray
        refreshControl.addTarget(self, action: #selector(self.getUserNotes), for: .valueChanged)
        self.notesTableView.addSubview(refreshControl)
    }
    
    func segmentValueChanged() {
        actitvityIndicator.startAnimating()
        if segmentControl.selectedSegmentIndex == 0 {
            //Notes view
            self.webView.alpha = 0
            self.notesTableView.alpha = 1
            actitvityIndicator.stopAnimating()
        }else {
            //Load webview
            self.notesTableView.alpha = 0
            self.webView.alpha = 1
            self.view.addSubview(webView)
            self.loadurlOnWebView()
        }
    }
    
    func loadurlOnWebView() {
        if let url = URL(string: "http://amad-whs.s3-us-west-2.amazonaws.com/manual.pdf") {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserNotes() {
        if appdelegate.token != nil {
            NetworkManager.sharedManager.getNotes(token: appdelegate.token!, onSuccess: { (notes) in
                if notes.count > 0 {
                    self.userNotes = notes
                    self.notesTableView.reloadData()
                }
                self.refreshControl?.endRefreshing()
            }, onError: { (errDesc) in
                self.refreshControl?.endRefreshing()
                Utility.showAlert(withTitle: "Oops", withMessage: errDesc, from: self, type: .error)
            })
        }
    }
    
    //MARK: - TableView Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNotes?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if userNotes == nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "You have no notes yet."
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = userNotes?[indexPath.row].notes
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .default
        return cell
    }
    
    //MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notesDetailVC = NotesDetailViewController()
        notesDetailVC.notesObject = self.userNotes?[indexPath.row]
        self.show(notesDetailVC, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - WebView Delegate
    func webViewDidFinishLoad(_ webView: UIWebView) {
        actitvityIndicator.stopAnimating()
    }
}
