//
//  UIColor+Extension.swift
//  XCamera
//
//  Created by Quinn_F on 2018/1/24.
//  Copyright © 2018年 xhey. All rights reserved.
//

import Foundation
extension UIColor{
    
    // 细线对的颜色
    class func lineColor() -> UIColor {
        return UIColor.fromHex("E6E9ED")
    }
    
    // 通用蓝色
    class func blueColor_xh() -> UIColor {
        return UIColor.fromHex("#0093FF")
    }
    
    
    ///浅灰色search背景色
    public class func graySearchBackgroundColor_xh()->UIColor{return UIColor.fromHex("#EFEFF4")}
    
    ///浅灰色字体颜色
    public class func lightGrayDetailTextColor_xh()->UIColor{return UIColor.fromHex("#83838C")}

    
}
