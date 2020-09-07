//
//  XHKeyboardManager.swift
//  XCamera
//
//  Created by jing_mac on 2019/12/17.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class XHKeyboardManager: NSObject {
    
    // 在APPDelegate里配置信息，默认全局使用
    class func configIQKeyboardManager() {
        
        let keyboardManager = IQKeyboardManager.shared
        //开启日志
        keyboardManager.enableDebugging = false
        // 控制整个功能是否启用
        keyboardManager.enable = true
        // 控制点击背景是否收起键盘
        keyboardManager.shouldResignOnTouchOutside = true
        // 控制键盘上的工具条文字颜色是否用户自定义
        keyboardManager.shouldToolbarUsesTextFieldTintColor = true
        // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
        keyboardManager.toolbarManageBehaviour = .bySubviews
        // 控制是否显示键盘上的工具条
        keyboardManager.enableAutoToolbar = false
        keyboardManager.placeholderColor = UIColor.black
        keyboardManager.placeholderFont = UIFont.regular(17)
        // 输入框距离键盘的距离
        keyboardManager.keyboardDistanceFromTextField = 20
        keyboardManager.shouldShowToolbarPlaceholder = false
    }
    
    /**
     * 是否禁用IQKeyboardManager
     * 默认全局使用，如果再某个界面禁用需要在viewWillAppear里禁用，viewWillDisappear里使用
     * @param enable YES:使用  NO:禁用
     */
    class func setKeyboardManagerEnable(isEnable: Bool) {
        IQKeyboardManager.shared.enable = isEnable
    }
    
}
