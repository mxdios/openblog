//
//  UIViewFrameCategory.swift
//  openblog
//
//  Created by inspiry on 15/12/24.
//  Copyright © 2015年 inspiry. All rights reserved.
//

import Foundation

import UIKit

extension UIView {
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var temp = self.frame
            temp.origin.x = newValue
            self.frame = temp
        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var temp = self.frame
            temp.origin.y = newValue
            self.frame = temp
        }
    }
    
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var temp = self.frame
            temp.size.width = newValue
            self.frame = temp
        }
    }
    
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var temp = self.frame
            temp.size.height = newValue
            self.frame = temp
        }
    }
    
    public var size:CGSize {
        get {
            return self.frame.size
        }
        set {
            var temp = self.frame
            temp.size = newValue
            self.frame = temp
        }
    }
    public var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            var temp = self.center
            temp.x = newValue
            self.center = temp
        }
    }
    
    public var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            var temp = self.center
            temp.y = newValue
            self.center = temp
        }
    }
    
    public var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.origin.x = right - frame.size.width
            self.frame = frame
        }
    }
    
    public var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.origin.y = bottom - frame.size.height
            self.frame = frame
        }
    }
}
//md5加密 字符串分类
extension String  {
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.dealloc(digestLen)
        return String(format: hash as String)
    }
}