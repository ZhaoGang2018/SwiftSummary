//
//  UIFont+Extension.swift
//  XCamera
//
//  Created by jing_mac on 2019/9/25.
//  Copyright © 2019 xhey. All rights reserved.
//

import Foundation

extension UIFont {
    
    class func regular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func Semibold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Semibold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    class func Medium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func FZShuSong_Z01S(_ size: CGFloat) -> UIFont {
        return UIFont(name: "FZShuSong-Z01S", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func FandolSong_Bold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "FandolSong-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func QiHeiX2_HEW(_ size: CGFloat) -> UIFont {
        return UIFont(name: "HYQiHeiX2-HEW", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func QiHeiX2_FEW(_ size: CGFloat) -> UIFont {
        return UIFont(name: "HYQiHeiX2-FEW", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
