//
//  Data+Extension.swift
//  XCamera
//
//  Created by EdwardD on 2017/10/19.
//  Copyright © 2017年 xhey. All rights reserved.
//

import Foundation

extension Data {
    
    func segment(length: Int) -> [Data] {
        let segmentCount = Int(ceilf(Float(count) / Float(length)))
        var datas = [Data]()
        
        for i in 0..<segmentCount {
            
            let dataLength: Int
            if i < segmentCount - 1 {
                dataLength = length
            } else {
                dataLength = count - i * length
            }
            
            let nsRange = NSRange(location: i * length, length: dataLength)
            
            if let range = Range<Data.Index>.init(nsRange) {
                let data = subdata(in: range)
                datas.append(data)
            }
        }
        
        return datas
    }
}
