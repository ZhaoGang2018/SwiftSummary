//
//  NSObject+SpeedyExtension.swift
//  XCamera
//
//  Created by jing_mac on 2020/7/2.
//  Copyright © 2020 xhey. All rights reserved.
//

import Foundation

public extension NSObject{
    class var nameOfClass: String {
        let array = NSStringFromClass(self).components(separatedBy: ".")
        if let name =  array.last {
            return name
        }
        return ""
    }
    
    var nameOfClass: String {
        
        let array = NSStringFromClass(type(of: self)).components(separatedBy: ".")
        if let name =  array.last {
            return name
        }
        return ""
    }
}
