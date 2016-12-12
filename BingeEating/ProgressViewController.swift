//
//  ProgressViewController.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 11/10/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {

    @IBOutlet weak var progressView: MBCircularProgressBarView!
    
    @IBOutlet weak var stepLabel: UILabel!
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Progress"
        
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 290
            let menuButton = UIBarButtonItem(image: UIImage(named: "menu.png"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            self.navigationItem.leftBarButtonItem = menuButton
            
        }
        
        stepLabel.layer.cornerRadius = 22
        stepLabel.clipsToBounds = true
        
        self.getProgress()
    }
    
    func getProgress() {
        if appdelegate.token != nil {
            NetworkManager.sharedManager.getUserProgress(token: appdelegate.token!, onSuccess: { (progressValue) in
                UIView.animate(withDuration: 1.0, animations: { 
                    self.progressView.value = CGFloat(progressValue)
                })
            }, onError: { (errorDesc) in
                print("@@@", errorDesc)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
