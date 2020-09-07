//
//  SpeedClassCopy.swift
//  XCamera
//
//  Created by Quinn Von on 2020/3/17.
//  Copyright © 2020 xhey. All rights reserved.
//

import Foundation

//实现class 的深拷贝，一定要实现Codable协议
protocol Copyable: class, Codable {
    func copy() -> Self
}

extension Copyable {
    func copy() -> Self {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else {
            fatalError("encode失败")
        }
        let decoder = JSONDecoder()
        guard let target = try? decoder.decode(Self.self, from: data) else {
           fatalError("decode失败")
        }
        return target
    }
}
