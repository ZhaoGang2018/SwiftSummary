//
//  XHTitleArrowsLabel.swift
//  XCamera
//
//  Created by jing_mac on 2019/10/15.
//  Copyright © 2019 xhey. All rights reserved.
//  标题+详情+箭头的自定义label

import UIKit

class XHTitleArrowsLabel: UIView {
    
    var titleLabel: UILabel?
    var detailLabel: UILabel?
    var imageView: UIImageView?
    var arrowIcon: UIImageView?
    var line: UIView?
    
    var onSelect: (() -> ())?
    
    private var titleMaxWidth: CGFloat = 120
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String?, detail: String?, isShowImage: Bool = false, isShowArrow: Bool = true, isShowLine: Bool = true, titleColor: UIColor = UIColor.black, titleFont: UIFont = UIFont.regular(16.0), detailColor: UIColor = UIColor.black, detailFont: UIFont = UIFont.regular(16.0), titleMaxWidth: CGFloat = 120) {
        
        super.init(frame: CGRect.zero)
        self.titleMaxWidth = titleMaxWidth
        
        buildUI()
        self.titleLabel?.text = title
        self.detailLabel?.text = detail
        self.imageView?.isHidden = !isShowImage
        self.detailLabel?.isHidden = isShowImage
        self.arrowIcon?.isHidden = !isShowArrow
        self.line?.isHidden = !isShowLine
        self.titleLabel?.textColor = titleColor
        self.detailLabel?.textColor = detailColor
    }
    
    private func buildUI() {
        self.backgroundColor = UIColor.white
        
        titleLabel = UILabel(text: "", textColor: UIColor.black, textFont: UIFont.regular(16.0))
        self.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(20)
            make.width.lessThanOrEqualTo(titleMaxWidth)
            make.top.bottom.equalToSuperview()
        })
        
        // 24x48 = 8x16
        arrowIcon = UIImageView.init(image: UIImage(named: "arrow_right_gray"))
        self.addSubview(arrowIcon!)
        arrowIcon?.snp.makeConstraints({ (make) in
            make.width.equalTo(8)
            make.height.equalTo(16)
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        })
        
        detailLabel = UILabel(text: "", textColor: UIColor.black, textFont: UIFont.regular(16.0), textAlignment: .right)
        self.addSubview(detailLabel!)
        detailLabel?.snp.makeConstraints({ (make) in
            make.right.equalTo(arrowIcon!.snp.left).offset(-10)
            make.left.equalTo(titleLabel!.snp.right).offset(5)
            make.top.bottom.equalToSuperview()
        })
        
        imageView = UIImageView()
        imageView?.layerCornerRadius = 3
        self.addSubview(imageView!)
        imageView?.snp.makeConstraints({ (make) in
            make.width.height.equalTo(40)
            make.right.equalTo(arrowIcon!.snp.left).offset(-10)
            make.centerY.equalToSuperview()
        })
        imageView?.isHidden = true
        
        line = self.addLine(position: .bottom, color: UIColor.lineColor(), ply: 1, leftPadding: 20, rightPadding: 0)
        
        _ = self.addTapGestureRecognizer(target: self, action: #selector(tapAction))
    }
    
    @objc private func tapAction() {
        if let handler = self.onSelect {
            handler()
        }
    }
    
}
