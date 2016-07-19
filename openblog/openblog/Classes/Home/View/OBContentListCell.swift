//
//  OBContentListCell.swift
//  openblog
//
//  Created by inspiry on 16/1/5.
//  Copyright © 2016年 inspiry. All rights reserved.
//

import UIKit

class OBContentListCell: UITableViewCell {
    
    var usernameLabel:UILabel?
    var contentLabel:UILabel?
    var lineView:UIView?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        usernameLabel = UILabel(frame: CGRect(x: 10, y: 10, width: XDViewWidth - 20, height: 20))
        usernameLabel?.font = XDFont(18)
        usernameLabel?.textColor = keyGreen
        self.contentView.addSubview(usernameLabel!)
        
        contentLabel = UILabel()
        contentLabel?.font = XDFont(15)
        contentLabel?.textColor = UIColor.blackColor()
        contentLabel?.numberOfLines = 0
        self.contentView.addSubview(contentLabel!)
        
        lineView = UIView(frame: CGRect(x: 0, y: 0, width: XDViewWidth, height: 0.5))
        lineView?.backgroundColor = UIColor.lightGrayColor()
        lineView?.alpha = 0.5
        self.contentView.addSubview(lineView!)
    }
    var bObject:BmobObject? {
        didSet {
            usernameLabel?.text = bObject!.objectForKey("username") as? String
            contentLabel?.text = bObject!.objectForKey("commentContent") as? String
            contentLabel?.x = 10
            contentLabel?.y = usernameLabel!.bottom + 10
            contentLabel?.width = XDViewWidth - 20
            contentLabel?.sizeToFit()
            lineView?.y = contentLabel!.bottom + 10
            self.height = lineView!.bottom
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
