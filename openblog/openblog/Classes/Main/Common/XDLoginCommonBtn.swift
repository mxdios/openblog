//
//  XDLoginCommonBtn.swift
//  openblog
//
//  Created by inspiry on 15/12/30.
//  Copyright © 2015年 inspiry. All rights reserved.
//

import UIKit

class XDLoginCommonBtn: XDSetBgColorBtn {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setBackgroundColor(keyGreen, state: .Normal)
        self.setBackgroundColor(keyAlphaGreen, state: .Highlighted)
        self.setTitleColor(XDAlpColor(255, g: 255, b: 255, a: 1.0), forState: .Normal)
        self.setTitleColor(XDAlpColor(255, g: 255, b: 255, a: 0.5), forState: .Highlighted)
        self.titleLabel?.font = XDFont(16)
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
        
    }

}
