//
//  ZGCustomTabBar.swift
//  SwiftSummary
//
//  Created by jing_mac on 2020/1/8.
//  Copyright © 2020 jing_mac. All rights reserved.
//

import UIKit

class ZGCustomTabBar: UIView {
    
    var selectedIndex: Int = 0 {
        didSet {
            for button in self.tabBarButtons {
                button.isSelected = button.tag == self.selectedIndex
            }
        }
    }
    
    var onSelect: ((Int) -> ())?

    var tabBarButtons:[ZGCustomTabBarButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        let button_w: CGFloat = 48.0
        let button_h: CGFloat = 49.0
        let margin: CGFloat = 20.0
        let space_x: CGFloat = (SpeedyApp.screenWidth - margin*2.0 - button_w*4.0)/3.0;
        
        let titles = ["榜单", "音视频", "消息", "我"]
        let normalImageNames = ["tabbar_normal_0", "tabbar_normal_1", "tabbar_normal_2", "tabbar_normal_3"]
        let selectImageNames = ["tabbar_selected_0", "tabbar_selected_1", "tabbar_selected_2", "tabbar_selected_3"]
        
        for i in 0..<4 {
            let button = ZGCustomTabBarButton(frame: CGRect(x: margin + (button_w + space_x)*CGFloat(i), y: 0, width: button_w, height: button_h))
            button.tag = i
            button.btnTitle = titles[i]
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitleColor(UIColor.red, for: .selected)
            button.setTitleColor(UIColor.red, for: .highlighted)
            
            button.setImage(UIImage(named: normalImageNames[i]), for: .normal)
            button.setImage(UIImage(named: selectImageNames[i]), for: .selected)
            button.setImage(UIImage(named: selectImageNames[i]), for: .highlighted)
            
            button.addTarget(self, action: #selector(tabBarButtonClicked(sender:)), for: .touchUpInside)
            
            self.addSubview(button)
            
            self.tabBarButtons.append(button)
        }
        
    }
    
    @objc private func tabBarButtonClicked(sender: ZGCustomTabBarButton) {
        if let handler = self.onSelect {
            handler(sender.tag)
        }
    }
}

class ZGCustomTabBarButton: UIButton {
    
    var titleRect: CGRect?
    var imageRect: CGRect?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        titleRect = CGRect(x: 0, y: self.viewFrameHeight - 15, width: self.viewFrameWidth, height: 15.0)
        imageRect = CGRect(x: (self.viewFrameWidth - 48.0)/2.0, y: 0.0, width: 48.0, height: 34.0)
        
        self.backgroundColor = UIColor.white
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
    }
    
    //指定按钮图像边界
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return self.imageRect ?? CGRect.zero
    }
    
    // 指定文字标题边界
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return self.titleRect ?? CGRect.zero
    }
    
}
