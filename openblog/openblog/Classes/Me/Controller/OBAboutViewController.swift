//
//  OBAboutViewController.swift
//  openblog
//
//  Created by inspiry on 16/1/6.
//  Copyright © 2016年 inspiry. All rights reserved.
//

import UIKit

class OBAboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关于app"
        self.view.backgroundColor = UIColor.whiteColor()
        let img = UIImageView(image: UIImage(named: "appiconimg"))
        img.width = 100
        img.height = 100
        img.centerY = self.view.height * 0.5 - 30
        img.centerX = self.view.width * 0.5
        img.layer.cornerRadius = 10
        img.clipsToBounds = true
        self.view.addSubview(img)
        
        let titleL = UILabel(frame: CGRect(x: 0, y: img.bottom + 10, width: self.view.width, height: 20))
        titleL.textColor = keyGreen
        titleL.text = "倾诉你的所有"
        titleL.textAlignment = NSTextAlignment.Center
        titleL.font = XDFont(20)
        self.view.addSubview(titleL)
        
        let banben = UILabel(frame: CGRect(x: 0, y: self.view.height - 50, width: self.view.width, height: 15))
        banben.textColor = UIColor.lightGrayColor()
        banben.text = "版本 V1.0"
        banben.textAlignment = NSTextAlignment.Center
        banben.font = XDFont(10)
        self.view.addSubview(banben)
        
        let reserved = UILabel(frame: CGRect(x: 0, y: banben.bottom + 5, width: self.view.width, height: 15))
        reserved.textColor = UIColor.lightGrayColor()
        reserved.text = "Copyright ©2016 猫小懂 ALL rights reserved."
        reserved.textAlignment = NSTextAlignment.Center
        reserved.font = XDFont(10)
        self.view.addSubview(reserved)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
