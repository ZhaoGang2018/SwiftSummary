//
//  XHSegment.swift
//  XCamera
//
//  Created by 赵刚 on 2020/6/10.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit

typealias XHSegmentDidSelected = (_ index: Int) -> ()

class XHSegmentButton: UIButton {
    
    
}

class XHSegmentBar: UIView {
    
    var onSelect: XHSegmentDidSelected?
    
    var scrollView: UIScrollView?
    var buttons: [XHSegmentButton] = []
    
    // 选中的index
    var selectedIndex: Int = 0 {
        didSet {
            self.updateButtons()
        }
    }
    
    // 按钮间距
    var spacing: CGFloat = 8.0 {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    // 按钮的宽度
    var buttonWidth: CGFloat = 48.0 {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    // 按钮的高度
    var buttonHeight: CGFloat = 30.0{
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    var titles: [String] = [] {
        didSet {
            if titles.count == 0 {
                return
            }
            
            self.buttons.removeAll()
            
            for tempView in self.scrollView?.subviews ?? [] {
                if tempView.isKind(of: XHSegmentButton.self) {
                    tempView.removeFromSuperview()
                }
            }
            
            var i = 0
            for title in self.titles {
                let button = XHSegmentButton(title: title, titleColor: self.titleNormalColor, titleFont: self.titleNormalFont)
                button.addTarget(self, action: #selector(segmentSelectAction(sender:)), for: .touchUpInside)
                self.scrollView?.addSubview(button)
                self.buttons.append(button)
                i += 1
            }
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    // 标题未选中颜色
    var titleNormalColor: UIColor = UIColor.fromHex("#83838C") {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    // 标题选中颜色
    var titleSelectedColor: UIColor = UIColor.white {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    // 标题背景未选中颜色
    var titleBgNormalColor: UIColor = UIColor.fromHex("#EFEFF4") {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    // 标题背景选中颜色
    var titleBgSelectedColor: UIColor = UIColor.blue {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    var titleNormalFont: UIFont = UIFont.regular(16) {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    var titleSelectedFont: UIFont = UIFont.Semibold(16) {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        self.backgroundColor = UIColor.white
        
        self.scrollView = UIScrollView()
        self.scrollView?.showsVerticalScrollIndicator = false
        self.scrollView?.showsHorizontalScrollIndicator = false
        self.scrollView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.addSubview(self.scrollView!)
    }
    
    // 按钮的点击方法
    @objc private func segmentSelectAction(sender: XHSegmentButton) {
        
        guard let index = self.buttons.index(of: sender) else {
            return
        }
        
        if self.selectedIndex == index {
            return
        }
        
        self.selectedIndex = index
        if let handler = self.onSelect {
            handler(index)
        }
    }
    
    override func layoutSubviews() {
        updateButtons()
    }
    
    private func updateButtons() {
        
        if self.buttons.count == 0 {
            return
        }
        
        var lastButton: UIButton?
        var i = 0
        
        for button in self.buttons {
            button.layerCornerRadius = 2.0
            button.isSelected = i == self.selectedIndex
            button.backgroundColor = i == self.selectedIndex ? self.titleBgSelectedColor : self.titleBgNormalColor
            button.titleFont = i == self.selectedIndex ? self.titleSelectedFont : self.titleNormalFont
            
            button.setTitleColor(self.titleNormalColor, for: .normal)
            button.setTitleColor(self.titleSelectedColor, for: .selected)
            button.setTitleColor(self.titleSelectedColor, for: .highlighted)
            
            var current_w: CGFloat = (button.btnTitle?.size(WithFont: button.titleFont ?? self.titleNormalFont, ConstrainedToWidth: 1000).width ?? 0.0) + 16.0
            if current_w < self.buttonWidth {
                current_w = self.buttonWidth
            }
            
            button.frame = CGRect(x: (lastButton?.viewRightX ?? 0.0) + self.spacing, y: 4.0, width: current_w, height: self.buttonHeight)
            
            lastButton = button;
            i += 1;
        }
        
        self.scrollView?.frame = self.bounds
        self.scrollView?.contentSize = CGSize(width: (lastButton?.viewRightX ?? 0.0) + self.spacing, height: 0)
        
        self.adjustContentOffset(centerX: self.buttons[self.selectedIndex].viewCenterX)
    }
    
    // MARK: - 调整scrollView的offset
    private func adjustContentOffset(centerX: CGFloat) {
        
        if self.buttons.count == 0 {
            return
        }
        
        if let scrollView = self.scrollView {
            if (scrollView.viewFrameWidth >= scrollView.contentSize.width) {
                return;
            }
            
            if (centerX > scrollView.viewMidWidth) {
                if (centerX < scrollView.contentSize.width - scrollView.viewMidWidth) {
                    scrollView.setContentOffset(CGPoint(x: self.buttons[self.selectedIndex].viewCenterX - scrollView.viewMidWidth, y: 0), animated: false)
                } else {
                    scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width - scrollView.viewFrameWidth, y: 0), animated: false)
                }
            } else {
                scrollView.setContentOffset(CGPoint.zero, animated: true)
            }
        }
    }
}
