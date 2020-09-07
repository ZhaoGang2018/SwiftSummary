//
//  XHCrashSignalManager.swift
//  XCamera
//
//  Created by jing_mac on 2019/10/18.
//  Copyright © 2019 xhey. All rights reserved.
// 用于搜集signal异常导致的崩溃(包括Swift及OC)

import UIKit

public typealias Completion = ()->Void;
public typealias CrashCallback = (String, Completion)->Void;

public var crashCallBack:CrashCallback?

func signalHandler(signal:Int32) -> Void {
    var stackTrace = String();
    for symbol in Thread.callStackSymbols {
        stackTrace = stackTrace.appendingFormat("%@\r\n", symbol);
    }
    
    if let callback = crashCallBack {
        callback(stackTrace,{
            unregisterSignalHandler();
            exit(signal);
        });
    }
}

func registerSignalHanlder() {
    signal(SIGINT, signalHandler);
    signal(SIGSEGV, signalHandler);
    signal(SIGTRAP, signalHandler);
    signal(SIGABRT, signalHandler);
    signal(SIGILL, signalHandler);
    signal(SIGQUIT, signalHandler);
    signal(SIGHUP, signalHandler);
    signal(SIGBUS, signalHandler)
}

func unregisterSignalHandler() {
    
    signal(SIGINT, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGTRAP, SIG_DFL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGQUIT, SIG_DFL);
    signal(SIGHUP, SIG_DFL);
    signal(SIGBUS, SIG_DFL)
}

class XHCrashSignalManager: NSObject {
    public static func catchSignalCrash(callBack:@escaping CrashCallback){
        crashCallBack = callBack;
        registerSignalHanlder();
    }
}
