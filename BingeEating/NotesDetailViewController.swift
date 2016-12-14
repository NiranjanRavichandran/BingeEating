//
//  NotesDetailViewController.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 12/11/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class NotesDetailViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate {
    
    var notesObject: User?
    var notesView: UITextView!
    var noteIndex: Int?
    var notesDelegate: NotesUpdatedDelegate?
    let appdelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        notesView = UITextView(frame: UIScreen.main.bounds)
        notesView.backgroundColor = Utility.lightGrey
        notesView.text = notesObject?.notes
        notesView.font = UIFont(name: "Helvetica", size: 20)
        notesView.delegate = self
        self.view.addSubview(notesView)
        notesView.translatesAutoresizingMaskIntoConstraints
            = false
        view.addConstraint(NSLayoutConstraint(item: notesView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: notesView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        
        var visibleImage = UIImage(named: "Invisible.png")
        if notesObject?.isNotesVisible ?? false {
            visibleImage = UIImage(named: "Visible.png")
        }
        let isVisibleButton = UIBarButtonItem(image: visibleImage, style: .done, target: self, action: #selector(self.markVisible(sender:)))
//        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.saveNotesToServer))
        self.navigationItem.rightBarButtonItems = [isVisibleButton]
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeHandler))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    func markVisible(sender: UIBarButtonItem) {
        if notesObject?.isNotesVisible ?? false {
            notesObject!.isNotesVisible = false
            sender.image = UIImage(named: "Invisible.png")
            Utility.showAlert(withTitle: "Alert", withMessage: "This note is now hidden from your supporter. Only you can view it.", from: self, type: .alert)
        }else {
            notesObject!.isNotesVisible = true
            sender.image = UIImage(named: "Visible.png")
            Utility.showAlert(withTitle: "Alert", withMessage: "This note is now made visible to your supporter.", from: self, type: .alert)
        }
    }
    
    func saveNotesToServer() {
        notesObject?.notes = notesView.text
        notesView.resignFirstResponder()
        if appdelegate.token != nil {
            NetworkManager.sharedManager.updateNotes(token: appdelegate.token!, note: notesObject!, success: { (status) in
                if status {
                    print("Notes updated")
                }
            }, onError: { (errDesc) in
                Utility.showAlert(withTitle: "Oops", withMessage: errDesc, from: self, type: .error)
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        saveNotesToServer()
        notesDelegate?.didUpdateNotes(note: notesObject!, at: noteIndex!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        self.notesView.frame = self.view.bounds
        self.notesView.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        notesObject?.notes = notesView.text
        return true
    }
    
    func swipeHandler() {
        notesView.resignFirstResponder()
    }

}
