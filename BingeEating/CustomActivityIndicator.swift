//
//  CustomActivityIndicator.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 12/5/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit
import QuartzCore

class CustomActivityIndicator: UIView {
    
    // MARK - Variables
    
    lazy private var animationLayer : CALayer = {
        return CALayer()
    }()
    
    var isAnimating : Bool = false
    var hidesWhenStopped : Bool = true
    
    // MARK - Init
    
    init(image : UIImage) {
        let frame : CGRect = CGRect(x: 0.0, y: 0.0, width: 50, height: 50)
        super.init(frame: frame)
        
        animationLayer.frame = frame
        animationLayer.contents = image.cgImage
        animationLayer.masksToBounds = true
        
//        self.backgroundColor = Utility.lightGrey
        self.layer.addSublayer(animationLayer)
        
        addRotation(forLayer: animationLayer)
        pause(layer: animationLayer)
        self.isHidden = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - Func
    
    func addRotation(forLayer layer : CALayer) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        
        rotation.duration = 1.0
        rotation.isRemovedOnCompletion = false
        rotation.repeatCount = HUGE
        rotation.fillMode = kCAFillModeForwards
        rotation.fromValue = NSNumber(value: 0.0)
        rotation.toValue = NSNumber(value: 3.14 * 2.0)
        
        layer.add(rotation, forKey: "rotate")
    }
    
    func pause(layer : CALayer) {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        
        layer.speed = 0.0
        layer.timeOffset = pausedTime
        
        isAnimating = false
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func resume(layer : CALayer) {
        let pausedTime : CFTimeInterval = layer.timeOffset
        
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
        
        isAnimating = true
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func startAnimating () {
        
        if isAnimating {
            return
        }else {
            UIApplication.shared.keyWindow?.addSubview(self)
            self.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        }
        
        if hidesWhenStopped {
            self.isHidden = false
        }
        resume(layer: animationLayer)
    }
    
    func stopAnimating () {
        if hidesWhenStopped {
            self.isHidden = true
            self.removeFromSuperview()
        }
        pause(layer: animationLayer)
    }
}
