//
//  OBSettingViewController.swift
//  openblog
//
//  Created by inspiry on 16/1/4.
//  Copyright © 2016年 inspiry. All rights reserved.
//

import UIKit

class OBSettingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate {

    var logoutView:UIView?
    let titleArray:NSArray = NSArray(objects: "检测更新","关于app")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        let settingTv = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        settingTv.delegate = self
        settingTv.dataSource = self
        self.view.addSubview(settingTv)
        
        logoutView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 200))
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 0.5))
        lineView.backgroundColor = UIColor.lightGrayColor()
        lineView.alpha = 0.5
        logoutView?.addSubview(lineView)
        settingTv.tableFooterView = logoutView
        
        let bUser = BmobUser.getCurrentUser()
        if bUser != nil {
            let logoutBtn:XDSetBgColorBtn = XDSetBgColorBtn(frame: CGRect(x: 60, y: (logoutView!.height - 80)/2, width: logoutView!.width - 120, height: 40))
            logoutBtn.setTitleColor(XDAlpColor(255, g: 255, b: 255, a: 1.0), forState: .Normal)
            logoutBtn.setTitleColor(XDAlpColor(255, g: 255, b: 255, a: 0.5), forState: .Highlighted)
            logoutBtn.setBackgroundColor(UIColor(red: 0.99, green: 0.37, blue: 0.38, alpha: 1.0), state: .Normal)
            logoutBtn.setBackgroundColor(UIColor(red: 0.99, green: 0.37, blue: 0.38, alpha: 0.5), state: .Highlighted)
            logoutBtn.setTitle("注销登录", forState: .Normal)
            logoutBtn.addTarget(self, action: Selector("logoutBtnClick"), forControlEvents: .TouchUpInside)
            logoutBtn.layer.cornerRadius = 4
            logoutBtn.clipsToBounds = true
            logoutView?.addSubview(logoutBtn)
        }
    }
    func logoutBtnClick() {
        let sheet = UIActionSheet(title: "确定要注销当前登录账号吗?", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "确定注销")
        sheet.showInView(self.view)
    }
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if 0 == buttonIndex {
            BmobUser.logout()
            MBProgressHUD.showText("注销成功")
            NSNotificationCenter.defaultCenter().postNotificationName(keyLoginNot, object: nil)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        cell.textLabel?.text = titleArray[indexPath.row] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 0:
            PgyUpdateManager.sharedPgyManager().checkUpdateWithDelegete(self, selector: Selector("updateMethod:"))
            break
        case 1:
            self.navigationController?.pushViewController(OBAboutViewController(), animated: true)
            break
        default:
            break
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    func updateMethod(dict:NSDictionary) {
        if dict.count > 0 {
            PgyUpdateManager.sharedPgyManager().startManagerWithAppId(keyPgy)
            PgyUpdateManager.sharedPgyManager().checkUpdate()
        } else {
            MBProgressHUD.showText("当前为最新版本")
        }
    }
}
