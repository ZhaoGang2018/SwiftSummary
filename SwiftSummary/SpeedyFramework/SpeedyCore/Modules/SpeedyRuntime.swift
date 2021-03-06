//
//  SpeedyRuntime.swift
//  XCamera
//
//  Created by jing_mac on 2019/9/12.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

class SpeedyRuntime: NSObject {
    
    //获取所有属性
    class func getAllIvars<T>(from type: T.Type) {
        var count: UInt32 = 0
        let ivars = class_copyIvarList(type as? AnyClass, &count)
        for index in 0..<count {
            guard let ivar = ivars?[Int(index)] else { continue }
            guard let namePointer = ivar_getName(ivar) else { continue }
            guard let name = String.init(utf8String: namePointer) else { continue }
            print("ivar_name: \(name)")
        }
    }
    
    //获取所有方法
    class func getAllMethods<T>(from type: T.Type) {
        var count: UInt32 = 0
        let methods = class_copyMethodList(type as? AnyClass, &count)
        for index in 0..<count {
            guard let method = methods?[Int(index)] else { continue }
            let selector = method_getName(method)
            let name = NSStringFromSelector(selector)
            print("method_name: \(name)")
        }
    }
}


