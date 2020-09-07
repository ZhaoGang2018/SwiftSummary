//
//  HintProtocols.swift
//  ShowHint
//
//  Created by Swaying on 2017/12/14.
//  Copyright © 2017年 xhey. All rights reserved.
//

import UIKit

protocol HintTextView {
    var text: String? { get set }
    func sizeToFit()
    func view() -> UIView
}

extension UILabel: HintTextView {
    func view() -> UIView {
        return self
    }
}
