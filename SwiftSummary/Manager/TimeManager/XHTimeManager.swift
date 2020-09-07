//
//  XHTimeManager.swift
//  XCamera
//
//  Created by jing_mac on 2019/12/3.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

class XHTimeManager: NSObject {
    
    static let shared = XHTimeManager()
    private override init() {
        super.init()
        self.isGpsInChina = UserDefaults.standard.bool(forKey: positionInChinaKey)
    }
    
    // 数据库保存的是否在中国
    var isGpsInChina: Bool = false
    
    // 是否展示过校正时间的弹框，一个生命周期只弹一次
    var isShowedCorrectionTimeAlert: Bool = false
    
    // 最大误差300秒
    let timeLimitSeconds: Int = 300
    
    // 内存中的服务器时间，如果存在说明在运行中请求时间接口成功过
    var memoryServerTime: Int?
    // 内存中本地系统时间
    var memoryLocalTime: Int?
    // 内存中手机启动时间
    var memoryBootTime: Int?
    
    private let serviceTimeStampKey = "XHTimeManager_service_time_stamp"  // 服务器的时间戳
    private let localTimeStampKey = "XHTimeManager_local_time_stamp"      // 本地的系统时间戳
    private let bootTimeStampKey = "XHTimeManager_boot_time_stamp"        // 手机开机时间戳
    private let positionInChinaKey = "XHTimeManager_position_in_China"    // 定位是否在中国
    
    // 同步时间的时候的服务器时间
    var syncServiceTime: Int {
        let time = UserDefaults.standard.integer(forKey: serviceTimeStampKey)
        return time
    }
    
    // 同步时间的时候的本地系统时间
    var syncLocalTime: Int {
        let time = UserDefaults.standard.integer(forKey: localTimeStampKey)
        return time
    }
    
    // 同步时间的时候的手机开机时间
    var syncBootTime: Int {
        let time = UserDefaults.standard.integer(forKey: bootTimeStampKey)
        return time
    }
    
    /*
     * 1:时间真实（客户端能从接口获取到时间&接口反馈在国内）
     * 2:时间可能不真实（客户端未能从接口获取时间）
     */
    var timeType: Int {
        if memoryServerTime != nil && self.isGpsInChina == true {
            return 1
        } else {
            return 2
        }
    }
    
    /*
     * 当前的时区
     * 如果GPSInChina在国内需要传国内的时区;
     * 如果不在国内，传手机系统的时区
     */
    var currentTimeZone: TimeZone {
        if self.isGpsInChina {
            if let zone = TimeZone(identifier: "Asia/Shanghai") {
                return zone
            }
        }
        return TimeZone.current
    }
    
    // MARK: - 是否需要校准
    var isNeedCorrectTime: Bool {
        // 该用户不在中国境内
        if self.isGpsInChina == false {
            return false
        }
        
        let calculationDate = self.calculateTime()
        let diffSeconds = Date().timeIntervalSince(calculationDate)
        if Int(abs(diffSeconds)) > self.timeLimitSeconds {
            return true
        }
        return false
    }
    
    // 更新本地的服务器时间
    func updateServiceTime(_ serviceTime: Int) {
        
        UserDefaults.standard.set(serviceTime, forKey: serviceTimeStampKey)
        
        let localTime = now()
        UserDefaults.standard.set(localTime, forKey: localTimeStampKey)
        
        let bootTime = self.bootTime()
        UserDefaults.standard.set(bootTime, forKey: bootTimeStampKey)
        
        self.memoryServerTime = serviceTime
        self.memoryLocalTime = localTime
        self.memoryBootTime = bootTime
        
        XHLogDebug("[时间校准调试]-服务器时间:[\(serviceTime)] - 本地系统时间:[\(localTime)]-开机时间:[\(bootTime)]")
    }
    
    // 更新用户是否在中国
    func updateIsInChina(_ inChina: Bool) {
        self.isGpsInChina = inChina
        UserDefaults.standard.set(inChina, forKey: positionInChinaKey)
        XHLogDebug("[时间校准调试]-位置是否在中国:[\(inChina)]")
    }
    
    // 获取当前 Unix Time：
    func now() -> Int {
        var now = timeval()
        var tz = timezone()
        gettimeofday(&now, &tz)
        return now.tv_sec
    }
    
