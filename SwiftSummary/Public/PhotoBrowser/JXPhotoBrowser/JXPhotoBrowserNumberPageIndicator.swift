//
//  JXPhotoBrowserNumberPageIndicator.swift
//  JXPhotoBrowser
//
//  Created by JiongXing on 2019/11/25.
//  Copyright © 2019 JiongXing. All rights reserved.
//

import UIKit

open class JXPhotoBrowserNumberPageIndicator: UILabel, JXPhotoBrowserPageIndicator {
    
    ///  页码与顶部的距离
    open lazy var topPadding: CGFloat = {
        if #available(iOS 11.0, *),
            let window = UIApplication.shared.keyWindow {
            return window.safeAreaInsets.top
        }
        return 20
    }()
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        config()
    }
    
    private func config() {
        font = UIFont.regular(20) //UIFont.systemFont(ofSize: 17)
        textAlignment = .right
        textColor = UIColor.white
//        backgroundColor = UIColor.black.withAlphaComponent(0.5) //UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
//        layer.masksToBounds = true
        
        self.layerCornerRadius = 6
        self.isUserInteractionEnabled = false
    }
    
    public func setup(with browser: JXPhotoBrowser) {
        
    }
    
    private var total: Int = 0
    
    public func reloadData(numberOfItems: Int, pageIndex: Int) {
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
    
    public func didChanged(pageIndex: Int) {
        text = "\(pageIndex + 1)/\(total)"
    }
    
}
