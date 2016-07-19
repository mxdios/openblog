//
//  OBTextField.swift
//  openblog
//
//  Created by inspiry on 15/12/24.
//  Copyright © 2015年 inspiry. All rights reserved.
//

import UIKit

class OBTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        self.leftView = view
        self.leftViewMode = UITextFieldViewMode.Always
        self.clearButtonMode = UITextFieldViewMode.WhileEditing
        self.font = XDFont(15)
        self.textColor = keyGreen
        self.layer.borderColor = keyGreen.CGColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 4
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setValue(keyGreen, forKeyPath: "_placeholderLabel.textColor")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}
