//
//  QuestionLabel.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 11/3/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class QuestionLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    func configure() {
        self.layer.cornerRadius = self.frame.height/2
        self.backgroundColor = Utility.darkBlue
        self.textColor = UIColor.white
    }

}
