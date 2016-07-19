//
//  OBTextView.swift
//  openblog
//
//  Created by inspiry on 15/12/31.
//  Copyright © 2015年 inspiry. All rights reserved.
//

import UIKit

class OBTextView: UITextView {

    var plaveLabel:UILabel?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        plaveLabel = UILabel(frame: CGRect(x: 10, y: 10, width: self.width, height: 15))
        plaveLabel?.font = self.font
        plaveLabel?.textColor = UIColor.lightGrayColor()
        self.addSubview(plaveLabel!)
        self.layer.cornerRadius = 4
        self.layer.borderColor = keyGreen.CGColor
        self.layer.borderWidth = 2
        self.returnKeyType = UIReturnKeyType.Send
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("textViewChange"), name: UITextViewTextDidChangeNotification, object: self)
        
    }
    var plaveStr:String? {
        didSet {
            plaveLabel?.text = plaveStr
            textViewChange()
        }
    }
    
    func textViewChange() {
        if self.text.characters.count == 0 {
            plaveLabel?.hidden = false
        } else {
            plaveLabel?.hidden = true
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
