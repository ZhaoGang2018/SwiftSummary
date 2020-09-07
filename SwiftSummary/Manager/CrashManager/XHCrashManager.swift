//
//  XHCrashManager.swift
//  XCamera
//
//  Created by jing_mac on 2019/10/18.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

class XHCrashManager: NSObject {
    
    static let shared = XHCrashManager()
    
    private override init() {
        super.init()
    }
    
    func registerCrashHandler() {
        //注册signal,捕获相关crash
        XHCrashSignalManager.catchSignalCrash { (stackTrace, completion) in
            XHLogError(stackTrace)
            completion();
        }
        
        //注册NSException,捕获相关crash
        registerUncaughtExceptionHandler()
    }
}