    // 获取设备上次重启的 Unix Time：
    func bootTime() -> Int {
        
        var mid = [CTL_KERN, KERN_BOOTTIME]
        var boottime = timeval()
        var size = MemoryLayout.size(ofValue: boottime)
        
        if sysctl(&mid, 2, &boottime, &size, nil, 0) != -1 {
            return boottime.tv_sec
        }
        return 0
    }
    
    // 运行时间
    func uptime() -> Int {
        var boottime = timeval()
        var mid = [CTL_KERN, KERN_BOOTTIME]
        var size = MemoryLayout.size(ofValue: boottime)
        
        var now: time_t = 0
        var uptime: time_t = -1
        time(&now)
        
        if sysctl(&mid, 2, &boottime, &size, nil, 0) != -1 && boottime.tv_sec != 0 {
            uptime = now - boottime.tv_sec
            return uptime
        }
        return 0
    }
    
    // MARK: - 通过上次记录在本地的服务器时间计算真实的时间
    func calculateTime() -> Date {
        
        // 该用户不在中国境内
        if self.isGpsInChina == false {
            return Date()
        }
        
        // 内存中有服务器时间，一切以服务器的时间为准
        if let memoryServerTime = self.memoryServerTime,
            let memoryLocalTime = self.memoryLocalTime,
            let memoryBootTime = self.memoryBootTime {
            
            let realDate = self.calculateTimeByMemory(memoryServerTime: memoryServerTime, memoryLocalTime: memoryLocalTime, memoryBootTime: memoryBootTime)
            return realDate
        }
        
        // 内存中没有服务器时间，使用上次的数据
        let resultDate = self.calculateTimeByLastServiceTime()
        return resultDate
    }
    
    // 根据上次保存的时间计算(此时用户可能重启也可能修改了时间)
    private func calculateTimeByLastServiceTime() -> Date {
        // 本地不存在服务器时间，使用系统时间
        if self.syncServiceTime == 0 {
            return Date()
        }
        
        // 真正的开机时间
        var realBootTime = syncBootTime
        if abs(self.syncServiceTime - self.syncLocalTime) > self.timeLimitSeconds {
            // 上次同步时间的时候，本地系统时间修改过
            realBootTime = syncBootTime + (syncServiceTime - syncLocalTime)
        }
        
        let nowLocalTime = self.now()
        let nowBootTime = self.bootTime()
        
        if abs(nowBootTime - realBootTime) <= self.timeLimitSeconds || nowBootTime > self.syncServiceTime {
            // 当前的开机时间和真正的开机时间相同
            XHLogDebug("[时间校准调试]-使用上次记录的数据，使用系统数据")
            return Date()
        } else {
            let realTime = realBootTime + (nowLocalTime - nowBootTime)
            let realDate = Date.init(timeIntervalSince1970: TimeInterval(realTime))
            XHLogDebug("[时间校准调试]-使用上次记录的数据，计算出来的:[\(realTime)]")
            return realDate
        }
    }
    
    // 根据内存中的时间计算(此时用户一定没有重启)
    private func calculateTimeByMemory(memoryServerTime: Int, memoryLocalTime: Int, memoryBootTime: Int) -> Date {
        
        // 真正的开机时间
        var realBootTime = memoryBootTime
        if abs(memoryServerTime - memoryLocalTime) > self.timeLimitSeconds {
            // 上次同步时间的时候，本地系统时间修改过
            realBootTime = memoryBootTime + (memoryServerTime - memoryLocalTime)
        }
        
        let nowBootTime = self.bootTime()
        if abs(nowBootTime - realBootTime) > self.timeLimitSeconds {
            let runTime0 = memoryLocalTime - memoryBootTime
            let runTime1 = self.uptime()
            let resultTime = memoryServerTime + (runTime1 - runTime0)
            XHLogDebug("[时间校准调试]-内存服务器时间:[\(memoryServerTime)]-内存同步时运行时间:[\(runTime0)] - 现在的运行时间:[\(runTime1)]-推算的结果:[\(resultTime))]")
            let realDate = Date.init(timeIntervalSince1970: TimeInterval(resultTime))
            return realDate
        } else {
             XHLogDebug("[时间校准调试]-内存有服务器时间-开机时间误差在5分钟内，使用系统时间")
            return Date()
        }
    }
}
