//
//  BECommonField.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 12/4/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class BECommonField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    func config() {
        let paddingView  = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

}
