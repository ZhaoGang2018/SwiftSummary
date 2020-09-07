//
//  UIAlertController+Extension.swift
//  XCamera
//
//  Created by jing_mac on 2019/10/15.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

typealias AlertDidSelectHandler = (_ index: Int, _ controller:UIAlertController?) -> Void
typealias AlertInputHandler = (_ inputField: UITextField) -> Void

extension UIAlertController {
    
    /// alert弹框
    /// - Parameter title: 标题
    /// - Parameter message: 副标题
    /// - Parameter buttonTitles: 按钮名称的数组
    /// - Parameter viewController: present的控制器
    /// - Parameter onSelect: 点击回调
    class func showAlert(title:String?, message:String?, buttonTitles: [String], viewController: UIViewController?, styles: [UIAlertAction.Style] = [], onSelect:AlertDidSelectHandler?) {
        
        DispatchQueue.main.async {
            if buttonTitles.count == 0 {
                return
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            for index in 0..<buttonTitles.count {
                
                var currentStyle: UIAlertAction.Style = .default
                if index < styles.count {
                    currentStyle = styles[index]
                }
                
                let action = UIAlertAction(title: buttonTitles[index], style: currentStyle) { [weak alertController] (alertAction) in
                    DispatchQueue.main.async {
                        if let handler = onSelect {
                            handler(index, alertController)
                        }
                    }
                }
                alertController.addAction(action)
            }
            
            if let vc = viewController {
                vc.present(alertController, animated: true, completion: nil)
            } else {
                if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
                    rootVC.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    /// ActionSheet弹框
    /// - Parameter title: 标题
    /// - Parameter message: 副标题
    /// - Parameter buttonTitles: 按钮名称的数组
    /// - Parameter viewController: present的控制器
    /// - Parameter onSelect: 点击回调
    class func showActionSheet(title:String?, message:String?, buttonTitles:[String], viewController:UIViewController?, styles: [UIAlertAction.Style] = [], onSelect:AlertDidSelectHandler?) {
        
        DispatchQueue.main.async {
            if buttonTitles.count == 0 {
                return
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            for index in 0..<buttonTitles.count {
                var currentStyle: UIAlertAction.Style = .default
                if index == buttonTitles.count - 1 {
                    currentStyle = .cancel
                } else {
                    if index < styles.count {
                        currentStyle = styles[index]
                    }
                }
                
                let action = UIAlertAction(title: buttonTitles[index], style: currentStyle) { [weak alertController] (alertAction) in
                    DispatchQueue.main.async {
                        if let handler = onSelect {
                            handler(index, alertController)
                        }
                    }
                }
                alertController.addAction(action)
            }
            
            if let vc = viewController {
                //适配ipad
                if alertController.responds(to: #selector(getter: popoverPresentationController)){
                    alertController.popoverPresentationController?.sourceView = vc.view
                    alertController.popoverPresentationController?.sourceRect = CGRect(x:SpeedyApp.screenWidth/2, y: vc.view.height/2, width: 0, height: 0)
                }
                vc.present(alertController, animated: true, completion: nil)
            } else {
                if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
                    //适配ipad
                    if alertController.responds(to: #selector(getter: popoverPresentationController)){
                        alertController.popoverPresentationController?.sourceView = rootVC.view
                        alertController.popoverPresentationController?.sourceRect = CGRect(x:SpeedyApp.screenWidth/2, y: rootVC.view.height/2, width: 0, height: 0)
                    }
                    rootVC.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    /// 带输入框的alert弹框
    /// - Parameter title: 标题
    /// - Parameter message: 副标题
    /// - Parameter buttonTitles: 按钮名称的数组
    /// - Parameter viewController: present的控制器
    /// - Parameter onSelect: 点击回调
    class func showInputAlert(title:String?, message:String?, buttonTitles:[String], viewController:UIViewController?, onSelect:AlertDidSelectHandler?, inputHandler: AlertInputHandler?) {
        
        DispatchQueue.main.async {
            if buttonTitles.count == 0 {
                return
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            for index in 0..<buttonTitles.count {
                let action = UIAlertAction(title: buttonTitles[index], style: .default) { [weak alertController] (alertAction) in
                    DispatchQueue.main.async {
                        if let handler = onSelect {
                            handler(index, alertController)
                        }
                    }
                }
                alertController.addAction(action)
            }
            
            //添加textField输入框
            alertController.addTextField { (textField) in
                if let handler = inputHandler {
                    handler(textField)
                }
            }
            
            if let vc = viewController {
                vc.present(alertController, animated: true, completion: nil)
            } else {
                if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
                    rootVC.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

