//
//  PopAnimator.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 12/3/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import Foundation

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration    = 0.5
    var presenting  = true
    var originFrame = CGRect.zero
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let presentingView = presenting ? toView : transitionContext.view(forKey: .from)!
        
        presentingView.layer.shadowColor = UIColor.darkGray.cgColor
        presentingView.layer.shadowOpacity = 1.0
        presentingView.layer.shadowRadius = 3
        presentingView.layer.shadowOffset = CGSize(width: 1, height: 3)
        presentingView.layer.masksToBounds = false
        
        let initialFrame = presenting ? originFrame : presentingView.frame
        let finalFrame = presenting ? presentingView.frame : originFrame
        
        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            presentingView.transform = scaleTransform
            presentingView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            presentingView.clipsToBounds = true
        }
        
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: presentingView)
        
        UIView.animate(withDuration: duration, delay: 0, options: [], animations: {
            presentingView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
            presentingView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }) { (_) in
            transitionContext.completeTransition(true)
        }
        
        let round = CABasicAnimation(keyPath: "cornerRadius")
        round.fromValue = presenting ? presentingView.frame.height/2 : 0.0
        round.toValue = presenting ? 0.0 : presentingView.frame.height/2
        round.duration = duration
        presentingView.layer.add(round, forKey: nil)
        presentingView.layer.cornerRadius = presenting ? 0.0 : 20.0/xScaleFactor
        
    }
}
