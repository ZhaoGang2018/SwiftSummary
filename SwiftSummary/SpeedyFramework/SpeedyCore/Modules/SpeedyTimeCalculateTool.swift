//
//  SpeedyTimeCalculateTool.swift
//  XCamera
//
//  Created by jing_mac on 2019/11/29.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

class SpeedyTimeCalculateTool: NSObject {
    
    // MARK: - CFAbsoluteTimeGetCurrent(), 单位s
    //你会发现 其实和NSDate 原理是一样的,与参考时间进行计算.
    class func getAbsoluteTime() -> TimeInterval {
        let time = CFAbsoluteTimeGetCurrent()
        return time
    }
    
    // 获取系统时间戳
    class func getCurrentSystemTime() -> TimeInterval {
        let time = Date().timeIntervalSinceReferenceDate
        return time
    }
    
    // "mach_absolute_time"获取到CPU的tickcount的计数值，可以通过"mach_timebase_info"函数获取到纳秒级的精确度
    class func getCurrentMachTime() -> UInt64 {
        let time = mach_absolute_time()
        return time
    }
    
    /*
     系统时钟嘀嗒数转换信息的关系如下:
     时间(ns) / 系统嘀嗒数 = 转换系数分子(.numer) / 转换系数分母(.denom)
     故:
     时间(ns) = 系统嘀嗒数 * 转换系数分子(.numer) / 转换系数分母(.denom)
     */
    class func getMachTimeDifferenceToMillisecond(startTime: UInt64, endTime: UInt64) -> Int {
        
        if startTime > endTime {
            return 0
        }
        
        let timeDiff = endTime - startTime
        
        var timebase = mach_timebase_info()
        let pointer = UnsafeMutablePointer<mach_timebase_info>(&timebase)
        mach_timebase_info(pointer)
        
//        let result = Double(timeDiff) * Double(timebase.numer) / Double(timebase.denom) / pow(10, 6)
        
        let result = Int(timeDiff) * Int(timebase.numer) / Int(timebase.denom) / 1000000

        return result
    }
    
    // 计算系统时间差
    class func getTimeDifferenceToMillisecond(startTime:TimeInterval, endTime: TimeInterval) -> Int {
        if startTime > endTime {
            return 0
        }
        
        let result = Int((endTime - startTime) * 1000)
        return result
    }
}
