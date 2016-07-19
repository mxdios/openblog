//
//  XDSetBgColorBtn.swift
//  openblog
//
//  Created by inspiry on 15/12/24.
//  Copyright © 2015年 inspiry. All rights reserved.
//

import UIKit

class XDSetBgColorBtn: UIButton {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func setBackgroundColor(backgroundColor:UIColor, state:UIControlState) {
        self.setBackgroundImage(XDImageWithColor(backgroundColor, size: self.size), forState:state)
    }
   
}
