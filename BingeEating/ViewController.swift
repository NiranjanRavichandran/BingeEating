//
//  ViewController.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 11/3/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var qrCodeButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 6
        loginButton.addTarget(self, action: #selector(self.loginAction), for: .touchUpInside)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        qrCodeButton.addTarget(self, action: #selector(self.launchQRReaderView), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func loginAction() {
        
        NetworkManager.sharedManager.loginWithUsername(username: "P113", passowrd: "5OQOYlwEln", onSuccess: { token in
            self.appdelegate.token = token
            let homeVC = UINavigationController(rootViewController: self.storyboard?.instantiateViewController(withIdentifier: BEStoryboardID.home.rawValue) as! HomeViewController)
            let rearVc = UINavigationController(rootViewController: RearViewController())
            let revealViewController = SWRevealViewController(rearViewController: rearVc, frontViewController: homeVC)
            self.present(revealViewController!, animated: true, completion: nil)

            
        }, onError: { errorMessage in
            
            print("###", errorMessage)
            
        })
    
    }
    
    func launchQRReaderView() {
        self.present(UINavigationController(rootViewController: QRCodeViewController()), animated: true, completion: nil)
    }
}

