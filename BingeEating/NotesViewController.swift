//
//  NotesViewController.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 12/1/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, NotesUpdatedDelegate {

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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addNewNote))
    }
    
    func addNewNote() {
        let newNote = User()
        userNotes?.insert(newNote, at: 0)
        self.notesTableView.reloadData()
        if appdelegate.token != nil {
            NetworkManager.sharedManager.addNotes(token: appdelegate.token!, notes: newNote.notes, isVisible: newNote.isNotesVisible.getRaw(), success: { (status) in
                if status {
                    print("New Note added")
                }
            }, onError: { (errDesc) in
                Utility.showAlert(withTitle: "Oops", withMessage: errDesc, from: self, type: .error)
            })
        }
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
    
    func deleteNotes(note: User) {
        if appdelegate.token != nil {
        NetworkManager.sharedManager.deleteNotes(token: appdelegate.token!, note: note, success: { (status) in
            if status {
                print("Note was deleted!")
            }
        }, onError: { (errDesc) in
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
        notesDetailVC.noteIndex = indexPath.row
        notesDetailVC.notesObject = self.userNotes?[indexPath.row]
        notesDetailVC.notesDelegate = self
        self.show(notesDetailVC, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteNotes(note: userNotes![indexPath.row])
            userNotes?.remove(at: indexPath.row)
        }
        tableView.beginUpdates()
        notesTableView.deleteRows(at: [indexPath], with: .left)
        tableView.endUpdates()
    }
    
    //MARK: - WebView Delegate
    func webViewDidFinishLoad(_ webView: UIWebView) {
        actitvityIndicator.stopAnimating()
    }
    
    //MARK: - Notes delegate
    func didUpdateNotes(note: User, at position: Int) {
        self.userNotes?[position] = note
        self.notesTableView.reloadRows(at: [IndexPath(row: position, section: 0)], with: .fade)
    }
}
