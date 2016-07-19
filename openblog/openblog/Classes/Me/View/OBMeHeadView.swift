//
//  OBMeHeadView.swift
//  openblog
//
//  Created by inspiry on 15/12/24.
//  Copyright © 2015年 inspiry. All rights reserved.
//

import UIKit

protocol headViewDelegate {
    
    func goLoginDelegate()
}

class OBMeHeadView: UIView {

    var delegate:headViewDelegate?
    
    var _userNameLabel:UILabel?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = keyGreen

        setupSelfView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    
    func setupSelfView() {
        _userNameLabel = UILabel()
        _userNameLabel?.textColor = UIColor.blackColor()
        _userNameLabel?.font = XDFont(20)
        _userNameLabel?.textColor = UIColor.whiteColor()
        _userNameLabel?.userInteractionEnabled = true
        self.addSubview(_userNameLabel!)
        
        let tap1 = UITapGestureRecognizer(target: self, action: Selector("loginTap"))
        _userNameLabel?.addGestureRecognizer(tap1)
        
    }
    
    func loginTap(){
        print("点击")
        self.delegate?.goLoginDelegate()
        
    }
    var userName:String? {
        didSet {
            _userNameLabel?.text = userName
            _userNameLabel?.sizeToFit()
            _userNameLabel?.centerX = self.width * 0.5
            _userNameLabel?.centerY = self.height * 0.5
            
        }
    }
    deinit{
        self.delegate = nil
    }
}
