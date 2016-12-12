//
//  HomeViewController.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 11/3/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var quickLog: UIButton!
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        characterImageView.alpha = 0
        messageLabel.alpha = 0
        
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 290
            let menuButton = UIBarButtonItem(image: UIImage(named: "menu.png"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            self.navigationItem.leftBarButtonItem = menuButton
            
        }
        messageLabel.layer.cornerRadius = 8
        messageLabel.clipsToBounds = true
        messageLabel.text = "Hey there!"
        self.fetchMessage()
        
        self.quickLog.addTarget(self, action: #selector(self.launchAddLogs), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        characterImageView.center.y -= 100
        messageLabel.center.y += 100
        
        UIView.animate(withDuration: 1.5, animations: {
            self.characterImageView.center.y += 100
            self.messageLabel.center.y -= 100
            self.characterImageView.alpha = 1
            self.messageLabel.alpha = 1
        })
    }
    
    func fetchMessage() {
        if let token = appdelegate.token {
            NetworkManager.sharedManager.getMessageFromServer(token: token, keyword: "good", onSuccess: { (message) in
                self.messageLabel.text = message
            }, onError: { (errorDesc) in
                print("##### Error")
            })
        }
    }
    
    func launchAddLogs() {
        let quickLogVc = LogSummaryViewController()
        quickLogVc.isQuickLog = true
        self.revealViewController().pushFrontViewController(UINavigationController(rootViewController: quickLogVc), animated: true)
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
