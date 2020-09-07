//
//  XHCustomLabel.swift
//  XCamera
//
//  Created by jing_mac on 2020/2/26.
//  Copyright © 2020 xhey. All rights reserved.
//  自定义label

import UIKit

enum XHCustomLabelType: Int {
    case oneLineNoIcon = 0  // 一行文字没有图标
    case oneLineHasIcon = 1  // 一行文字有图标
    case twoLineNoIcon = 2  // 两行文字没有图标
    case twoLineHasIcon = 3  // 两行文字有图标
}

class XHCustomLabel: UIView {
    
    var imageView: UIImageView?
    var titleLabel: UILabel?
    var subtitleLabel: UILabel?
    var arrowIcon: UIImageView?
    var line: UIView?
    
    // 图标
    var iconName: String? {
        set {
            if let name = newValue {
                self.imageView?.image = UIImage(named: name)
            }
        }
        
        get {
            return ""
        }
    }
    
    // 设置标题
    var title: String? {
        set {
            self.titleLabel?.text = newValue
        }
        
        get {
            return self.titleLabel?.text
        }
    }
    
    // 副标题
    var subtitle: String? {
        set {
            self.subtitleLabel?.text = newValue
        }
        
        get {
            return self.subtitleLabel?.text
        }
    }
    
    var styleType: XHCustomLabelType = .oneLineNoIcon
    // 手势点击回调
    var onSelectHandler: ((XHCustomLabel) -> ())?
    
    init(type: XHCustomLabelType, iconName: String? = nil, title: String? = nil, subtitle: String? = nil, isHideArrow: Bool = false, isHideLine: Bool = false) {
        super.init(frame: CGRect.zero)
        self.styleType = type
        buildUI()
        self.iconName = iconName
        self.title = title
        self.subtitle = subtitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        self.backgroundColor = UIColor.white
        
        imageView = UIImageView()
        self.addSubview(imageView!)
        
        // 24x48 = 8x16
        arrowIcon = UIImageView.init(image: UIImage(named: "arrow_right_gray"))
        self.addSubview(arrowIcon!)
        
        titleLabel = UILabel(text: "", textColor: UIColor.black, textFont: UIFont.regular(16))
        self.addSubview(titleLabel!)
        
        subtitleLabel = UILabel(text: "", textColor: UIColor.fromHex("#83838C"), textFont: UIFont.regular(14))
        self.addSubview(subtitleLabel!)
        
        var leftPadding: CGFloat = 20.0
        if self.styleType == .oneLineHasIcon || self.styleType == .twoLineHasIcon {
            leftPadding = 68.0
        }
        self.line = self.addLine(position: .bottom, color: UIColor.lineColor(), ply: 1, leftPadding: leftPadding, rightPadding: 0)
        
        _ = self.addTapGestureRecognizer(target: self, action: #selector(tapAction))
        
        self.updateFrame()
    }
    
    private func updateFrame() {
        arrowIcon?.snp.makeConstraints({ (make) in
            make.width.equalTo(8)
            make.height.equalTo(16)
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        })
        
        if self.styleType == .oneLineHasIcon {
            // 一行文字有图标
            subtitleLabel?.textAlignment = .right
            imageView?.snp.makeConstraints({ (make) in
                make.width.height.equalTo(36)
                make.left.equalTo(16)
                make.centerY.equalToSuperview()
            })
            
            titleLabel?.snp.makeConstraints({ (make) in
                make.height.equalTo(22.0)
                make.left.equalTo(imageView!.snp.right).offset(16)
                make.centerY.equalToSuperview()
                make.width.lessThanOrEqualTo(120)
            })
            
            subtitleLabel?.snp.makeConstraints({ (make) in
                make.height.equalTo(22.0)
                make.right.equalTo(arrowIcon!.snp.left).offset(-10)
                make.centerY.equalToSuperview()
                make.left.equalTo(titleLabel!.snp.right).offset(5)
            })
            
        } else if self.styleType == .twoLineHasIcon {
            // 两行文字有图标
            imageView?.snp.makeConstraints({ (make) in
                make.width.height.equalTo(36)
                make.left.equalTo(16)
                make.centerY.equalToSuperview()
            })
            
            titleLabel?.snp.makeConstraints({ (make) in
                make.top.equalTo(14)
                make.left.equalTo(imageView!.snp.right).offset(16)
                make.right.equalTo(-30)
                make.height.equalTo(16)
            })
            
            subtitleLabel?.snp.makeConstraints({ (make) in
                make.top.equalTo(titleLabel!.snp.bottom).offset(8)
                make.left.equalTo(imageView!.snp.right).offset(16)
                make.right.equalTo(-30)
                make.height.equalTo(14)
            })
        } else if self.styleType == .twoLineNoIcon {
            // 两行文字没有图标
            imageView?.isHidden = true
            titleLabel?.snp.makeConstraints({ (make) in
                make.top.equalTo(14)
                make.left.equalTo(20)
                make.right.equalTo(-30)
                make.height.equalTo(16)
            })
            
            subtitleLabel?.snp.makeConstraints({ (make) in
                make.top.equalTo(titleLabel!.snp.bottom).offset(8)
                make.left.equalTo(20)
                make.right.equalTo(-30)
                make.height.equalTo(14)
            })
        } else {
            // 一行文字没有图标
            imageView?.isHidden = true
            subtitleLabel?.textAlignment = .right
            titleLabel?.snp.makeConstraints({ (make) in
                make.height.equalTo(22.0)
                make.left.equalTo(20)
                make.centerY.equalToSuperview()
                make.width.lessThanOrEqualTo(120)
            })
            
            subtitleLabel?.snp.makeConstraints({ (make) in
                make.height.equalTo(22.0)
                make.right.equalTo(arrowIcon!.snp.left).offset(-10)
                make.centerY.equalToSuperview()
                make.left.equalTo(titleLabel!.snp.right).offset(5)
            })
        }
    }
    
    // MARK: - 点击方法
    @objc private func tapAction() {
        if let handler = self.onSelectHandler {
            handler(self)
        }
    }
}
