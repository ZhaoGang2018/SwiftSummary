//
//  SpeedJump.swift
//  XCamera
//
//  Created by Quinn Von on 2020/4/13.
//  Copyright © 2020 xhey. All rights reserved.
//

import Foundation
open class SpeedyJump{
    
    /// 跳转到系统页面
    /// - Parameter type： 类型
    /// - Parameter completionHandler：  block回调，bool表示是否成功
    static func system(type:SpeedyJumpSystemType, completionHandler completion: ((SpeedyJumpStatus) -> Void)? = nil){
        var urlString = type.rawValue
        if type == .appSetting{
            urlString = SpeedyJumpSystemType.setting
        }
        if let url: URL = URL(string: urlString) {
            SpeedyJump.jump(url: url, completionHandler: completion)
        }else{
            completion?(.fail)
        }
    }
    
    /// 跳转到App
    /// - Parameter type： 类型
    /// - Parameter completionHandler：  block回调，bool表示是否成功
    static func app(type:SpeedyJumpAppType, completionHandler completion: ((SpeedyJumpStatus) -> Void)? = nil){
        if let url: URL = URL(string: type.rawValue) {
            SpeedyJump.jump(url: url, completionHandler: completion)
        }else{
            completion?(.fail)
        }
    }
    
    /// 跳转
    static func jump(url:URL, completionHandler completion: ((SpeedyJumpStatus) -> Void)? = nil){
        DispatchQueue.main.async {
            UIApplication.shared.open(url, options: [:]) { (bool) in
                if bool{
                    completion?(.success)
                }else{
                    completion?(.fail)
                }
            }
        }
    }
}
