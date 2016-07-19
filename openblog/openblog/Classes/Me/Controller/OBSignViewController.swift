//
//  OBSignViewController.swift
//  openblog
//
//  Created by inspiry on 15/12/30.
//  Copyright © 2015年 inspiry. All rights reserved.
//

import UIKit

class OBSignViewController: UIViewController {

    var nameTextField:OBTextField?
    var pswdTextField:OBTextField?
    var signBtn:XDLoginCommonBtn?
    var hud:MBProgressHUD?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "注册"
        self.view.backgroundColor = UIColor.whiteColor()
        
        nameTextField = OBTextField(frame: CGRect(x: 60, y: 100, width: self.view.width - 120, height: 40))
        nameTextField?.placeholder = "用户名"
        self.view.addSubview(nameTextField!)
        
        pswdTextField = OBTextField(frame: CGRect(origin: CGPointMake(60, nameTextField!.bottom + 20), size: nameTextField!.frame.size))
        pswdTextField?.placeholder = "密码"
        pswdTextField?.secureTextEntry = true
        self.view.addSubview(pswdTextField!)
        
        signBtn = XDLoginCommonBtn(frame: CGRect(origin: CGPointMake(60, pswdTextField!.bottom + 20), size: nameTextField!.frame.size))
        signBtn?.setTitle("注册", forState: UIControlState.Normal)
        signBtn?.addTarget(self, action: Selector("signBtnClick"), forControlEvents: .TouchUpInside)
        self.view.addSubview(signBtn!)
    }
    
    func signBtnClick() {
        if nameTextField!.text!.characters.count <= 0 {
            MBProgressHUD.showText("用户名不能为空")
            return
        }
        if pswdTextField!.text!.characters.count < 6 {
            MBProgressHUD.showText("密码至少为6位")
            return
        }
        self.view.endEditing(true)
        hud = MBProgressHUD.showMessage("注册中...", toView: self.view)
        let bUser:BmobUser = BmobUser()
        bUser.setUserName(nameTextField?.text)
        bUser.setPassword(((pswdTextField?.text)! + keyMD5).md5)
        bUser.signUpInBackgroundWithBlock { (Bool, NSError) -> Void in
            self.hud?.hidden = true
            if Bool {
                BmobUser.logInWithUsernameInBackground(self.nameTextField?.text, password: ((self.pswdTextField?.text)! + keyMD5).md5)
                MBProgressHUD.showText("注册成功")
                
                NSNotificationCenter.defaultCenter().postNotificationName(keyLoginNot, object: nil)
                self.navigationController?.popToRootViewControllerAnimated(true)
            } else if 202 == NSError.code {
                MBProgressHUD.showText("此用户名已存在")
            } else {
                MBProgressHUD.showText("注册失败")
            }
        }
        
     }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
