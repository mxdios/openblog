//
//  XDCommonFunc.swift
//  openblog
//
//  Created by inspiry on 15/12/24.
//  Copyright © 2015年 inspiry. All rights reserved.
//

import UIKit

import Foundation

//公用的绿色
let keyGreen = UIColor(red:0.28, green:0.78, blue:0.85, alpha:1)
//半透明的公用的绿色
let keyAlphaGreen = UIColor(red:0.28, green:0.78, blue:0.85, alpha:0.5)

//自定义颜色
func XDAlpColor(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}
//随机色
func XDRandomColor() -> UIColor {
    srand48(Int(time(nil)))
    print(drand48())
    return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
}
//view的宽
let XDViewWidth = UIScreen.mainScreen().bounds.size.width
//view的高
let XDViewHeight = UIScreen.mainScreen().bounds.size.height
//返回字体
func XDFont(f:CGFloat) -> UIFont {
    return UIFont.systemFontOfSize(f)
}
//返回彩色图片
func XDImageWithColor(color:UIColor, size:CGSize) -> UIImage {
    UIGraphicsBeginImageContext(CGSize(width: size.width, height: size.height))
    let content:CGContextRef = UIGraphicsGetCurrentContext()!
    CGContextSetFillColorWithColor(content, color.CGColor)
    CGContextFillRect(content, CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}


class XDCommonFunc: NSObject {

}
