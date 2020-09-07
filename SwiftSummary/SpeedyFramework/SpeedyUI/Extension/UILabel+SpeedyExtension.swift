//
//  UILabel+Extension.swift
//  XCamera
//
//  Created by jing_mac on 2019/9/2.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// UILabel根据文字的需要的高度
    public var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(
            x: 0,
            y: 0,
            width: frame.width,
            height: CGFloat.greatestFiniteMagnitude)
        )
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
    
    /// UILabel根据文字实际的行数
    public var actualLines: Int {
        return Int(requiredHeight / font.lineHeight)
    }
    
    /// 便利构造方法
    convenience init(text: String?, textColor: UIColor?, textFont: UIFont?, textAlignment: NSTextAlignment? = nil, numberLines: Int? = nil, backgroundColor: UIColor? = nil, cornerRadius: CGFloat? = nil) {
        
        self.init()
        
        self.text = text
        self.textColor = textColor ?? UIColor.black
        self.font = textFont ?? UIFont.systemFont(ofSize: 17.0)
        
        if let ali = textAlignment {
            self.textAlignment = ali
        }
        
        if let number = numberLines {
            self.numberOfLines = number
        }
        
        if let bgColor = backgroundColor {
            self.backgroundColor = bgColor
        }
        
        if let radius = cornerRadius {
            self.layerCornerRadius = radius
        }
        
        self.clipsToBounds = false
    }
    
    // 文字渐变色
    func textGradient(colors: [UIColor]) {
        
        if let testImage = UIImage.imageWithGradientColors(colors: colors, size: (self.frame.size)) {
            self.textColor = UIColor.init(patternImage: testImage)
        }
    }
    
    // 限制宽度计算实际的行数
    func actualLinesConstrainedToWidth(maxWidth: CGFloat) -> Int {
        var height: CGFloat = 0
        if let tempText = self.text {
            height = tempText.size(WithFont: self.font, ConstrainedToWidth: maxWidth).height
        }
        return Int(height / font.lineHeight)
    }
    
    // 限制宽度计算实际的高度
    func actualHeight(maxWidth: CGFloat,maxLine:Int = 0) -> CGFloat {
        let label = UILabel(frame: CGRect(
            x: 0,
            y: 0,
            width: maxWidth,
            height: CGFloat.greatestFiniteMagnitude)
        )
        label.numberOfLines = 0
        label.backgroundColor = backgroundColor
        label.lineBreakMode = lineBreakMode
        label.font = font
        label.text = text
        label.textAlignment = textAlignment
        label.numberOfLines = maxLine
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
}

