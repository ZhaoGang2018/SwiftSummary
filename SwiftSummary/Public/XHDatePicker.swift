//
//  XHDatePicker.swift
//  XCamera
//
//  Created by jing_mac on 2019/10/31.
//  Copyright © 2019 xhey. All rights reserved.
//  日期选择器

import UIKit

enum DateStyle {
    case dateAndTime
    case date
    case time
    case countDownTimer
}

typealias XHDatePickerCompletionHandler = (_ date: Date) -> ()
typealias XHDatePickerCancelHandler = () -> ()

class XHDatePicker: UIViewController {
    
    class func showDateSelector(defaultDate:Date?, style: DateStyle, maxDate: Date?, viewController:UIViewController?, cancel: XHDatePickerCancelHandler?, complete:@escaping XHDatePickerCompletionHandler) -> XHDatePicker {
        
        let selector = XHDatePicker.init()
        selector.dateStyle = style
        selector.completionHandler = complete
        selector.cancelHandler = cancel
        selector.maxDate = maxDate
        if let tempDate = defaultDate {
            selector.defaultDate = tempDate
        }
        
        if let vc = viewController {
            vc.present(selector, animated: true, completion: nil)
        } else {
            if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
                rootVC.present(selector, animated: true, completion: nil)
            }
        }
        
        return selector
    }
    
    var bigButton: UIButton?
    var contentView: UIView?
    var datePicker: UIDatePicker?
    var dateStyle: DateStyle = .date
    var maxDate:Date?
    var selectDate = Date()
    
    // 默认选中的date
    var defaultDate = Date() {
        didSet {
            self.datePicker?.setDate(defaultDate, animated: true)
        }
    }
    
    var completionHandler: XHDatePickerCompletionHandler?
    var cancelHandler: XHDatePickerCancelHandler?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bigButton = UIButton.init()
        bigButton?.backgroundColor = UIColor.black
        bigButton?.alpha = 0.6
        bigButton?.addTarget(self, action: #selector(bigButtonAction), for: .touchUpInside)
        self.view.addSubview(bigButton!)
        bigButton?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        contentView = UIView.init()
        contentView?.backgroundColor = UIColor.white
        self.view.addSubview(contentView!)
        contentView?.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(SpeedyApp.tabBarBottomHeight + 250 + 44.0)
        })
        
        let cancelBtn = UIButton(title: "取消", titleColor: UIColor.blueColor_xh(), titleFont:UIFont.Semibold(16.0))
        cancelBtn.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        contentView?.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(4)
            make.width.height.equalTo(44)
        }
        
        let doneBtn = UIButton(title: "完成", titleColor: UIColor.blueColor_xh(), titleFont:UIFont.Semibold(16.0))
        doneBtn.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        contentView?.addSubview(doneBtn)
        doneBtn.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.right.equalTo(-4)
            make.width.height.equalTo(44)
        }
        
        datePicker = UIDatePicker.init()
        datePicker?.backgroundColor = UIColor.white
        // 设置轮廓
//        datePicker?.layer.borderWidth = 1
//        datePicker?.layer.borderColor = UIColor.gray.cgColor
        // 显示的日期的形式
        if XHTimeManager.shared.isGpsInChina {
            datePicker?.timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        }
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(chooseDate(datePicker:)), for: .valueChanged)
        datePicker?.setDate(defaultDate, animated: true)
        contentView?.addSubview(datePicker!)
        datePicker?.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(44)
            make.height.equalTo(250)
        })
        
        switch dateStyle {
        case .dateAndTime:
            datePicker?.datePickerMode = .dateAndTime
        case .date:
            datePicker?.datePickerMode = .date
        case .time:
            datePicker?.datePickerMode = .time
        case .countDownTimer:
            datePicker?.datePickerMode = .countDownTimer
        }
        
        if let tempMax = self.maxDate {
            // 设置显示最大时间（此处为当前时间）
            datePicker?.maximumDate = tempMax
        }
    }
    
    // 获取选择的时间
    @objc func chooseDate(datePicker:UIDatePicker) {
        self.selectDate = datePicker.date
    }
    
    @objc private func bigButtonAction() {
        cancelButtonAction()
    }
    
    @objc private func cancelButtonAction() {
        if let handler = self.cancelHandler {
            handler()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneButtonAction() {
        if let handler = self.completionHandler {
            handler(self.selectDate)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
