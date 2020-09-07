//
//  XHInputBoxView.swift
//  XCamera
//
//  Created by jing_mac on 2020/4/21.
//  Copyright © 2020 xhey. All rights reserved.
//  输入框

import UIKit

class XHInputBoxView: UIView {
    
    // 完成的回调
    var completionHandler: ((String) -> ())?
    // 取消的回调
    var cancelHandler: (() -> ())?
    // 输入框高度的变化回调
    var heightWillChangeHandler: ((CGFloat) -> ())?
    
    var keyboardHideHandler: (() -> ())?
    
    var placeholder: String = "评论" {
        didSet {
            self.placeholderLabel?.text = placeholder
        }
    }
    
    var keyBoardHeight: CGFloat = 0.0
    
    private var bigBtn: UIButton?
    private var inputBg: UIView?
    private var textView: UITextView?
    private var placeholderLabel: UILabel?
    
    // 允许输入的最大字符数，1个汉字 = 2个字符
    var maxCount: Int = 600
    
    init(superView: UIView, maxCount: Int = 600) {
        super.init(frame: CGRect.zero)
        self.maxCount = maxCount
        buildUI()
        
        superView.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.top.left.width.height.equalToSuperview()
        }
        self.isHidden = true
        
        addKeyboardNotification()
        self.resetUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeKeyboardNotification()
        XHLogDebug("deinit - XHInputBoxView")
    }
    
    func show() {
        self.isHidden = false
        self.textView?.becomeFirstResponder()
        updatePlaceholderLabelState()
    }
    
    func hide() {
        self.textView?.resignFirstResponder()
        updatePlaceholderLabelState()
    }
    
    // MARK: - 点击事件
    @objc private func bigButtonClicked() {
        self.textView?.resignFirstResponder()
        self.cancelHandler?()
        updatePlaceholderLabelState()
    }
    
    private func sendButtonAction() {
        updatePlaceholderLabelState()
        self.textView?.resignFirstResponder()
        if let text = textView?.text, text.count > 0 {
            self.completionHandler?(text)
            self.resetUI()
        } else {
            self.showToast("输入内容不能为空！")
        }
    }
    
    private func resetUI() {
        self.textView?.text = ""
        self.inputBg?.snp.updateConstraints({ (make) in
            make.height.equalTo(56)
        })
        
        self.textView?.layoutSubviews()
        updatePlaceholderLabelState()
    }
}

// MARK: - 构建UI
extension XHInputBoxView {
    private func buildUI() {
        
        // 用于隐藏键盘
        bigBtn = UIButton()
        bigBtn?.addTarget(self, action: #selector(bigButtonClicked), for: .touchUpInside)
        bigBtn?.backgroundColor = UIColor.clear
        self.addSubview(bigBtn!)
        bigBtn?.snp.makeConstraints { (make) in
            make.top.left.width.height.equalToSuperview()
        }
        bigBtn?.isHidden = true
        
        inputBg = UIView()
        inputBg?.isUserInteractionEnabled = true
        inputBg?.backgroundColor = UIColor.fromHex("#F6F6F6")
        self.addSubview(inputBg!)
        inputBg?.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
            make.bottom.equalTo(56)
        })
        
        let textViewBg = UIView(backgroundColor: UIColor.white, cornerRadius: 4.0)
        inputBg?.addSubview(textViewBg)
        textViewBg.snp.makeConstraints { (make) in
            make.top.left.equalTo(8)
            make.right.bottom.equalTo(-8)
        }
        
        textView = UITextView()
        textView?.delegate = self
        textView?.textColor = UIColor.black
        textView?.font = UIFont.regular(16)
        textView?.returnKeyType = .send
        textView?.enablesReturnKeyAutomatically = true
        textView?.backgroundColor = UIColor.white
        textViewBg.addSubview(textView!)
        textView?.snp.makeConstraints({ (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(9)
            make.right.equalTo(-9)
        })
        
        self.placeholderLabel = UILabel(text: "评论", textColor: UIColor.fromHex("#B0B2BE"), textFont: UIFont.regular(16))
        self.inputBg?.addSubview(self.placeholderLabel!)
        self.placeholderLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(16)
            make.centerY.equalToSuperview()
        })
    }
}

// MARKL - 键盘弹起和收起的通知
extension XHInputBoxView {
    
    private func addKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification){
        
        // 1.获取动画执行的时间
        var animationDuration: Double = 0.25
        if let userInfo = notification.userInfo, let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            //2. 获取键盘最终的Y值
            let y = endFrame.origin.y
            
            //3.计算工具栏距离底部的间距
            let margin = UIScreen.main.bounds.height - y
            
            self.keyBoardHeight = margin
            
            if let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double, duration > 0 {
                animationDuration = duration
            }
            
            //4.执行动画
            UIView.animate(withDuration: animationDuration, animations: {
                self.inputBg?.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(-margin)
                })
                self.layoutIfNeeded()
            }) { (isSuccess) in
                
            }
            
            if let handler = self.heightWillChangeHandler {
                let inputBg_h = self.inputBg?.viewFrameHeight ?? 56
                let resultH = self.keyBoardHeight + inputBg_h
                handler(resultH)
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification:Notification){
        var animationDuration: Double = 0.25
        if let userInfo = notification.userInfo, let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            animationDuration = duration
            
            let input_h = self.inputBg?.viewFrameHeight ?? 56
            
            UIView.animate(withDuration: animationDuration, animations: {
                self.inputBg?.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(input_h)
                })
                self.layoutIfNeeded()
            }) { (isSuccess) in
                self.isHidden = true
            }
            
            self.keyBoardHeight = 0.0
        }
        
        self.keyboardHideHandler?()
    }
}


extension XHInputBoxView: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.bigBtn?.isHidden = false
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.bigBtn?.isHidden = true
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if let selectedRange = textView.markedTextRange,
            let newText = textView.text(in: selectedRange), newText.count > 0  {
            self.updatePlaceholderLabelState()
            return
        }
        
        if let toBeString = textView.text, toBeString.numberOfChars() > self.maxCount {
            textView.text = toBeString.speedySubString(to: self.maxCount)
        }
        
        self.updatePlaceholderLabelState()
        self.refreshHeight(with: textView.text ?? "")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            self.sendButtonAction()
            return false
        }
        return true
    }
    
    // 更新placeholder的状态
    private func updatePlaceholderLabelState() {
        self.placeholderLabel?.isHidden = self.textView?.text.count ?? 0 > 0
    }
    
    // 根据文本刷新高度
    private func refreshHeight(with text: String) {
        
        if let font = textView?.font {
            let height = text.size(WithFont: font, ConstrainedToWidth: SpeedyApp.screenWidth - 17.0*2.0).height
            
//            XHLogDebug("[输入框调试] - textView的高度[\(height)]")
            
            if textView?.isScrollEnabled == true {
                textView?.isScrollEnabled = false
            }
            
            var inputBg_h: CGFloat = 56.0
            if height >= 132 {
                inputBg_h = 164
                
                if textView?.isScrollEnabled == false {
                    textView?.isScrollEnabled = true
                }
            } else if height < 132 && height > 24 {
                inputBg_h = height + 16 + 16 + 5
            } else {
                inputBg_h = 56.0
            }
            
            UIView.animate(withDuration: 0.1) {
                self.inputBg?.snp.updateConstraints({ (make) in
                    make.height.equalTo(inputBg_h)
                })
                self.layoutIfNeeded()
            }
            
            if let handler = self.heightWillChangeHandler {
                let resultH = self.keyBoardHeight + inputBg_h
                handler(resultH)
            }
        }
    }
    
    
    
}
