//
//  XHNetworkErrorTipView.swift
//  XCamera
//
//  Created by jing_mac on 2019/10/7.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

typealias XHNetworkErrorTipViewDidSelected = () -> ()

extension UIView {
    
    func showNetworkErrorTip(didSelect: @escaping XHNetworkErrorTipViewDidSelected) -> XHNetworkErrorTipView {
        self.hideNetworkErrorTip()
        
        let tipView = XHNetworkErrorTipView.init()
        tipView.selectHandler = didSelect
        tipView.tag = 10001
        self.addSubview(tipView)
        tipView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        return tipView
    }
    
    func hideNetworkErrorTip() {
        if let errorView = self.viewWithTag(10001) {
            errorView.removeFromSuperview()
        }
        
        if let emptyView = self.viewWithTag(10002) {
            emptyView.removeFromSuperview()
        }
    }
}

// MARK: - XHNetworkErrorTipView
class XHNetworkErrorTipView: UIView {
    
    var tipLabel: UILabel?
    var retryButton: UIButton?
    var selectHandler: XHNetworkErrorTipViewDidSelected?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        
        tipLabel = UILabel(text: "网络不给力", textColor: UIColor(hex: "#83838C"), textFont: UIFont.regular(20), textAlignment: .center)
        self.addSubview(tipLabel!)
        tipLabel?.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(20.0)
            make.centerY.equalToSuperview().offset(-56)
        })
        
        retryButton = UIButton(title: "重试", titleColor: UIColor.white, titleFont: UIFont.Semibold(18), backgroundColor: UIColor.blueColor_xh(), cornerRadius: 6)
        retryButton?.addTarget(self, action: #selector(reload), for: .touchUpInside)
        self.addSubview(retryButton!)
        retryButton?.snp.makeConstraints({ (make) in
            make.width.equalTo(230)
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
            make.top.equalTo(tipLabel!.snp.bottom).offset(40.0)
        })
    }
    
    @objc private func reload() {
        if let handler = self.selectHandler {
            handler()
        }
    }
}
