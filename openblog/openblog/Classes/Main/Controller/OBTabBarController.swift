//
//  OBTabBarController.swift
//  openblog
//
//  Created by inspiry on 15/12/23.
//  Copyright © 2015年 inspiry. All rights reserved.
//

import UIKit

class OBTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let home = OBHomeViewController()
        home.title = "All tell"
        let homeNav = OBNavigationController(rootViewController: home)
        homeNav.title = "All tell"
        homeNav.tabBarItem.image = UIImage(named: "caidanlan_button_tiyan_no")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        homeNav.tabBarItem.selectedImage = UIImage(named: "caidanlan_button_tiyan_yes")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        let time = OBTimeLineViewController()
        time.title = "Tell all"
        let timeNav = OBNavigationController(rootViewController: time)
        timeNav.title = "Tell all"
        timeNav.tabBarItem.image = UIImage(named: "caidanlan_button_dongtai_no")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        timeNav.tabBarItem.selectedImage = UIImage(named: "caidanlan_button_dongtai_yes")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        let me = OBMeViewController()
        me.title = "Me"
        let meNav = OBNavigationController(rootViewController: me)
        meNav.title = "Me"
        meNav.tabBarItem.image = UIImage(named: "caidanlan_button_wode_no")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        meNav.tabBarItem.selectedImage = UIImage(named: "caidanlan_button_wode_yes")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        let items = [homeNav, timeNav, meNav]
        self.viewControllers = items

        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.blackColor()], forState: UIControlState.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:keyGreen], forState: UIControlState.Selected)
        
    }
    
}
