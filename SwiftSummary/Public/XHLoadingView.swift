//
//  XHLoadingView.swift
//  XCamera
//
//  Created by jing_mac on 2020/5/21.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit

typealias XHLoadingCancelHandler = () -> ()

extension UIView {
    
    func showLoading(tipText: String = "正在加载", isShowCloseBtn: Bool = false, cancelHandler: XHLoadingCancelHandler? = nil) {
        
        let tipView = XHLoadingView(tipText: tipText, isShowCloseBtn: isShowCloseBtn, cancelHandler: cancelHandler)
        tipView.tag = 10003
        self.addSubview(tipView)
        tipView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
        tipView.start()
    }
    
    func hiddenLoading() {
        if let loadingView = self.viewWithTag(10003) as? XHLoadingView {
            loadingView.stop()
            loadingView.removeFromSuperview()
        }
    }
    
    func showIndicatorLoading(tipText: String = "正在加载…", topOffset: CGFloat = SpeedyApp.statusBarAndNavigationBarHeight) {
        
        let tipView = XHIndicatorLoadingView(tipText: tipText)
        tipView.tag = 10004
        self.addSubview(tipView)
        tipView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(topOffset)
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(SpeedyApp.screenHeight-topOffset)
        }
        
        tipView.start()
    }
    
    func hiddenIndicatorLoading() {
        if let loadingView = self.viewWithTag(10004) as? XHIndicatorLoadingView {
            loadingView.stop()
            loadingView.removeFromSuperview()
        }
    }
}

class XHLoadingView: UIView {
    
    var cancelHandler: (() -> ())?
    
    var tipText: String = "正在加载"
    var isShowCloseBtn: Bool = false
    
    private var contentView: UIView?
    private var whiteView: UIView?
    private var imageView: UIImageView?
    private var tipLabel: UILabel?
    private var closeBtn: UIButton?
    
    private var animateId: String = "rotate"
    private var animate: CABasicAnimation?
    
    deinit {
        XHLogDebug("deinit - XHLoadingView")
    }
    
    init(tipText: String = "正在加载", isShowCloseBtn: Bool = false, cancelHandler: XHLoadingCancelHandler? = nil) {
        super.init(frame: CGRect.zero)
        
        self.tipText = tipText
        self.isShowCloseBtn = isShowCloseBtn
        self.cancelHandler = cancelHandler
        buildUI()
        
        self.closeBtn?.isHidden = !self.isShowCloseBtn
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        
        animate = CABasicAnimation(keyPath: "transform.rotation.z")
        animate?.duration = 1.5
        animate?.repeatCount = Float.greatestFiniteMagnitude
        animate?.fromValue = 0
        animate?.toValue = CGFloat.pi * 2
        animate?.isRemovedOnCompletion = false
        animate?.fillMode = CAMediaTimingFillMode.forwards
        
        contentView = UIView()
        contentView?.layer.shadowOffset = CGSize(width: 0, height: 14)
        contentView?.layer.shadowColor = UIColor.UIColorFromRGBA(0, g: 0, b: 0, a: 0.25).cgColor
        contentView?.layer.shadowRadius = 30
        contentView?.layer.shadowOpacity = 1
        self.addSubview(contentView!)
        contentView?.snp.makeConstraints { (make) in
            make.width.equalTo(175)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        whiteView = UIView(backgroundColor: UIColor.white, cornerRadius: 10)
        contentView?.addSubview(whiteView!)
        whiteView?.snp.makeConstraints({ (make) in
            make.top.left.width.height.equalToSuperview()
        })
        
        imageView = UIImageView(imageName: "hint_loading")
        contentView?.addSubview(imageView!)
        imageView?.snp.makeConstraints({ (make) in
            make.width.height.equalTo(34)
            make.top.equalTo(18)
            make.centerX.equalToSuperview()
        })
        
        tipLabel = UILabel(text: self.tipText, textColor: UIColor.UIColorFromHex(0x4a4b53), textFont: UIFont.boldSystemFont(ofSize: 16), textAlignment: .center)
        tipLabel?.sizeToFit()
        contentView?.addSubview(tipLabel!)
        tipLabel?.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(60)
            make.height.equalTo(20)
        })
        
        closeBtn = UIButton(imageName: "btn_close_gray")
        closeBtn?.addTarget(self, action: #selector(closeButtonAction(sender:)), for: .touchUpInside)
        contentView?.addSubview(closeBtn!)
        closeBtn?.snp.makeConstraints({ (make) in
            make.width.height.equalTo(40)
            make.top.right.equalToSuperview()
        })
    }
    
    func start() {
        if let animate = self.animate {
            imageView?.layer.add(animate, forKey: animateId)
        }
    }
    
    func stop() {
        imageView?.layer.removeAnimation(forKey: animateId)
    }
    
    // 关闭按钮的点击方法
    @objc private func closeButtonAction(sender: UIButton) {
        self.stop()
        if let handler = self.cancelHandler {
            handler()
        }
        self.removeFromSuperview()
    }
    
}

class XHIndicatorLoadingView: UIView {
    
    var tipText: String = "正在加载…"
    
    private var contentView: UIView?
    private var tipLabel: UILabel?
    
    private var animateId: String = "rotate"
    private var animate: CABasicAnimation?
    private var indicatorView:UIActivityIndicatorView?
        
    deinit {
        XHLogDebug("deinit - XHLoadingView")
    }
    
    init(tipText: String = "正在加载…") {
        super.init(frame: CGRect.zero)
        
        self.tipText = tipText
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        
        contentView = UIView()
        contentView?.layer.shadowOffset = CGSize(width: 0, height: 14)
        contentView?.layer.shadowColor = UIColor.UIColorFromRGBA(0, g: 0, b: 0, a: 0.25).cgColor
        contentView?.layer.shadowRadius = 30
        contentView?.layer.shadowOpacity = 1
        self.addSubview(contentView!)
        contentView?.snp.makeConstraints { (make) in
            make.width.equalTo(175)
            make.height.equalTo(70)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-SpeedyApp.statusBarAndNavigationBarHeight)
        }
    
        
        indicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        contentView?.addSubview(indicatorView!)
        indicatorView?.snp.makeConstraints({ (make) in
            make.width.height.equalTo(40)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        })
        indicatorView?.startAnimating()
        
        tipLabel = UILabel(text: self.tipText, textColor: UIColor.UIColorFromHex(0x83838C), textFont: UIFont.regular(16), textAlignment: .center)
        tipLabel?.sizeToFit()
        contentView?.addSubview(tipLabel!)
        tipLabel?.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(indicatorView!.snp.bottom).offset(5)
            make.height.equalTo(20)
        })
    }
    
    func start() {
        indicatorView?.startAnimating()
    }
    
    func stop() {
        indicatorView?.stopAnimating()
    }
   
}
