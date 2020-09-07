//
//  XHEmptyTipView.swift
//  XCamera
//
//  Created by jing_mac on 2019/11/5.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

typealias XHEmptyTipViewDidSelected = () -> ()

extension UIView {
    
    @discardableResult func showEmptyTipView(text: String? = "数据列表是空的", buttonTitle: String? = "重试", isShowButton: Bool = true, onSelect: XHEmptyTipViewDidSelected? = nil) -> XHEmptyTipView {
        
        self.hideEmptyTipView()
        
        let tipView = XHEmptyTipView.init()
        tipView.selectHandler = onSelect
        tipView.tag = 10002
        if let tempText = text, !tempText.isEmpty {
            tipView.tipLabel?.text = tempText
        }
        
        if let btnTitle = buttonTitle, !btnTitle.isEmpty {
            tipView.retryButton?.btnTitle = btnTitle
        }
        
        tipView.retryButton?.isHidden = !isShowButton
        
        self.addSubview(tipView)
        tipView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        return tipView
    }
    
    func hideEmptyTipView() {
        if let errorView = self.viewWithTag(10001) {
            errorView.removeFromSuperview()
        }
        
        if let emptyView = self.viewWithTag(10002) {
            emptyView.removeFromSuperview()
        }
    }
}


class XHEmptyTipView: UIView {
    
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
        
        tipLabel = UILabel(text: "数据列表是空的", textColor: UIColor(hex: "#83838C"), textFont: UIFont.regular(20), textAlignment: .center, numberLines: 0)
        tipLabel?.isUserInteractionEnabled = false
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
