//
//  OBContentViewController.swift
//  openblog
//
//  Created by inspiry on 15/12/31.
//  Copyright © 2015年 inspiry. All rights reserved.
//

import UIKit

class OBContentViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UITextViewDelegate {

    var contentTv:UITableView?
    var headView:UIView?
    var contentLabel:UILabel?
    var operateView:UIView?
    var topBtn:UIButton?
    var stepBtn:UIButton?
    var commentBtn:UIButton?
    var bObject:BmobObject?
    var cell:OBHomeListCell?
    var inputTextView:XDInputTextView?
    var inputedView:UIView?
    var blurView:UIVisualEffectView?
    var keyboardH:CGFloat?
    var inputedViewHInn:CGFloat?
    var hud:MBProgressHUD?
    var dataArray:NSMutableArray = NSMutableArray()
    let ID = "OBContentListCell"
    var cellH:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        self.title = bObject!.objectForKey("username") as? String
        self.view.backgroundColor = UIColor.whiteColor()
        setupSelfView()
        setupLoadData()
    }
    
    func setupSelfView() {
        contentTv = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        contentTv?.delegate = self
        contentTv?.dataSource = self
        contentTv?.registerClass(OBContentListCell().classForCoder, forCellReuseIdentifier: ID)
        contentTv?.separatorStyle = UITableViewCellSeparatorStyle.None
        contentTv?.contentInset = UIEdgeInsetsMake(0, 0, 45, 0)
        self.view.addSubview(contentTv!)
        
        headView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 0))
        headView?.backgroundColor = keyGreen
        
        contentLabel = UILabel()
        contentLabel?.font = XDFont(18)
        contentLabel?.textColor = UIColor.blackColor()
        contentLabel?.numberOfLines = 0
        contentLabel?.text = bObject!.objectForKey("tellcontent") as? String
        contentLabel?.x = 10
        contentLabel?.y = 20
        contentLabel?.width = XDViewWidth - 20
        contentLabel?.sizeToFit()
        headView?.addSubview(contentLabel!)
        
        operateView = UIView(frame: CGRect(x: XDViewWidth - 230, y: contentLabel!.bottom + 10, width: 220, height: 15))
        headView?.addSubview(operateView!)
        
        topBtn = UIButton(frame: CGRect(x: 0, y: 0, width: operateView!.width/3, height: 20))
        topBtn?.tag = 0
        topBtn?.titleLabel?.font = XDFont(15)
        topBtn?.setTitleColor(XDAlpColor(255, g: 255, b: 255, a: 1.0), forState: .Normal)
        topBtn?.setTitleColor(XDAlpColor(255, g: 255, b: 255, a: 0.5), forState: .Highlighted)
        let top = bObject!.objectForKey("telltopnum")
        topBtn?.setTitle("顶 \(top)", forState: .Normal)
        topBtn?.addTarget(self, action: Selector("operateBtnClick:"), forControlEvents: .TouchUpInside)
        operateView?.addSubview(topBtn!)
        
        stepBtn = UIButton(frame: CGRect(x: topBtn!.right, y: 0, width: operateView!.width/3, height: 20))
        stepBtn?.tag = 1
        stepBtn?.titleLabel?.font = XDFont(15)
        stepBtn?.setTitleColor(XDAlpColor(255, g: 255, b: 255, a: 1.0), forState: .Normal)
        stepBtn?.setTitleColor(XDAlpColor(255, g: 255, b: 255, a: 0.5), forState: .Highlighted)
        let step = bObject!.objectForKey("tellstepnum")
        stepBtn?.setTitle("踩 \(step)", forState: .Normal)
        stepBtn?.addTarget(self, action: Selector("operateBtnClick:"), forControlEvents: .TouchUpInside)
        operateView?.addSubview(stepBtn!)
        
        commentBtn = UIButton(frame: CGRect(x: stepBtn!.right, y: 0, width: operateView!.width/3, height: 20))
        commentBtn?.tag = 2
        commentBtn?.titleLabel?.font = XDFont(15)
        commentBtn?.setTitleColor(XDAlpColor(255, g: 255, b: 255, a: 1.0), forState: .Normal)
        commentBtn?.setTitleColor(XDAlpColor(255, g: 255, b: 255, a: 0.5), forState: .Highlighted)
        let comment = bObject!.objectForKey("tellcommentnum")
        commentBtn?.setTitle("吐槽 \(comment)", forState: .Normal)
        commentBtn?.addTarget(self, action: Selector("operateBtnClick:"), forControlEvents: .TouchUpInside)
        operateView?.addSubview(commentBtn!)
        headView?.height = operateView!.bottom + 20
        contentTv?.tableHeaderView = headView!
        
        let blurEffect = UIBlurEffect(style: .Light)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView?.frame = self.view.bounds
        blurView?.alpha = 0.5
        blurView?.hidden = true
        self.view.addSubview(blurView!)
        let tap = UITapGestureRecognizer(target: self, action: Selector("boardHide"))
        blurView?.addGestureRecognizer(tap)
        
        inputedView = UIView(frame: CGRect(x: 0, y: self.view.height - 45, width: self.view.width, height: 45))
        inputedView?.backgroundColor = keyGreen
        inputTextView = XDInputTextView(frame: CGRect(x: 10, y: 5, width: inputedView!.width - 20, height: 35))
        inputTextView?.scrollsToTop = false
        inputTextView?.delegate = self
        inputTextView?.font = XDFont(15)
        inputTextView?.plaveStr = "写吐槽"
        inputedView?.addSubview(inputTextView!)
        self.view.addSubview(inputedView!)
    }
    func boardHide() {
        self.view.endEditing(true)
    }
    func setupLoadData() {
        hud = MBProgressHUD.showMessage("加载中...", toView: self.view)
        let commentQuery:BmobQuery = BmobQuery(className: "commentList")
        commentQuery.orderByDescending("commentid")
        commentQuery.limit = 1000
//        commentQuery.skip = skipNum //后期加分页才使用
        commentQuery.whereKey("tellid", equalTo: self.bObject!.objectForKey("tellid"))
        commentQuery.findObjectsInBackgroundWithBlock { (Array, NSError) -> Void in
            self.hud?.hidden = true
            print("评论数据 = \(Array), 错误 = \(NSError)")
            if NSError == nil {
                if Array.count > 0 {
//                    MBProgressHUD.showText("加载成功", toView: self.view)
                    self.dataArray = NSMutableArray(array: Array)
                    self.contentTv?.reloadData()
                } else {
                    MBProgressHUD.showText("暂无吐槽", toView: self.view)
                }
            } else {
//                if self.rebulidView == nil {
//                    self.rebulidView = XDRebulidView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height))
//                    self.rebulidView?.delegate = self
//                    self.rebulidView?.hidden = false
//                    self.view.addSubview(self.rebulidView!)
//                } else {
//                    self.rebulidView?.hidden = false
//                }
                MBProgressHUD.showText("加载失败", toView: self.view)
            }
        }
    }

    func operateBtnClick(btn: UIButton) {
        let bUser = BmobUser.getCurrentUser()
        if bUser == nil {
            MBProgressHUD.showText("未登录,请登录...")
            self.navigationController?.pushViewController(OBLoginViewController(), animated: true)
            return
        }
        switch btn.tag {
        case 0:
            let a = String(Int(bObject!.objectForKey("telltopnum") as! String)! + 1)
            bObject!.setObject(a, forKey: "telltopnum")
            bObject!.updateInBackgroundWithResultBlock({ (Bool, NSError) -> Void in
                if Bool {
                    btn.setTitle("顶 \(a)", forState: .Normal)
                    self.cell?.topBtn?.setTitle("顶 \(a)", forState: .Normal)
                    MBProgressHUD.showText("顶+1", toView: self.view)
                } else {
                    MBProgressHUD.showText("顶失败", toView: self.view)
                }
            })
            break
        case 1:
            let a = String(Int(bObject!.objectForKey("tellstepnum") as! String)! + 1)
            bObject!.setObject(a, forKey: "tellstepnum")
            bObject!.updateInBackgroundWithResultBlock({ (Bool, NSError) -> Void in
                if Bool {
                    btn.setTitle("踩 \(a)", forState: .Normal)
                    self.cell?.stepBtn?.setTitle("踩 \(a)", forState: .Normal)
                    MBProgressHUD.showText("踩+1", toView: self.view)
                } else {
                    MBProgressHUD.showText("踩失败", toView: self.view)
                }
            })
            break
            
        case 2:
            print("吐槽")
            inputTextView?.becomeFirstResponder()
            break
            
        default:
            break
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let textViewH = textView.contentSize.height;
        if textViewH < 100 {
            textView.height = textViewH > 30 ? textViewH : 35
            inputedViewHInn = inputedView!.height
            inputedView?.height = inputTextView!.height + 10
            inputedView?.transform = CGAffineTransformTranslate(inputedView!.transform, 0, -(inputedView!.height - inputedViewHInn!));
        }
        if text == "\n" {
            print("发送")
            tellCommentSend()
            return false
        }
        return true
    }
    func tellCommentSend() {
        if inputTextView!.text.characters.count == 0 {
            MBProgressHUD.showText("请输入内容")
            return
        }
        hud = MBProgressHUD.showMessage("吐槽中...", toView: self.view)
        let bUser = BmobUser.getCurrentUser()
        let gameScore:BmobObject = BmobObject(className: "commentList")
        gameScore.setObject(inputTextView!.text, forKey: "commentContent")
        gameScore.setObject(bUser.objectForKey("userid"), forKey: "userid")
        gameScore.setObject(bUser.objectForKey("username"), forKey: "username")
        gameScore.setObject(bObject!.objectForKey("tellid"), forKey: "tellid")
        gameScore.saveInBackgroundWithResultBlock { (Bool, NSError) -> Void in
            self.hud?.hidden = true
            if Bool {
                MBProgressHUD.showText("吐槽成功")
                var num:Int = Int(self.bObject?.objectForKey("tellcommentnum") as! String)!
                num += 1
                self.bObject?.setObject(String(num), forKey: "tellcommentnum")
                self.bObject?.updateInBackground()
                self.cell?.commentBtn?.setTitle("吐槽 \(num)", forState: .Normal)
                self.commentBtn?.setTitle("吐槽 \(num)", forState: .Normal)
                self.setupLoadData()
                self.inputTextView?.text = nil
                self.inputTextView?.plaveStr = "写吐槽"
                self.inputTextView?.height = 35
                self.inputedView?.height = 45
                self.view.endEditing(true)
            } else {
                MBProgressHUD.showText("吐槽失败")
            }
        }
    }
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        let bUser = BmobUser.getCurrentUser()
        if bUser == nil {
            self.view.endEditing(true)
            MBProgressHUD.showText("未登录,请登录...")
            self.navigationController?.pushViewController(OBLoginViewController(), animated: true)
            return false
        }
        return true
    }
//    键盘弹出收回的通知方法
    func keyboardWillShow(not:NSNotification) {
        
        blurView?.hidden = false
        keyboardH = not.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height
        inputedView?.transform = CGAffineTransformMakeTranslation(0, -keyboardH!)
    }
    func keyboardWillHide(not:NSNotification) {
        blurView?.hidden = true
        inputedView?.transform = CGAffineTransformIdentity
        inputedView?.y = self.view.height - inputedView!.height
    }
    
//    tableview代理数据源方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(ID, forIndexPath: indexPath) as? OBContentListCell
        cell?.bObject = self.dataArray.objectAtIndex(indexPath.row) as? BmobObject
        cellH = cell!.height
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellH
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }

}
