//
//  UITableView+Extension.swift
//  XCamera
//
//  Created by jing_mac on 2019/9/11.
//  Copyright © 2019 xhey. All rights reserved.
//

import Foundation
import UIKit

var tableViewPullLoaderKey = "speedy.ui.tableView.pullLoader"

extension UITableView {
    
    var pullLoader: SpeedyUIPullLoader? {
        set {
            objc_setAssociatedObject(self, &tableViewPullLoaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &tableViewPullLoaderKey) as? SpeedyUIPullLoader
        }
    }
    
    func setPullLoader(style:PullLoaderStyle, onRefresh: @escaping SpeedyUIPullLoaderOnRefreshBlock) {
        
        let loader = SpeedyUIPullLoader.init(scrollView: self, pullStyle: style)
        loader.onRefresh = onRefresh
        self.pullLoader = loader
    }
    
    //通过控件找到indexPath
    func findTableViewIndexPath(view:UIView)->IndexPath?{
        let position: CGPoint = view.convert(.zero, to: self)
        guard let indexPath = self.indexPathForRow(at: position) else{
            return nil
        }
        return indexPath
    }
}
