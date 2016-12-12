//
//  BETextfield.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 11/3/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

//@IBDesignable
class BETextfield: UITextField {


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    func configure() {
        
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 1
        self.layer.borderColor = Utility.lightPurpule.cgColor
    }
    

}
