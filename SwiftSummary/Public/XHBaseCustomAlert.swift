//
//  XHBaseCustomAlert.swift
//  XCamera
//
//  Created by jing_mac on 2019/10/17.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

typealias XHCustomAlertHandler = (XHBaseCustomAlert) -> ()

class XHBaseCustomAlert: UIView {
    
    var backgroundView = UIView.init()
    var contentView = UIView.init()
    
    var completionHandler: XHCustomAlertHandler?
    
    weak var viewController: UIViewController?
    
    deinit {
        XHLogDebug("[deinit] - XHBaseCustomAlert")
    }
    
    @discardableResult class func show(superView: UIView, viewController: UIViewController, complete: @escaping XHCustomAlertHandler) -> XHBaseCustomAlert {
        
        let alert = XHBaseCustomAlert.init()
        alert.viewController = viewController
        superView.addSubview(alert)
        alert.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        alert.show()
        
        return alert
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI() {
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        _ = backgroundView.addTapGestureRecognizer(target: self, action: #selector(backgroundViewTapAction))
        self.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        contentView = UIView.init()
        contentView.backgroundColor = UIColor.white
        contentView.layerCornerRadius = 4.0
        self.addSubview(contentView)
        contentView.snp.makeConstraints({ (make) in
            make.width.equalTo(295)
            make.height.equalTo(352)
            make.centerX.centerY.equalToSuperview()
        })
    }
    
    func show() {
        self.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.alpha = 1.0
            self.backgroundView.alpha = 0.6
        }) { (finished) in
            
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.alpha = 0
            self.backgroundView.alpha = 0
        }) { (finished) in
            self.isHidden = true
            if let handelr = self.completionHandler {
                handelr(self)
            }
            self.removeFromSuperview()
        }
    }
    
    @objc func backgroundViewTapAction() {
        self.hide()
    }
}
