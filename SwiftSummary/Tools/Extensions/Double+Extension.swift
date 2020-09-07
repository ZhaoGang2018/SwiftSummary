//
//  Double+Extension.swift
//  XCamera
//
//  Created by Quinn Von on 2019/12/6.
//  Copyright © 2019 xhey. All rights reserved.
//

import Foundation
extension Double {

    /// Rounds the double to decimal places value

    func roundTo(places:Int) -> Double {

        let divisor = pow(10.0, Double(places))

        return (self * divisor).rounded() / divisor

    }

}
