//
//  SpeedJumpType.swift
//  XCamera
//
//  Created by Quinn Von on 2020/4/13.
//  Copyright © 2020 xhey. All rights reserved.
//

import Foundation
import UIKit
/// 跳转到具体的系统页面类型  **** iOS 10 之后已被废弃  可能会被拒绝****
public enum SpeedyJumpSystemType:String{
    /// app 设置页面
    case appSetting = "App-setting"
    static let setting = UIApplication.openSettingsURLString
}

/// 跳转到具体的App，常用软件
public enum SpeedyJumpAppType:String{
    /// 微信
    case wechat = "weixin://"
    /// QQ
    case qq = "mqq://"
    /// 电话
    case phone = "mobilephone://"
}

