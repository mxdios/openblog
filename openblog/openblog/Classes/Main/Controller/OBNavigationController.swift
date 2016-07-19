//
//  OBNavigationController.swift
//  openblog
//
//  Created by inspiry on 15/12/23.
//  Copyright © 2015年 inspiry. All rights reserved.
//

import UIKit

class OBNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(),NSFontAttributeName:XDFont(20)]
        
        self.navigationBar.tintColor = UIColor.whiteColor()

        self.navigationBar.barTintColor = keyGreen
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: true)
    }
   
}
