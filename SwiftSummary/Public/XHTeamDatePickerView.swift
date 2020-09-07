//
//  XHTeamDatePickerView.swift
//  XCamera
//
//  Created by jing_mac on 2019/11/13.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

class XHTeamDatePickerView: UIView {
    
    private var backButton: UIButton?
    private var titleLabel: UILabel?
    private var dateView: UIView?
    var dateLabel: UILabel?
    var inviteButton: UIView?
    var settingButton: UIButton?
    var searchPhotoBtn: UIView?
    var customerServiceBtn: UIButton? // 客服按钮
    
    var backHandler: SpeedyCommonHandler?
    var inviteHandler: SpeedyCommonHandler?
    var settingHandler: SpeedyCommonHandler?
    var selectDateHandler: SpeedyCommonHandler?
    var searchPhotoHandler: SpeedyCommonHandler?
    var customerServiceHandler: SpeedyCommonHandler?
    
    var dateString: String?{
        didSet {
            self.dateLabel?.text = dateString
            var text_w: CGFloat = 0
            if let label = self.dateLabel, let view = self.dateView ,let text = dateString {
                text_w = text.size(WithFont: label.font, ConstrainedToWidth: 200).width + 5.0
                view.snp.updateConstraints { (make) in
                    make.width.equalTo(8 + text_w + 7 + 28)
                }
            }
        }
    }
    
    var titleText: String? {
        didSet {
            self.titleLabel?.text = titleText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 按钮的点击方法
    @objc private func backButtonClicked() {
        backHandler?()
    }
    
    @objc private func inviteButtonClicked() {
        inviteHandler?()
    }
    
    @objc private func settingButtonClicked() {
        settingHandler?()
    }
    
    @objc private func selectDateAction() {
        selectDateHandler?()
    }
    
    @objc func searchPhotoButtonAction() {
        searchPhotoHandler?()
    }
    
    // 联系客服
    @objc private func customerServiceButtonAction() {
        customerServiceHandler?()
    }
}

// 搭建UI
extension XHTeamDatePickerView {
    
    private func buildUI() {
        self.backgroundColor = UIColor.white
        
        backButton = UIButton(imageName: "btn_back_on_black")
        backButton?.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        self.addSubview(backButton!)
        backButton?.snp.makeConstraints({ (make) in
            make.width.height.equalTo(40.0)
            make.top.equalTo(SpeedyApp.statusBarHeight + 2.0)
            make.left.equalTo(4.0)
        })
        
        titleLabel = UILabel(text: "", textColor: UIColor.black, textFont: UIFont.Semibold(17))
        self.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(SpeedyApp.statusBarHeight + 8.0)
            make.left.equalTo(backButton!.snp.right).offset(2.0)
            make.right.lessThanOrEqualTo(-96.0)
            make.height.equalTo(23.0)
        })
        
        dateView = UIView(backgroundColor: UIColor.blueColor_xh(), cornerRadius: 6.0)
        _ = dateView?.addTapGestureRecognizer(target: self, action: #selector(selectDateAction))
        self.addSubview(dateView!)
        dateView?.snp.makeConstraints { (make) in
            make.left.equalTo(backButton!.snp.right)
            make.width.equalTo(144)
            make.height.equalTo(28)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        dateLabel = UILabel(text: "", textColor: UIColor.white, textFont: UIFont.regular(16))
        dateView?.addSubview(dateLabel!)
        dateLabel?.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(8)
            make.right.lessThanOrEqualTo(-35.0)
        })
        
        let arrowIcon = UIImageView(image: UIImage(named: "data_selector_large"))
        dateView?.addSubview(arrowIcon)
        arrowIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(28)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        searchPhotoBtn = UIView(backgroundColor: UIColor.blueColor_xh(), cornerRadius: 6.0)
        _ = searchPhotoBtn?.addTapGestureRecognizer(target: self, action: #selector(searchPhotoButtonAction))
        self.addSubview(searchPhotoBtn!)
        searchPhotoBtn?.snp.makeConstraints({ (make) in
            make.left.equalTo(dateView!.snp.right).offset(8.0)
            make.width.equalTo(72)
            make.height.equalTo(28)
            make.bottom.equalToSuperview().offset(-8)
        })
        searchPhotoBtn?.isHidden = true
        
        let searchIcon = UIImageView(imageName: "team_photoflow_navbar_search_image")
        searchPhotoBtn?.addSubview(searchIcon)
        searchIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(18)
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
        }
        
        let searchTitleLabel = UILabel(text: "照片", textColor: UIColor.white, textFont: UIFont.regular(16))
        searchPhotoBtn?.addSubview(searchTitleLabel)
        searchTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(searchIcon.snp.right).offset(2)
            make.top.height.right.equalToSuperview()
        }
        
        inviteButton = UIView.init()
        _ = inviteButton?.addTapGestureRecognizer(target: self, action: #selector(inviteButtonClicked))
        self.addSubview(inviteButton!)
        inviteButton?.snp.makeConstraints({ (make) in
            make.width.equalTo(96.0)
            make.height.equalTo(22.0)
            make.top.equalTo(SpeedyApp.statusBarHeight + 9.0)
            make.right.equalToSuperview()
        })
        
        let inviteIcon = UIImageView.init(image: UIImage(named: "workgroup_appbar_invite_icon"))
        inviteButton?.addSubview(inviteIcon)
        inviteIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(14)
            make.left.equalTo(0)
            make.centerY.equalToSuperview()
        }
        
        let inviteLable = UILabel(text: "邀请成员", textColor: UIColor.blueColor_xh(), textFont: UIFont.Semibold(16))
        inviteButton?.addSubview(inviteLable)
        inviteLable.snp.makeConstraints { (make) in
            make.left.equalTo(inviteIcon.snp.right).offset(4)
            make.top.bottom.right.equalToSuperview()
        }
        
        settingButton = UIButton(title: "规则设置", titleColor: UIColor.blueColor_xh(), titleFont: UIFont.Semibold(16))
        settingButton?.addTarget(self, action: #selector(settingButtonClicked), for: .touchUpInside)
        self.addSubview(settingButton!)
        settingButton?.snp.makeConstraints({ (make) in
            make.top.equalTo(SpeedyApp.statusBarHeight)
            make.right.equalTo(-14)
            make.width.equalTo(64.0)
            make.height.equalTo(40.0)
        })
        
        customerServiceBtn = UIButton(imageName: "workgroup_statistics_service")
        customerServiceBtn?.addTarget(self, action: #selector(customerServiceButtonAction), for: .touchUpInside)
        self.addSubview(customerServiceBtn!)
        customerServiceBtn?.snp.makeConstraints({ (make) in
            make.width.height.equalTo(40)
            make.top.equalTo(SpeedyApp.statusBarHeight + 2.0)
            make.right.equalTo(-92.0)
        })
        
        settingButton?.isHidden = true
        inviteButton?.isHidden = true
        customerServiceBtn?.isHidden = true
    }
}
