//
//  Utility.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 11/3/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit
import PMAlertController

enum BEStoryboardID: String {
    case dailyLog = "LogItemVC"
    case home = "HomeView"
    case appointments = "AppointmentView"
    case progress = "ProgressView"
    case notes = "NotesView"
    case addPhoto = "AddPhotoView"
    case game = "GameView"
    case changePassword = "ChangePasswordView"
}

enum BECellType: String {
    case textField = "Text"
    case textArea = "Area"
    case picker = "Picker"
    case bool = "Bool"
    case image = "Image"
}

enum BEAlertType {
    case alert
    case error
    case warning
    case time
}

class Utility {
    
    
    class var blueColor: UIColor {
        return UIColor(red: 30/255, green: 125/255, blue: 240/255, alpha: 1.0)
    }
    
    class var darkBlue: UIColor {
        return UIColor(red: 40/255, green: 40/255, blue: 70/255, alpha: 1.0)
    }
    
    class var bgBlue: UIColor {
        return UIColor(red: 45/255, green: 48/255, blue: 81/255, alpha: 1.0)
    }
    
    class var purpule: UIColor {
        return UIColor(red: 69/255, green: 47/255, blue: 79/255, alpha: 1.0)
    }
    
    class var lightGrey: UIColor {
        return UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
    }
    
    class var lightPurpule: UIColor {
        return UIColor(red: 140/255, green: 83/255, blue: 166/255, alpha: 1.0)
    }
    
    
    //Draws Image from a CAlayer
    class func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return outputImage!
    }
    
    
    //Alert
    class func showAlert(withTitle title: String?, withMessage message: String, from viewController: UIViewController, type: BEAlertType) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        viewController.present(alert, animated: true, completion: nil)
        var image = UIImage(named: "emily.png")
        if type == .error {
            image = UIImage(named: "error.png")
        }else if type == .time {
            image = UIImage(named: "nodates.png")
        }else if type == .warning {
            image = UIImage(named: "warning.png")
        }
        let alert = PMAlertController(title: title ?? " ", description: message, image: image, style: .alert)
        alert.addAction(PMAlertAction(title: "Ok", style: .default))
        viewController.present(alert, animated: true, completion: nil)
        
    }
    
    class func getTopMostVC() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    class func addSlideMenu(for viewController: UIViewController) {
        if viewController.revealViewController() != nil {
            viewController.view.addGestureRecognizer(viewController.revealViewController().panGestureRecognizer())
            viewController.revealViewController().rearViewRevealWidth = 290
            let menuButton = UIBarButtonItem(image: UIImage(named: "menu.png"), style: .plain, target: viewController.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            viewController.navigationItem.leftBarButtonItem = menuButton
            
        }
    }
    
    class func getDate(fromString str: String?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        if let date = dateFormatter.date(from: str ?? " ") {
            dateFormatter.dateFormat = "hh: mm a"
            return dateFormatter.string(from: date)
        }else {
            return nil
        }
    }
    
    class func getTime(fromDate: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: fromDate) {
            dateFormatter.dateFormat = "hh: mm a"
            return dateFormatter.string(from: date)
        }else {
            return nil
        }
    }
    
    class func getAccessKey(from urlString: String) -> String? {
        let range = urlString.range(of: "(?<=com/)[^?]+(?= ?)", options: .regularExpression, range: nil, locale: nil)
        if range != nil {
            return urlString.substring(with: range!)
        }
        return nil
    }
}

//MARK: - Protocols & Delegates


protocol PickerSelectedDelegate {
    func didSelectPickerValue(forCell cell: Int, selectedValue: Any)
}

protocol AreaFieldReturnsDelegate {
    func didEnterValue(forCell cell: Int, fieldValue: String)
}

protocol ImagePickerDelegate {
    func didPickImage(image: UIImage)
}

protocol NotesUpdatedDelegate {
    func didUpdateNotes(note: User, at position: Int)
}
extension Bool {
    func getRaw() -> Int {
        if self {
            return 1
        }
        return 0
    }
}

