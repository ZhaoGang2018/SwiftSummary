//
//  XHCrashNSExceptionManager.swift
//  XCamera
//
//  Created by jing_mac on 2019/10/18.
//  Copyright © 2019 xhey. All rights reserved.
//  用于捕获OC的NSException导致的异常崩溃

import UIKit

class XHCrashNSExceptionManager: NSObject {
    
    static let shared = XHCrashNSExceptionManager()

    var previousUncaughtExceptionHandler: NSUncaughtExceptionHandler?
    private override init() {
        super.init()
    }
}


func registerUncaughtExceptionHandler() {
    //保存之前的Handler
    XHCrashNSExceptionManager.shared.previousUncaughtExceptionHandler = NSGetUncaughtExceptionHandler()
    
    //程序崩溃时会自动进入CatchCrash.m的uncaughtExceptionHandler()方法
    NSSetUncaughtExceptionHandler(UncaughtExceptionHandler)
}

func UncaughtExceptionHandler(exception: NSException) {
    
    //获取系统当前时间，（注：用[NSDate date]直接获取的是格林尼治时间，有时差）
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss Z"
    let crashTime = dateFormatter.string(from: Date())
    
    //异常的堆栈信息
    let stackArray = exception.callStackSymbols
    
    //出现异常的原因
    let reson = exception.reason
    
    //异常名称
    let name = exception.name.rawValue
    
    let resultStr = "crashTime:[\(crashTime)]\n-name:[\(name)]\n-reson:[\(String(describing: reson))]\n-stack:[\(stackArray)]"
    
    XHLogError(resultStr)
    
    //调用之前注册的Handler
    if let handler = XHCrashNSExceptionManager.shared.previousUncaughtExceptionHandler {
        handler(exception)
    }
}
