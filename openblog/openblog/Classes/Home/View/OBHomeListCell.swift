//
//  OBHomeListCell.swift
//  openblog
//
//  Created by inspiry on 15/12/31.
//  Copyright © 2015年 inspiry. All rights reserved.
//

import UIKit

protocol OBHomeListCellDelegate {
    func operateDelegate(btn:UIButton, index:Int)
}

class OBHomeListCell: UITableViewCell {
    
    var usernameLabel:UILabel?
    var contentLabel:UILabel?
//    var timeLabel:UILabel?
    var operateView:UIView?
    var topBtn:UIButton?
    var stepBtn:UIButton?
    var commentBtn:UIButton?
    var lineView:UIView?
    var delegate:OBHomeListCellDelegate?
    var isUserContent:Bool?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        usernameLabel = UILabel(frame: CGRect(x: 10, y: 10, width: XDViewWidth - 20, height: 22))
        usernameLabel?.font = XDFont(20)
        usernameLabel?.textColor = keyGreen
        self.contentView.addSubview(usernameLabel!)
        
        contentLabel = UILabel()
        contentLabel?.font = XDFont(18)
        contentLabel?.textColor = UIColor.blackColor()
        contentLabel?.numberOfLines = 0
        self.contentView.addSubview(contentLabel!)
        
//        timeLabel = UILabel(frame: CGRect(x: 10, y: 0, width: XDViewWidth - 20, height: 10))
//        timeLabel?.font = XDFont(10)
//        timeLabel?.textColor = UIColor.grayColor()
//        timeLabel?.textAlignment = .Right
//        self.contentView.addSubview(timeLabel!)

        operateView = UIView(frame: CGRect(x: XDViewWidth - 230, y: 0, width: 220, height: 20))
        self.contentView.addSubview(operateView!)
        
        topBtn = UIButton(frame: CGRect(x: 0, y: 0, width: operateView!.width/3, height: 20))
        topBtn?.tag = 0
        topBtn?.titleLabel?.font = XDFont(15)
        topBtn?.setTitleColor(keyGreen, forState: .Normal)
        topBtn?.setTitleColor(keyAlphaGreen, forState: .Highlighted)
        topBtn?.addTarget(self, action: Selector("operateBtnClick:"), forControlEvents: .TouchUpInside)
        operateView?.addSubview(topBtn!)
        
        stepBtn = UIButton(frame: CGRect(x: topBtn!.right, y: 0, width: operateView!.width/3, height: 20))
        stepBtn?.tag = 1
        stepBtn?.titleLabel?.font = XDFont(15)
        stepBtn?.setTitleColor(keyGreen, forState: .Normal)
        stepBtn?.setTitleColor(keyAlphaGreen, forState: .Highlighted)
        stepBtn?.addTarget(self, action: Selector("operateBtnClick:"), forControlEvents: .TouchUpInside)
        operateView?.addSubview(stepBtn!)
        
        commentBtn = UIButton(frame: CGRect(x: stepBtn!.right, y: 0, width: operateView!.width/3, height: 20))
        commentBtn?.tag = 2
        commentBtn?.titleLabel?.font = XDFont(15)
        commentBtn?.setTitleColor(keyGreen, forState: .Normal)
        commentBtn?.setTitleColor(keyAlphaGreen, forState: .Highlighted)
        commentBtn?.addTarget(self, action: Selector("operateBtnClick:"), forControlEvents: .TouchUpInside)
        operateView?.addSubview(commentBtn!)
        
        lineView = UIView(frame: CGRect(x: 0, y: 0, width: XDViewWidth, height: 0.5))
        lineView?.backgroundColor = UIColor.lightGrayColor()
        lineView?.alpha = 0.5
        self.contentView.addSubview(lineView!)
        
    }
    
    var bObject:BmobObject? {
        didSet {
            if isUserContent! {
                usernameLabel?.hidden = true
                topBtn?.enabled = false
                stepBtn?.enabled = false
                commentBtn?.enabled = false
            } else {
                usernameLabel?.hidden = false
                usernameLabel?.text = bObject!.objectForKey("username") as? String
            }
            contentLabel?.text = bObject!.objectForKey("tellcontent") as? String
            contentLabel?.x = 10
            contentLabel?.y = usernameLabel!.hidden ? 10 : usernameLabel!.bottom + 10
            contentLabel?.width = XDViewWidth - 20
            contentLabel?.sizeToFit()
//            timeLabel?.text = String(bObject?.createdAt)
//            timeLabel?.y = contentLabel!.bottom + 10
            let top = bObject!.objectForKey("telltopnum")
            topBtn?.setTitle("顶 \(top)", forState: .Normal)
            let step = bObject!.objectForKey("tellstepnum")
            stepBtn?.setTitle("踩 \(step)", forState: .Normal)
            let comment = bObject!.objectForKey("tellcommentnum")
            commentBtn?.setTitle("吐槽 \(comment)", forState: .Normal)
            operateView?.y = contentLabel!.bottom + 10
            lineView?.y = operateView!.bottom + 10
            self.height = lineView!.bottom
            
        }
    }
    
    
    func operateBtnClick(btn:UIButton) {
        self.delegate?.operateDelegate(btn, index: self.tag)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.delegate = nil
    }
}
