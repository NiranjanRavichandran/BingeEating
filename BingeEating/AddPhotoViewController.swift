//
//  AddPhotoViewController.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 11/10/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit
import PMAlertController

class AddPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    let picker = UIImagePickerController()
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var addPhotosButton: UIButton!
    
    var delegate: ImagePickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Utility.lightGrey
//        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
//        imageView.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
//        imageView.image = UIImage(named: "Add Image.png")
//        self.view.addSubview(imageView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dismissView))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveImage)) , UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(self.showLuanchOptions))]
        picker.delegate = self
    }
    
    func saveImage() {
        if imageView.image != nil {
            delegate?.didPickImage(image: imageView.image!)
        }
    }

    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showLuanchOptions() {
        let alert = PMAlertController(title: "", description: "Choose to add photo", image: UIImage(named: "Camera.png"), style: .alert)
        alert.addAction(PMAlertAction(title: "Camera", style: .default, action: { 
            self.picker.allowsEditing = false
            self.picker.sourceType = .camera
            alert.dismiss(animated: true, completion: { 
                self.present(self.picker, animated: true, completion: nil)
            })
        }))
        alert.addAction(PMAlertAction(title: "Photos", style: .default, action: { 
            self.picker.allowsEditing = true
            self.picker.sourceType = .photoLibrary
            alert.dismiss(animated: true, completion: {
                self.present(self.picker, animated: true, completion: nil)
            })
        }))
        alert.addAction(PMAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = imagePicked
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

}
