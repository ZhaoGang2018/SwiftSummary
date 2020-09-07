//
//  Date+SpeedyExtension.swift
//  XCamera
//
//  Created by jing_mac on 2019/10/7.
//  Copyright © 2019 xhey. All rights reserved.
//

import Foundation

extension Date {
    
    /// 获取当前 秒级 时间戳 字符串 - 10位
    func toTimeStamp_second_string() -> String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    
    /// 获取当前 秒级 时间戳 数字(Int) - 10位
    func toTimeStamp_second_int() -> Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }
    
    /// 转换成毫秒(millisecond)时间戳字符串(获取当前 毫秒级 时间戳 - 13位)
    func toTimeStamp_ms_string() -> String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    /// 转换成毫秒(Millisecond)时间戳数字(Int)
    func toTimeStamp_ms_int() -> Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = Int(round(timeInterval*1000))
        return millisecond
    }
    
    /// Date转换成String 默认："yyyy-MM-dd HH:mm:ss"）
    func toString(_ dateFormat:String = "yyyy-MM-dd HH:mm:ss", isShowToday: Bool = false) -> String {
        
        var resultStr = ""
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = dateFormat
        resultStr = dateFormater.string(from: self)
        
        if isShowToday && NSCalendar.current.isDateInToday(self) {
            resultStr = "今天 " + resultStr
        }
        return resultStr
    }
}

