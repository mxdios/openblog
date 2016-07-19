//
//  XDRebulidView.swift
//  openblog
//
//  Created by inspiry on 16/1/4.
//  Copyright © 2016年 inspiry. All rights reserved.
//

import UIKit

protocol XDRebulidViewDelegate {
    func rebulidLoadData()
}

class XDRebulidView: UIView {

    var delegate:XDRebulidViewDelegate?
    var rebulidBtn:UIButton?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        rebulidBtn = UIButton(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        rebulidBtn?.setTitle("加载失败,触摸重新加载", forState: .Normal)
        rebulidBtn?.titleLabel?.font = XDFont(20)
        rebulidBtn?.setTitleColor(keyGreen, forState: .Normal)
        rebulidBtn?.setTitleColor(keyAlphaGreen, forState: .Highlighted)
        rebulidBtn?.backgroundColor = UIColor.clearColor()
        rebulidBtn?.addTarget(self, action: Selector("rebulidBtnClick"), forControlEvents: .TouchUpInside)
        self.addSubview(rebulidBtn!)
    }

    func rebulidBtnClick() {
        print("重新加载")
        delegate?.rebulidLoadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        delegate = nil
    }
}
