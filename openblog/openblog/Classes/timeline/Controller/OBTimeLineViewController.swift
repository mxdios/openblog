//
//  OBTimeLineViewController.swift
//  openblog
//
//  Created by inspiry on 15/12/23.
//  Copyright © 2015年 inspiry. All rights reserved.
//

import UIKit

class OBTimeLineViewController: UIViewController,UITextViewDelegate {

    var inputTextView:OBTextView?
    var hud:MBProgressHUD?
    var waterWaves:OBWaterWavesView?
    override func viewWillAppear(animated: Bool) {
        waterWaves?.timer?.fireDate = NSDate.distantPast()
    }
    override func viewWillDisappear(animated: Bool) {
        waterWaves?.timer?.fireDate = NSDate.distantFuture()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        inputTextView = OBTextView(frame: CGRect(x: 10, y: 74, width: self.view.width - 20, height: self.view.height * 0.3))
        inputTextView?.plaveStr = "TELL ALL  倾诉你的所有"
        inputTextView?.font = XDFont(15)
        inputTextView?.delegate = self
        self.view.addSubview(inputTextView!)

        waterWaves = OBWaterWavesView(frame: CGRect(x: 0, y: inputTextView!.bottom + 10, width: self.view.width, height: self.view.height - inputTextView!.bottom - 10))
        self.view.addSubview(waterWaves!)
        
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        print(inputTextView?.text,text)
        if text == "\n" {
            sendTellAllConten()
            return false
        }
        return true
    }
    //    键盘弹出收回的通知方法
    func keyboardWillShow(not:NSNotification) {
        waterWaves?.timer?.fireDate = NSDate.distantFuture()
    }
    func keyboardWillHide(not:NSNotification) {
        waterWaves?.timer?.fireDate = NSDate.distantPast()
    }

    func sendTellAllConten() {
        if inputTextView?.text.characters.count > 0 {
            
            let bUser = BmobUser.getCurrentUser()
            if bUser == nil {
                MBProgressHUD.showText("未登录,请登录...")
                self.navigationController?.pushViewController(OBLoginViewController(), animated: true)
                return
            }
            hud = MBProgressHUD.showMessage("发布中...", toView: self.view)
            self.view.endEditing(true)
            let gameScore:BmobObject = BmobObject(className: "tellList")
            gameScore.setObject(inputTextView!.text, forKey: "tellcontent")
            gameScore.setObject(bUser.objectForKey("userid"), forKey: "userid")
            gameScore.setObject(bUser.objectForKey("username"), forKey: "username")
            gameScore.setObject("0", forKey: "telltopnum")
            gameScore.setObject("0", forKey: "tellstepnum")
            gameScore.setObject("0", forKey: "tellcommentnum")
            gameScore.saveInBackgroundWithResultBlock({ (Bool, NSError) -> Void in
                self.hud?.hidden = true
                if Bool {
                    MBProgressHUD.showText("发送成功")
                    self.inputTextView?.text = ""
                    self.inputTextView?.plaveLabel?.hidden = false
                    NSNotificationCenter.defaultCenter().postNotificationName(keySendSuccess, object: nil)
                } else {
                    MBProgressHUD.showText("发送失败")
                }
            })
        } else {
            MBProgressHUD.showText("请输入内容")
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
