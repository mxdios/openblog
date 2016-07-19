//
//  OBHomeViewController.swift
//  openblog
//
//  Created by inspiry on 15/12/23.
//  Copyright © 2015年 inspiry. All rights reserved.
//

import UIKit

class OBHomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,OBHomeListCellDelegate,XDRebulidViewDelegate,UITextViewDelegate  {

    var hud:MBProgressHUD?
    var dataArray:NSMutableArray = NSMutableArray()
    var homeTv:UITableView?
    let ID = "OBHomeListCell"
    var cellH:CGFloat = 0
    var rebulidView:XDRebulidView?
    var inputTextView:XDInputTextView?
    var inputedView:UIView?
    var inputedViewHInn:CGFloat?
    var indexInn:Int?
    var commontBtnInn:UIButton?
    var blurView:UIVisualEffectView?
    var keyboardH:CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orangeColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("sendSuccessNot"), name: keySendSuccess, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "jiazai_button_yes"), style: .Plain, target: self, action: Selector("sendSuccessNot"));
        setupSelfView()
        setupLoadData(0)
        
        PgyUpdateManager.sharedPgyManager().startManagerWithAppId(keyPgy)
        PgyUpdateManager.sharedPgyManager().checkUpdate()
    }
    func sendSuccessNot() {
        setupLoadData(0)
    }
    func setupSelfView() {
        homeTv = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        homeTv?.delegate = self
        homeTv?.dataSource = self
        homeTv?.registerClass(OBHomeListCell().classForCoder, forCellReuseIdentifier: ID)
        homeTv?.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(homeTv!)
        
        let blurEffect = UIBlurEffect(style: .Light)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView?.frame = self.view.bounds
        blurView?.alpha = 0.5
        blurView?.hidden = true
        self.view.addSubview(blurView!)
        let tap = UITapGestureRecognizer(target: self, action: Selector("boardHide"))
        blurView?.addGestureRecognizer(tap)
        
        inputedView = UIView(frame: CGRect(x: 0, y: self.view.height, width: self.view.width, height: 45))
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
    func setupLoadData(skipNum:Int) {
        self.rebulidView?.hidden = true
        hud = MBProgressHUD.showMessage("加载中...", toView: self.view)
        let bQuery:BmobQuery = BmobQuery(className: "tellList")
        bQuery.orderByDescending("tellid")
        bQuery.limit = 1000
        bQuery.skip = skipNum //后期加分页才使用
        bQuery.findObjectsInBackgroundWithBlock { (Array, NSError) -> Void in
            self.hud?.hidden = true
            print("首页数据 = \(Array), 错误 = \(NSError)")
            if NSError == nil {
                MBProgressHUD.showText("加载成功", toView: self.view)
                self.dataArray = NSMutableArray(array: Array)
                self.homeTv?.reloadData()
            } else {
                if self.rebulidView == nil {
                    self.rebulidView = XDRebulidView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height))
                    self.rebulidView?.delegate = self
                    self.rebulidView?.hidden = false
                    self.view.addSubview(self.rebulidView!)
                } else {
                    self.rebulidView?.hidden = false
                }
                MBProgressHUD.showText("加载失败", toView: self.view)
            }
        }
    }
//    重新加载代理
    func rebulidLoadData() {
        setupLoadData(0)
    }
//    cell上操作的代理
    func operateDelegate(btn: UIButton, index: Int) {

        let bUser = BmobUser.getCurrentUser()
        if bUser == nil {
            MBProgressHUD.showText("未登录,请登录...")
            self.navigationController?.pushViewController(OBLoginViewController(), animated: true)
            return
        }
        
        let bObject:BmobObject = self.dataArray.objectAtIndex(index) as! BmobObject
        
        switch btn.tag {
        case 0:
            let a = String(Int(bObject.objectForKey("telltopnum") as! String)! + 1)
            bObject.setObject(a, forKey: "telltopnum")
            bObject.updateInBackgroundWithResultBlock({ (Bool, NSError) -> Void in
                if Bool {
                    btn.setTitle("顶 \(a)", forState: .Normal)
                    MBProgressHUD.showText("顶+1", toView: self.view)
                } else {
                    MBProgressHUD.showText("顶失败", toView: self.view)
                }
            })
            break
        case 1:
            let a = String(Int(bObject.objectForKey("tellstepnum") as! String)! + 1)
            bObject.setObject(a, forKey: "tellstepnum")
            bObject.updateInBackgroundWithResultBlock({ (Bool, NSError) -> Void in
                if Bool {
                    btn.setTitle("踩 \(a)", forState: .Normal)
                    MBProgressHUD.showText("踩+1", toView: self.view)
                } else {
                    MBProgressHUD.showText("踩失败", toView: self.view)
                }
            })
            break
            
        case 2:
            indexInn = index
            commontBtnInn = btn
            inputTextView?.becomeFirstResponder()
            print("吐槽")
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
        let bobject = self.dataArray.objectAtIndex(indexInn!) as? BmobObject
        hud = MBProgressHUD.showMessage("吐槽中...", toView: self.view)
        let bUser = BmobUser.getCurrentUser()
        let gameScore:BmobObject = BmobObject(className: "commentList")
        gameScore.setObject(inputTextView!.text, forKey: "commentContent")
        gameScore.setObject(bUser.objectForKey("userid"), forKey: "userid")
        gameScore.setObject(bUser.objectForKey("username"), forKey: "username")
        gameScore.setObject(bobject!.objectForKey("tellid"), forKey: "tellid")
        gameScore.saveInBackgroundWithResultBlock { (Bool, NSError) -> Void in
            self.hud?.hidden = true
            if Bool {
                MBProgressHUD.showText("吐槽成功")
                self.view.endEditing(true)
                var num:Int = Int(bobject?.objectForKey("tellcommentnum") as! String)!
                num += 1
                bobject?.setObject(String(num), forKey: "tellcommentnum")
                bobject?.updateInBackground()
                self.commontBtnInn?.setTitle("吐槽 \(num)", forState: .Normal)
                self.inputTextView?.text = nil
                self.inputTextView?.plaveStr = "写吐槽"
                self.inputTextView?.height = 35
                self.inputedView?.height = 45
            } else {
                MBProgressHUD.showText("吐槽失败")
            }
        }
    }
    //    键盘弹出收回的通知方法
    func keyboardWillShow(not:NSNotification) {
        blurView?.hidden = false
        keyboardH = not.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height
        inputedView?.transform = CGAffineTransformMakeTranslation(0, -keyboardH!-inputedView!.height)
    }
    func keyboardWillHide(not:NSNotification) {
        blurView?.hidden = true
        inputedView?.transform = CGAffineTransformIdentity
        inputedView?.y = self.view.height
    }

//    tableview数据源和代理方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.dataArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ID, forIndexPath: indexPath) as? OBHomeListCell
        cell?.tag = indexPath.row
        cell?.isUserContent = false
        cell?.delegate = self
        cell?.bObject = self.dataArray.objectAtIndex(indexPath.row) as? BmobObject
        cellH = cell!.height
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellH
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let contentVc:OBContentViewController = OBContentViewController()
        contentVc.bObject = self.dataArray.objectAtIndex(indexPath.row) as? BmobObject
        contentVc.cell = tableView.cellForRowAtIndexPath(indexPath) as? OBHomeListCell
        self.navigationController?.pushViewController(contentVc, animated: true)
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
