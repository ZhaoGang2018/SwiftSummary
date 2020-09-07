//
//  UICollectionView+SpeedyExtension.swift
//  XCamera
//
//  Created by jing_mac on 2020/7/17.
//  Copyright © 2020 xhey. All rights reserved.
//

import Foundation
import UIKit

var collectionViewPullLoaderKey = "speedy.ui.collectionView.pullLoader"

extension UICollectionView {
    
    var pullLoader: SpeedyUIPullLoader? {
        set {
            objc_setAssociatedObject(self, &collectionViewPullLoaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &collectionViewPullLoaderKey) as? SpeedyUIPullLoader
        }
    }
    
    func setPullLoader(style:PullLoaderStyle, onRefresh: @escaping SpeedyUIPullLoaderOnRefreshBlock) {
        
        let loader = SpeedyUIPullLoader.init(scrollView: self, pullStyle: style, hiddenText: false)
        loader.onRefresh = onRefresh
        self.pullLoader = loader
    }
}
