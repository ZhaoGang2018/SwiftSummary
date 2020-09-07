//
//  SpeedJumpStatus.swift
//  XCamera
//
//  Created by Quinn Von on 2020/4/13.
//  Copyright © 2020 xhey. All rights reserved.
//

import Foundation
/// 跳转状态 是否成功
public enum SpeedyJumpStatus: String {
    case success    = "success"
    case fail        = "fail"
    init?(string: String?) {
        guard let string = string else { return nil }
        self.init(rawValue: string)
    }
}
/// JMPStatus  描述信息
extension SpeedyJumpStatus: CustomStringConvertible {
    public var description: String {
        return rawValue
    }
}
