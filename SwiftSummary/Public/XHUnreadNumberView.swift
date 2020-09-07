//
//  XHUnreadNumberView.swift
//  XCamera
//
//  Created by jing_mac on 2020/6/15.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit

class XHUnreadNumberView: UIView {
    
    var unreadImage: UIImageView?
    var unreadLabel: UILabel?
    
    var hasWhiteBorder: Bool = false
    
    private var bigImageName: String {
        if self.hasWhiteBorder {
            return "workgroup_overview_update_dot_camera_big"
        }
        return "workgroup_overview_update_dot_big"
    }
    
    private var smallImageName: String {
        if self.hasWhiteBorder {
            return "workgroup_overview_update_dot_camera_small"
        }
        return "workgroup_overview_update_dot_small"
    }
    
    deinit {
        XHLogDebug("deinit - XHUnreadNumberView")
    }
    
    init(hasWhiteBorder: Bool) {
        super.init(frame: CGRect.zero)
        self.hasWhiteBorder = hasWhiteBorder
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        unreadImage = UIImageView(imageName: self.smallImageName)
        self.addSubview(unreadImage!)
        unreadImage?.snp.makeConstraints({ (make) in
            make.top.left.width.height.equalToSuperview()
        })
        
        unreadLabel = UILabel(text: "", textColor: UIColor.white, textFont: UIFont.Semibold(12), textAlignment: .center)
        self.addSubview(unreadLabel!)
        unreadLabel?.snp.makeConstraints({ (make) in
            make.top.left.width.height.equalToSuperview()
        })
    }
    
    func updateUnreadNumber(_ unreadNum: Int) {
        if unreadNum <= 0 {
            self.isHidden = true
        } else if unreadNum >= 100 {
            self.isHidden = false
            self.unreadLabel?.text = "99+"
            unreadImage?.image = UIImage(named: self.bigImageName)
            
            if let _ = self.superview {
                self.snp.updateConstraints { (make) in
                    make.width.equalTo(37)
                    make.height.equalTo(20)
                }
            }
        } else {
            self.isHidden = false
            self.unreadLabel?.text = "\(unreadNum)"
            unreadImage?.image = UIImage(named: self.smallImageName)
            
            if let _ = self.superview {
                self.snp.updateConstraints { (make) in
                    make.width.height.equalTo(20)
                }
            }
        }
        
        self.layoutIfNeeded()
    }
}

