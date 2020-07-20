//
//  RealmSwift+Extension.swift
//  XCamera
//
//  Created by jing_mac on 2020/7/20.
//  Copyright © 2020 xhey. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - 添加深拷贝的方法
// 单个对象
extension Object {
    
    public func deepCopy() -> Self {
        
        let newObject = type(of: self).init()
        for property in objectSchema.properties {
            
            guard let value = value(forKey: property.name) else {
                continue
            }
            if let detachable = value as? Object {
                newObject.setValue(detachable.deepCopy(), forKey: property.name)
            } else {
                newObject.setValue(value, forKey: property.name)
            }
        }
        return newObject
    }
    
    // 获取实例的属性名称列表，防止数据迁移的时候因为找不到属性名而崩溃
    public func getPropertyNames_xh() -> [String] {
        
        var propertyNames: [String] = []
        for property in self.objectSchema.properties {
            propertyNames.append(property.name)
        }
        
        return propertyNames
    }
}

// 数组集合
extension Sequence where Iterator.Element: Object {
    
    public var deepCopyArray: [Element] {
        return self.map({ $0.deepCopy() })
    }
}


/*
 // 添加深拷贝的方法, 这个有点局限性
 extension Object {
 
 // 深拷贝
 func deepCopy() -> Self {
 let o = type(of:self).init()
 for p in objectSchema.properties {
 let value = self.value(forKey: p.name)
 switch p.type {
 case .linkingObjects:
 break
 default:
 o.setValue(value, forKey: p.name)
 }
 }
 return o
 }
 }
 */
