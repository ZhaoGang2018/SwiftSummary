//
//  ZGXibTestViewController.swift
//  SwiftSummary
//
//  Created by jing_mac on 2020/4/17.
//  Copyright © 2020 jing_mac. All rights reserved.
//

import UIKit

class ZGXibTestViewController: XHBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "XibTest"
        
        if let apparray = Bundle.main.loadNibNamed("ZGXibTestView", owner: nil, options: nil),
            let labelView = apparray.first as? ZGXibTestView {
            
            labelView.backgroundColor = UIColor.yellow
            view.addSubview(labelView)
            // 方法1：
            //  labelView.frame = CGRect(x: 0, y: 300, width: SpeedyApp.screenWidth, height: 60)
            
            // 方法2：
            labelView.snp.makeConstraints { (make) in
                make.top.equalTo(300)
                make.left.right.equalToSuperview()
                make.height.equalTo(60)
            }
        }
    }
    
    
}
