//
//  UINib+UIView.swift
//  XCamera
//
//  Created by jing_mac on 2020/7/10.
//  Copyright © 2020 xhey. All rights reserved.
//

import Foundation

extension UINib {
    
    // MARK: - 通过UINib创建UIView
    
    /// 通过UINib创建UIView
    /// - Parameters:
    ///   - nibName: xib的名字
    ///   - classType: View的类名
    /// - Returns: 返回View
    class func buildView<T: UIView>(nibName: String, classType: T.Type) -> T? {
        
        if nibName.count == 0 {
            return nil
        }
        
        if let resultView = UINib(nibName: nibName, bundle: .main).instantiate(withOwner: nil, options: nil).first as? T {
            return resultView
        }
        return nil
    }
}
