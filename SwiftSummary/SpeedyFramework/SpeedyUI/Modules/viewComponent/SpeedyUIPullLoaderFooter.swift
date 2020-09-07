//
//  SpeedyUIPullLoaderFooter.swift
//  XCamera
//
//  Created by jing_mac on 2019/9/11.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit
import MJRefresh

class SpeedyUIPullLoaderFooter: MJRefreshAutoNormalFooter {
    
    override func prepare() {
        super.prepare()
        self.stateLabel?.isHidden = true
        self.isRefreshingTitleHidden = true
        self.setTitle("", for: .idle)
        self.setTitle("", for: .noMoreData)
        self.setTitle("正在加载...", for: .pulling)
        self.setTitle("正在加载...", for: .refreshing)
        self.setTitle("正在加载...", for: .willRefresh)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
    }
}
