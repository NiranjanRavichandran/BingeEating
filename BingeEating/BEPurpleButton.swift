//
//  BEPurpleself.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 12/1/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class BEPurpleButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        setTitleColor(UIColor.lightGray, for: .highlighted)
        backgroundColor = Utility.lightPurpule
        setTitleColor(UIColor.white, for: .normal)
        layer.cornerRadius = self.frame.height / 2
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 1, height: 3)
    }

}
