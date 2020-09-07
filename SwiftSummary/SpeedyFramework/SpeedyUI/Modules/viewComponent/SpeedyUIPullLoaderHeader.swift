//
//  SpeedyUIPullLoaderHeader.swift
//  XCamera
//
//  Created by jing_mac on 2019/9/11.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit
import MJRefresh

class SpeedyUIPullLoaderHeader: MJRefreshNormalHeader {
    
    
    override func prepare() {
        super.prepare()
        
        self.lastUpdatedTimeLabel?.isHidden = true
        self.stateLabel?.isHidden = true
//        self.arrowView.image = UIImage(named: "")
    }
    
    override func placeSubviews() {
        super.placeSubviews()
    }

}
