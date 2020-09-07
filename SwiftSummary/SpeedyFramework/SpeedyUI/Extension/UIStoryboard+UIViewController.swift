//
//  UIStoryboard+UIViewController.swift
//  XCamera
//
//  Created by jing_mac on 2020/7/2.
//  Copyright © 2020 xhey. All rights reserved.
//

import Foundation

extension UIStoryboard {
    
    // MARK: - 通过UIStoryboard创建UIViewController
    
    /// 通过UIStoryboard创建UIViewController
    /// - Parameters:
    ///   - storyboardName: UIStoryboard的名字
    ///   - classType: VC的类名
    ///   - identifier: 唯一标识，默认和类名一样，如果不一样需要在外面设置
    /// - Returns: 返回VC
    class func buildViewController<T: UIViewController>(storyboardName: String, classType: T.Type, identifier: String = T.nameOfClass) -> T? {
        
        if identifier.count == 0 {
            return nil
        }
        
        let vc = self.init(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: identifier) as? T
        return vc
    }
}
