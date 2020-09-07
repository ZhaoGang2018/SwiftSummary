//
//  SpeedyAlertViewController.swift
//  XCamera
//
//  Created by jing_mac on 2019/9/12.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

class SpeedyAlertAction: UIAlertAction {
    
    /**< 按钮title字体颜色 */
    var textColor: UIColor? {
        set {
            var count: UInt32 = 0
            let ivars = class_copyIvarList(UIAlertAction.self, &count)
            for index in 0..<count {
                guard let ivar = ivars?[Int(index)] else { continue }
                guard let namePointer = ivar_getName(ivar) else { continue }
                guard let name = String.init(utf8String: namePointer) else { continue }
                
                if name == "_titleTextColor" {
                    self.setValue(newValue, forKey: "titleTextColor")
                }
            }
        }
        
        get {
            return UIColor.black
        }
    }
}


class SpeedyAlertViewController: UIAlertController {
    
    /**< 统一按钮样式 不写系统默认的蓝色 */
    var tintColor: UIColor?
    
    /**< 标题的颜色 */
    var alertTitleColor: UIColor?
    
    /**< 信息的颜色 */
    var messageColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var count: UInt32 = 0
        let ivars = class_copyIvarList(UIAlertController.self, &count)
        for index in 0..<count {
            guard let ivar = ivars?[Int(index)] else { continue }
            guard let namePointer = ivar_getName(ivar) else { continue }
            guard let name = String.init(utf8String: namePointer) else { continue }
            
            //标题颜色
            if name == "_attributedTitle" {
                let attr = NSMutableAttributedString.init(string: self.title ?? "", attributes: [NSAttributedString.Key.foregroundColor : self.alertTitleColor ?? UIColor.black, NSAttributedString.Key.font:UIFont.init(name: "PingFangSC-Semibold", size: 17)!])
                self.setValue(attr, forKey: "attributedTitle")
            }
            
            // 描述颜色
            if name == "_attributedMessage" {
                let attr = NSMutableAttributedString.init(string: self.message ?? "", attributes: [NSAttributedString.Key.foregroundColor : self.messageColor ?? UIColor.black, NSAttributedString.Key.font:UIFont.init(name: "PingFangSC-Semibold", size: 17)!])
                self.setValue(attr, forKey: "attributedMessage")
            }
            
        }
        
        //按钮统一颜色
        if let color = self.tintColor {
            for action in self.actions {
                if let _action = action as? SpeedyAlertAction {
                    _action.textColor = color
                }
            }
        }
    }
}



/*
 
 ///////////////////
 let alert = SpeedyAlertViewController.init(title: "hhhhhhhhhhhh", message: "5566666655e757", preferredStyle: .alert)
 alert.titleColor = UIColor.red
 alert.alertTitleColor = UIColor.green
 
 let cancelAction = SpeedyAlertAction.init(title: "quxiao", style: .cancel, handler: nil)
 cancelAction.textColor = UIColor.blue
 alert.addAction(cancelAction)
 
 let okAction = SpeedyAlertAction.init(title: "确定", style: .default, handler: nil)
 okAction.textColor = UIColor.red
 alert.addAction(okAction)
 
 self.present(alert, animated: true, completion: nil)
 return
 
 
 /////////////////
 */
