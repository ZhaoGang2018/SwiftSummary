//
//  XHLogManager.swift
//  XCamera
//
//  Created by jing_mac on 2019/10/18.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit
import CocoaLumberjack

func XHLogError(_ message: String) {
    if isUseDDLog {
        DDLogError(message)
    }
}

func XHLogWarn(_ message: String) {
    if isUseDDLog {
        DDLogWarn(message)
    }
}

func XHLogInfo(_ message: String) {
    if isUseDDLog {
        DDLogInfo(message)
    }
}

func XHLogDebug(_ message: String) {
    if isUseDDLog {
        DDLogDebug(message)
    }
}

func XHLogVerbose(_ message: String) {
    if isUseDDLog {
        DDLogVerbose(message)
    }
}

class XHLogManager: NSObject {
    
    static let shared = XHLogManager()
    
    var fileLogger = DDFileLogger()
    
    private override init() {
        super.init()
        
        let path = SpeedySandbox.shared.cachesDirectory + "/XCamera.log"
        let logFileManager = DDLogFileManagerDefault.init(logsDirectory: path)
        self.fileLogger = DDFileLogger.init(logFileManager: logFileManager)
        // 每24小时创建一个新文件
        fileLogger.rollingFrequency = 60*60*24
        // 最多允许创建10个文件
        fileLogger.logFileManager.maximumNumberOfLogFiles = 10
        // 最大文件大小5MB
        fileLogger.maximumFileSize = 1024 * 1024 * 5;
    }
    
    // 配置日志信息
    func configDDLog() {
        // 1.自定义Log格式
        let consoleLogFormatter = XHConsoleLogFormatter()
        
        // 2.DDASLLogger，日志语句发送到苹果文件系统、日志状态发送到Console.app
//        DDOSLogger.sharedInstance.logFormatter = consoleLogFormatter
//        DDLog.add(DDOSLogger.sharedInstance)
        
        //3.DDFileLogger，日志语句写入到文件中（默认路径：Library/Caches/Logs/目录下，文件名为bundleid+空格+日期.log）
        let fileLogFormatter = XHFileLogFormatter()
        self.fileLogger.logFormatter = fileLogFormatter
        DDLog.add(self.fileLogger)
        
        // 4.DDTTYLogger，日志语句发送到Xcode
        DDTTYLogger.sharedInstance?.logFormatter = consoleLogFormatter
        DDLog.add(DDTTYLogger.sharedInstance!)
    }
}




/*
 DDLog.add(DDOSLogger.sharedInstance) // Uses os_log
 
 let fileLogger: DDFileLogger = DDFileLogger() // File Logger
 fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
 fileLogger.logFileManager.maximumNumberOfLogFiles = 7
 DDLog.add(fileLogger)
 
 ...
 
 DDLogVerbose("Verbose")
 DDLogDebug("Debug")
 DDLogInfo("Info")
 DDLogWarn("Warn")
 DDLogError("Error")
 */

/*
 DDLogError(@"输出错误文本");
 DDLogWarn(@"定义输出警告文本");
 DDLogInfo(@"输出信息文本");
 DDLogDebug(@"输出调试文本");
 DDLogVerbose(@"输出详细文本");
 
 DDLog的输出级别默认提供以下若干种：
 *DDLogError：定义输出错误文本
 *DDLogWarn：定义输出警告文本
 *DDLogInfo：定义输出信息文本
 *DDLogDebug：定义输出调试文本
 *DDLogVerbose：定义输出详细文本
 
 提供的日志级别为：
 *DDLogLevelOff ，关闭所有日志
 *DDLogLevelError，只打印error 级别的日志
 *DDLogLevelWarning ，打印error，warning级别的日志
 *DDLogFlagInfo，打印error，warning，Info级别的日志
 *DDLogLevelDebug，打印error，warning，Info，debug级别的日志
 *DDLogFlagVerbose,打印error，warning，Info，debug，verbose级别的日志
 *DDLogLevelAll，打印所有日志，不知包含上述几种，还有其他级别的日志。
 */
