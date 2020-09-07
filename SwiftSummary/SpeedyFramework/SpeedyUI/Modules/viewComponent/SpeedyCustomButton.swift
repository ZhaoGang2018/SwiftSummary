//
//  SpeedyCustomButton.swift
//  XCamera
//
//  Created by jing_mac on 2020/8/27.
//  Copyright © 2020 xhey. All rights reserved.
//  可以自定义UIButton上图片和文字位置的按钮

import UIKit

public typealias SpeedySubviewLayoutHandle = (_ weakButton: SpeedyCustomButton?) -> ()

public class SpeedyCustomButton: SpeedyDisableMultipleClickButton {
    
    // 外部定义标题的位置
    var titleRect: CGRect? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // 外部定义图片的位置
    var imageRect: CGRect? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var tagString: String = ""
    
    public var subviewLayoutHandle: SpeedySubviewLayoutHandle?
    
    // 便利构造方法，在外面设置frame
    public convenience init(type buttonType: UIButton.ButtonType ,_ subviewLayoutHandle:@escaping SpeedySubviewLayoutHandle){
        
        self.init(type: buttonType)
        
        self.disableMultipleClickTimeInterval = 0.25
        self.subviewLayoutHandle = subviewLayoutHandle
    }
    
    // 便利构造方法，在里面设置frame
    public convenience init(titleRect: CGRect?, imageRect: CGRect?, title: String?, titleColor: UIColor?, titleFont: UIFont?, imageName: String? = nil, backgroundColor: UIColor? = nil, cornerRadius: CGFloat? = nil) {
        
        self.init()
        
        self.disableMultipleClickTimeInterval = 0.25
        
        self.titleRect = titleRect
        self.imageRect = imageRect
        
        self.btnTitle = title
        self.titleColor = titleColor
        self.titleFont = titleFont
        
        if let name = imageName, name.count > 0, let img = UIImage(named: name) {
            setImage(img, for: .normal)
        }
        
        if let bgColor = backgroundColor {
            self.backgroundColor = bgColor
        }
        
        if let radius = cornerRadius {
            self.layerCornerRadius = radius
        }
    }
    
    public override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        if let rect = self.imageRect {
            return rect
        }
        return super.imageRect(forContentRect: contentRect)
    }
    
    public override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        if let rect = self.titleRect {
            return rect
        }
        return super.titleRect(forContentRect: contentRect)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if let handler = subviewLayoutHandle {
            weak var weakSelf = self
            handler(weakSelf)
        }
    }
}

