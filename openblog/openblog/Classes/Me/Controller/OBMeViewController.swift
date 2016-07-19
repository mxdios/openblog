//
//  OBMeViewController.swift
//  openblog
//
//  Created by inspiry on 15/12/23.
//  Copyright © 2015年 inspiry. All rights reserved.
//

import UIKit

class OBMeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,headViewDelegate,UIActionSheetDelegate {

    var hud:MBProgressHUD?
    var headView:OBMeHeadView?
    var dataArray:NSMutableArray = NSMutableArray()
    var meTv:UITableView?
    let ID = "OBHomeListCell"
    var cellH:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("commonUserLoadData"), name: keyLoginNot, object: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "设置", style: .Plain, target: self, action: Selector("pushSettingVc"))
        setupSelfView()
    }

    func setupSelfView() {
        meTv = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        meTv?.delegate = self
        meTv?.dataSource = self
        meTv?.registerClass(OBHomeListCell().classForCoder, forCellReuseIdentifier: ID)
        meTv?.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(meTv!)
        
        headView = OBMeHeadView(frame: CGRect(x: 0, y: 0, width: XDViewWidth, height: 150))
        headView?.delegate = self
        meTv?.tableHeaderView = headView!
        
        commonUserLoadData()
    }
    func commonUserLoadData() {
        loginSuccess()
        setupLoadData()
    }
    func pushSettingVc() {
        self.navigationController?.pushViewController(OBSettingViewController(), animated: true)
    }
    func setupLoadData() {
        let bUser = BmobUser.getCurrentUser()
        if bUser == nil {
            dataArray = NSMutableArray()
            meTv?.reloadData()
            return
        }
        hud = MBProgressHUD.showMessage("加载中...", toView: self.view)
        let commentQuery:BmobQuery = BmobQuery(className: "tellList")
        commentQuery.orderByDescending("tellid")
        commentQuery.limit = 1000
        //        commentQuery.skip = skipNum //后期加分页才使用
        commentQuery.whereKey("userid", equalTo: bUser.objectForKey("userid"))
        commentQuery.findObjectsInBackgroundWithBlock { (Array, NSError) -> Void in
            self.hud?.hidden = true
            print("评论数据 = \(Array), 错误 = \(NSError)")
            if NSError == nil {
                if Array.count > 0 {
                    self.dataArray = NSMutableArray(array: Array)
                    self.meTv?.reloadData()
                } else {
                    MBProgressHUD.showText("暂无Tell all", toView: self.view)
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

    
    func goLoginDelegate() {
        self.navigationController?.pushViewController(OBLoginViewController(), animated: true)
    }
    func loginSuccess() {
        let bUser = BmobUser.getCurrentUser()
        if bUser != nil {
            headView?.userName = bUser.objectForKey("username") as? String
            headView?.userInteractionEnabled = false
        } else {
            headView?.userName = "未登录,请登录"
            headView?.userInteractionEnabled = true
        }
    }
//    uitableview数据源和代理
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(ID, forIndexPath: indexPath) as? OBHomeListCell
        cell?.tag = indexPath.row
        cell?.isUserContent = true
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

}
