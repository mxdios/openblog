//
//  OBLoginViewController.swift
//  openblog
//
//  Created by inspiry on 15/12/24.
//  Copyright © 2015年 inspiry. All rights reserved.
//

import UIKit

class OBLoginViewController: UIViewController {

    var nameTextField:OBTextField?
    var pswdTextField:OBTextField?
    var loginBtn:XDLoginCommonBtn?
    var signBtn:UIButton?
    var hud:MBProgressHUD?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "登录"
        self.view.backgroundColor = UIColor.whiteColor()
        
        nameTextField = OBTextField(frame: CGRect(x: 60, y: 100, width: self.view.width - 120, height: 40))
        nameTextField?.placeholder = "用户名"
        self.view.addSubview(nameTextField!)
        
        pswdTextField = OBTextField(frame: CGRect(origin: CGPointMake(60, nameTextField!.bottom + 20), size: nameTextField!.frame.size))
        pswdTextField?.placeholder = "密码"
        pswdTextField?.secureTextEntry = true
        self.view.addSubview(pswdTextField!)

        loginBtn = XDLoginCommonBtn(frame: CGRect(origin: CGPointMake(60, pswdTextField!.bottom + 20), size: nameTextField!.frame.size))
        loginBtn?.setTitle("登录", forState: UIControlState.Normal)
        loginBtn?.addTarget(self, action: Selector("loginBtnClick"), forControlEvents: .TouchUpInside)
        self.view.addSubview(loginBtn!)
        
        signBtn = UIButton(frame: CGRect(x: loginBtn!.right - 32, y: loginBtn!.bottom + 10, width: 32, height: 16))
        signBtn?.setTitle("注册", forState: .Normal)
        signBtn?.setTitleColor(keyGreen, forState: .Normal)
        signBtn?.setTitleColor(keyAlphaGreen, forState: .Highlighted)
        signBtn?.titleLabel?.font = XDFont(16)
        signBtn?.addTarget(self, action: Selector("signBtnClick"), forControlEvents: .TouchUpInside)
        self.view.addSubview(signBtn!)
        
    }
    func loginBtnClick() {
        if nameTextField!.text!.characters.count <= 0 {
            MBProgressHUD.showText("用户名不能为空")
            return
        }
        if pswdTextField!.text!.characters.count < 6 {
            MBProgressHUD.showText("密码至少为6位")
            return
        }
        self.view.endEditing(true)
        hud = MBProgressHUD.showMessage("登录中...", toView: self.view)
        BmobUser.logInWithUsernameInBackground(nameTextField?.text, password: ((pswdTextField?.text)! + keyMD5).md5) { (BmobUser, NSError) -> Void in
            self.hud?.hidden = true
            if NSError == nil {
                MBProgressHUD.showText("登录成功")
                NSNotificationCenter.defaultCenter().postNotificationName(keyLoginNot, object: nil)
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                if 101 == NSError.code {
                    MBProgressHUD.showText("用户名或密码错误")
                } else {
                    MBProgressHUD.showText("登录失败")
                }
            }
        }
    }
    func signBtnClick() {
        self.navigationController?.pushViewController(OBSignViewController(), animated: true)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
