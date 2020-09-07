//
//  XHNewbieGuideView.swift
//  XCamera
//
//  Created by jing_mac on 2020/2/27.
//  Copyright © 2020 xhey. All rights reserved.
//  新手引导

import UIKit

typealias XHNewbieGuideHandler = (XHNewbieGuideView) -> ()

class XHNewbieGuideView: UIView {
    
    var tipText: String = ""
    var onSelectHandler: XHNewbieGuideHandler?
    var onCloseHandler: XHNewbieGuideHandler?
    
    init(tipText: String, point:CGPoint, onSelect: XHNewbieGuideHandler?, onClose: XHNewbieGuideHandler?) {
        self.tipText = tipText
        self.onSelectHandler = onSelect
        self.onCloseHandler = onClose
        super.init(frame: CGRect(x: point.x, y: point.y, width: 168.0, height: 46.0))
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        let bgView = UIView()
        bgView.layerCornerRadius = 7.0
        bgView.backgroundColor = UIColor.blueColor_xh()
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(38.0)
        }
        
        let tipLabel = UILabel(text: self.tipText, textColor: UIColor.white, textFont: UIFont.Semibold(14.0), textAlignment: .center)
        _ = tipLabel.addTapGestureRecognizer(target: self, action: #selector(tipLabelTapAction))
        bgView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(-34)
        }
        
        let closeButton = UIButton(imageName: "join_new_group_tip_close_icon")
        closeButton.addTarget(self, action: #selector(closeButtonAction(sender:)), for: .touchUpInside)
        bgView.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.width.equalTo(34)
            make.height.equalTo(38.0)
            make.top.right.equalToSuperview()
        }
        
        let arrowImage = UIImageView.init(image: UIImage(named: "join_new_group_tip_arrow_icon"))
        self.addSubview(arrowImage)
        arrowImage.snp.makeConstraints { (make) in
            make.width.equalTo(16.0)
            make.height.equalTo(8.0)
            make.top.equalTo(bgView.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func tipLabelTapAction() {
        if let handler = self.onSelectHandler {
            handler(self)
        }
    }
    
    @objc private func closeButtonAction(sender: UIButton) {
        if let handler = self.onCloseHandler {
            handler(self)
        }
    }
}
