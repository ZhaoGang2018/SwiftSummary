//
//  XHFakeNavigationBar.swift
//  XCamera
//
//  Created by jing_mac on 2019/10/14.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

enum XHFakeNavigationLeftButtonStyle {
    case hide // 隐藏
    case back  // 显示返回
    case close // 显示叉号
    case text(title: String)  // 显示文字
}

enum XHFakeNavigationRightButtonStyle {
    case hide // 隐藏
    case image(name: String)  // 图片名称
    case text(title: String)  // 显示文字
    case blueBgText(title: String) // 蓝色背景+白色文字的按钮
}

// MARK: - 假的导航条
class XHFakeNavigationBar: UIView {
    
    var leftButton : UIButton?
    var titleLabel : UILabel?
    var rightButton : UIButton?
    
    var leftButtonHandler : (() -> ())?
    var rightButtonHandler : (() -> ())?
    
    var leftCustomView: UIView?
    var leftTitleLabel: UILabel?
    var rightCustomView: UIView?
    
    var leftButtonStyle: XHFakeNavigationLeftButtonStyle = .back {
        didSet {
            switch leftButtonStyle {
            case .hide:
                self.leftButton?.isHidden = true
            case .back:
                self.leftCustomView?.isHidden = true
                self.leftButton?.isHidden = false
                self.leftButton?.image = UIImage(named: "btn_back_on_black")
            case .close:
                self.leftCustomView?.isHidden = true
                self.leftButton?.isHidden = false
                self.leftButton?.image = UIImage(named: "btn_close_on_light")
                
            case .text(let leftTitle):
                self.leftCustomView?.isHidden = false
                self.leftButton?.isHidden = true
                self.leftTitleLabel?.text = leftTitle
            }
        }
    }
    
    var rightButtonStyle: XHFakeNavigationRightButtonStyle = .hide {
        didSet {
            switch rightButtonStyle {
            case .hide:
                // 隐藏
                rightButton?.isHidden = true
            case .image(let name):
                // 纯图片
                rightButton?.isHidden = false
                rightButton?.btnTitle = nil
                rightButton?.image = UIImage(named: name)
                
                rightButton?.snp.updateConstraints({ (make) in
                    make.width.equalTo(44)
                })
            case .text(let title):
                // 蓝色的文字
                rightButton?.isHidden = false
                rightButton?.btnTitle = title
                rightButton?.image = nil
                
                var title_w = title.size(WithFont: UIFont.Semibold(16), ConstrainedToWidth: 200).width + 3
                title_w = title_w < 44 ? 44 : title_w
                rightButton?.snp.updateConstraints({ (make) in
                    make.width.equalTo(title_w)
                })
            case .blueBgText(let title):
                // 蓝色背景+白色文字
                rightButton?.isHidden = false
                rightButton?.image = nil
                rightButton?.setProperties(title: title, titleColor: UIColor.white, titleFont: UIFont.Semibold(16), backgroundColor: UIColor.blueColor_xh(), cornerRadius: 4)
                rightButton?.snp.remakeConstraints({ (make) in
                    make.width.equalTo(54)
                    make.height.equalTo(28)
                    make.right.equalTo(-10)
                    make.bottom.equalTo(-8)
                })
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        leftButton = UIButton.init()
        leftButton?.image = UIImage.init(named: "btn_back_on_black")
        self.addSubview(leftButton!)
        leftButton?.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        
        leftButton?.snp.makeConstraints({ (make) in
            make.left.equalTo(4)
            make.bottom.equalTo(-2)
            make.width.height.equalTo(40)
        })
        
        titleLabel = UILabel(text: "", textColor: UIColor.black, textFont: UIFont.Semibold(17), textAlignment: .center)
        self.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(44)
            make.right.equalTo(-44)
            make.height.equalTo(22.0)
            make.bottom.equalTo(-11.0)
        })
        
        rightButton = UIButton(title: "", titleColor: UIColor.blueColor_xh(), titleFont: UIFont.Semibold(16))
        rightButton?.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        self.addSubview(rightButton!)
        rightButton?.isHidden = true

        rightButton?.snp.makeConstraints({ (make) in
            make.right.equalTo(-10)
            make.bottom.equalToSuperview()
            make.width.height.equalTo(44)
        })
        
        buildLeftCustomButton()
    }
    
    // 构建取消按钮
    private func buildLeftCustomButton() {
        
        self.leftCustomView = UIView()
        _ = leftCustomView?.addTapGestureRecognizer(target: self, action: #selector(leftButtonAction))
        self.addSubview(leftCustomView!)
        self.leftCustomView?.isHidden = true
        
        leftCustomView?.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(SpeedyApp.statusBarHeight)
            make.width.equalTo(80)
            make.height.equalTo(44)
        }
        
        self.leftTitleLabel = UILabel(text: "取消", textColor: UIColor.fromHex("#47484E"), textFont: UIFont.regular(16))
        leftCustomView?.addSubview(leftTitleLabel!)
        
        leftTitleLabel?.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    func setLeftCustomView(view: UIView) {
        self.leftCustomView = view
        self.addSubview(self.leftCustomView!)
        self.leftButton?.isHidden = true
    }
    
    func setRightCustomView(view: UIView) {
        self.rightCustomView = view
        self.addSubview(self.rightCustomView!)
        self.rightButton?.isHidden = true
    }
    
    @objc private func leftButtonAction() {
        if let handler = self.leftButtonHandler {
            handler()
        }
    }
    
    @objc private func rightButtonAction() {
        if let handler = self.rightButtonHandler {
            handler()
        }
    }
}
