//
//  CGPoint+Extension.swift
//  XCamera
//
//  Created by Swaying on 2017/12/28.
//  Copyright © 2017年 xhey. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    func distance(_ point: CGPoint) -> CGFloat {
        let fx = (point.x - x)
        let fy = (point.y - y)
        return sqrt((fx*fx + fy*fy))
    }
}
