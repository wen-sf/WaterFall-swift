//
//  Util.swift
//  WaterFallFlow-Swift
//
//  Created by HongXiangWen on 2018/3/1.
//  Copyright © 2018年 WHX. All rights reserved.
//

import Foundation
import UIKit

/// 获取最大值
func maxOne<T: Comparable>(_ seq: [T]) ->T {
    assert(seq.count > 0)
    return seq.reduce(seq[0]){
        max($0, $1)
    }
}

/// 获取最小值
func minOne<T: Comparable>(_ seq: [T]) ->T {
    assert(seq.count > 0)
    return seq.reduce(seq[0]){
        min($0, $1)
    }
}


extension UIColor {
    
    /// 根据r、g、b生成颜色
    class func color(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    /// 随机颜色 0 ~ 255
    class func randomColor(from: Int, to: Int) -> UIColor {
        let delta = UInt32(to - from)
        return UIColor.color(r: CGFloat(Int(arc4random_uniform(delta)) + from), g: CGFloat(Int(arc4random_uniform(delta)) + from), b: CGFloat(Int(arc4random_uniform(delta)) + from))
    }
    
}

