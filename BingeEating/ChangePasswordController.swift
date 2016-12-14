//
//  ChangePasswordController.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 12/13/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit
import PMAlertController

class ChangePasswordController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordField: BETextfield!
    @IBOutlet weak var updateButton: UIButton!
    
    lazy private var actitvityIndicator: CustomActivityIndicator = {
        return CustomActivityIndicator(image: UIImage(named: "Spinner.png")!)
    }()
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dismissview))
        self.updateButton.addTarget(self, action: #selector(self.updatePassword), for: .touchDown)
        self.updateButton.layer.cornerRadius = 6
        self.passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        self.passwordField.leftViewMode = .always
        self.passwordField.delegate = self
    }
    
    func dismissview() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func updatePassword() {
        if passwordField.text == "" {
            Utility.showAlert(withTitle: "Error", withMessage: "Please enter a valid password", from: self, type: .error)
            return 
        }
        actitvityIndicator.startAnimating()
        if appdelegate.token != nil {
            NetworkManager.sharedManager.changePassword(token: appdelegate.token!, with: passwordField.text!, success: { (user, token) in
                self.appdelegate.token = token
               self.actitvityIndicator.stopAnimating()
                let alert = PMAlertController(title: "For you to know", description: "Please remember your password for your username \(user.username!)", image: UIImage(named:"emily.png"), style: .alert)
                alert.addAction(PMAlertAction(title: "Got it", style: .default, action: {
                    alert.dismiss(animated: true, completion: { 
                        
                        self.lanuchHomeView()
                    })
                }))
                self.present(alert, animated: true, completion: nil)
            }, onError: { (errDesc) in
                self.actitvityIndicator.stopAnimating()
                Utility.showAlert(withTitle: "Oops", withMessage: errDesc, from: self, type: .error)
            })
        }
    }
    
    func lanuchHomeView() {
        let homeVC = UINavigationController(rootViewController: self.storyboard?.instantiateViewController(withIdentifier: BEStoryboardID.home.rawValue) as! HomeViewController)
        let rearVc = UINavigationController(rootViewController: RearViewController())
        let revealViewController = SWRevealViewController(rearViewController: rearVc, frontViewController: homeVC)
        self.present(revealViewController!, animated: true, completion: nil)
    }

}
