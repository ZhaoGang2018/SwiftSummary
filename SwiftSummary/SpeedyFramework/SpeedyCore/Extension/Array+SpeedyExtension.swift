//
//  Array+SpeedyExtension.swift
//  XCamera
//
//  Created by 赵刚 on 2020/3/2.
//  Copyright © 2020 xhey. All rights reserved.
//

import Foundation

extension Array {
    
    /// 数组内中文按拼音字母排序
    /// - Parameter ascending: 是否升序（默认升序）
    func sortedByPinyin(ascending: Bool = true) -> Array<String>? {
        if self is Array<String> {
            return (self as! Array<String>).sorted { (value1, value2) -> Bool in
                let pinyin1 = value1.transformToPinyin()
                let pinyin2 = value2.transformToPinyin()
                return pinyin1.compare(pinyin2) == (ascending ? .orderedAscending : .orderedDescending)
            }
        }
        return nil
    }
}
