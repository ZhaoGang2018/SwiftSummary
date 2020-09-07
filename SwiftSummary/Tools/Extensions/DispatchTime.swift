//
//  DispatchTime.swift
//  XCamera
//
//  Created by Quinn Von on 2019/10/13.
//  Copyright © 2019 xhey. All rights reserved.
//

import Foundation
extension DispatchTime: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}

extension DispatchTime: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}
