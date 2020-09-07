//
//  UITextField+Extension.swift
//  XCamera
//
//  Created by jing_mac on 2019/10/14.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

extension UITextField {
    
    convenience init(text: String?, textColor: UIColor, textFont: UIFont?, placeholder: String?, placeholderColor: UIColor?, placeholderFont: UIFont?, returnKeyType: UIReturnKeyType = .done, keyboardType: UIKeyboardType? = nil, clearButtonMode: UITextField.ViewMode? = nil, enablesReturnKeyAutomatically: Bool? = nil) {
        
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = textFont
        
        self.placeholder = placeholder
        if let color = placeholderColor, let font = placeholderFont{
            self.setPlaceholder(placeholderColor: color, placeholderFont: font)
        }
        
        self.returnKeyType = returnKeyType
        
        if let type = keyboardType {
            self.keyboardType = type
        }
        
        if let tempMode = clearButtonMode {
            self.clearButtonMode = tempMode
        }
        
        // 当输入框没有文字的时候，右下角按钮自动致灰
        if let isEnble = enablesReturnKeyAutomatically {
            self.enablesReturnKeyAutomatically = isEnble
        }
    }
    
    // MARK: - 设置placeholder的颜色和字体
    func setPlaceholder(placeholderColor: UIColor, placeholderFont: UIFont){
        if let placeholderStr = self.placeholder, placeholderStr.count > 0 {
            self.attributedPlaceholder = NSAttributedString.init(string: placeholderStr, attributes: [NSAttributedString.Key.foregroundColor : placeholderColor, NSAttributedString.Key.font : placeholderFont])
        }
    }
}
