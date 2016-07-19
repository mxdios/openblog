//
//  OBWaterWavesView.swift
//  openblog
//
//  Created by inspiry on 16/1/5.
//  Copyright © 2016年 inspiry. All rights reserved.
//

import UIKit

class OBWaterWavesView: UIView {

    var currentColor:UIColor?
    var currentLineY:CGFloat?
    var a:Double?
    var b:Double?
    var jia:Bool?
    var timer:NSTimer?
    var textL:UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        a = 1.5
        b = 0
        jia = false
        currentColor = keyGreen
        currentLineY = frame.size.height * 0.3
        timer = NSTimer.scheduledTimerWithTimeInterval(0.02, target: self, selector: Selector("animateWave"), userInfo: nil, repeats: true)
        
        textL = UILabel(frame: CGRect(x: 0, y: currentLineY! - 30, width: self.width, height: 60))
        textL?.text = "TELL ALL"
        textL?.textAlignment = .Center
        textL?.font = UIFont.boldSystemFontOfSize(60)
        textL?.textColor = UIColor.whiteColor()
        self.addSubview(textL!)
        
    }
    
    func animateWave() {
        if jia! {
            a! += 0.01
        } else {
            a! -= 0.01
        }
        if a <= 1 {
            jia = true
        }
        if a >= 1.5 {
            jia = false
        }
        b! += 0.1
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()
        let path = CGPathCreateMutable()
        CGContextSetLineWidth(context, 1)
        CGContextSetFillColorWithColor(context, currentColor!.CGColor)
        
        var y:Double = Double(currentLineY!)
        CGPathMoveToPoint(path, nil, 0, CGFloat(y))
        for var x:Double = 0; x <= Double(rect.size.width); ++x {
            y = a! * sin(x / 180 * M_PI + 2 * b! / M_PI) * 20 + Double(currentLineY!)
            CGPathAddLineToPoint(path, nil, CGFloat(x), CGFloat(y))
        }
        
        CGPathAddLineToPoint(path, nil, rect.size.width, rect.size.height);
        CGPathAddLineToPoint(path, nil, 0, rect.size.height);
        CGPathAddLineToPoint(path, nil, 0, currentLineY!);
        CGContextAddPath(context, path);
        CGContextFillPath(context);
        CGContextDrawPath(context, .Stroke);
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        timer?.invalidate()
    }
}
