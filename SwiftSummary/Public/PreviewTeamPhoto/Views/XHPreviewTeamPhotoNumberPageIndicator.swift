//
//  XHPreviewTeamPhotoNumberPageIndicator.swift
//  XCamera
//
//  Created by jing_mac on 2020/9/7.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit

class XHPreviewTeamPhotoNumberPageIndicator: JXPhotoBrowserNumberPageIndicator {
    
    deinit {
        XHLogDebug("deinit - [图片或视频预览调试] - XHPreviewTeamPhotoNumberPageIndicator")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        buildUI()
    }
    
    func buildUI() {
        font = UIFont.regular(20) //UIFont.systemFont(ofSize: 17)
        textAlignment = .right
        textColor = UIColor.white
        //        backgroundColor = UIColor.black.withAlphaComponent(0.5) //UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        //        layer.masksToBounds = true
        
        self.layerCornerRadius = 6
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor.clear
    }
    

    private var total: Int = 0
    
    public override func reloadData(numberOfItems: Int, pageIndex: Int) {
        total = numberOfItems
        text = "\(pageIndex + 1)/\(total)"
        
        /*
         sizeToFit()
         frame.size.width += frame.height
         layer.cornerRadius = frame.height / 2
         if let view = superview {
         center.x = view.bounds.width / 2
         frame.origin.y = topPadding
         }
         isHidden = numberOfItems <= 1
         */
        self.frame = CGRect(x: 20, y: SpeedyApp.statusBarHeight + 10, width: SpeedyApp.screenWidth - 40, height: 36)
    }
    
    public override func didChanged(pageIndex: Int) {
        text = "\(pageIndex + 1)/\(total)"
    }
}
