//
//  SpeedyApp.swift
//  XCamera
//
//  Created by jing_mac on 2020/2/24.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit

class SpeedyApp {
    
    // 打印设备详细信息
    static func showAppInfo() {
        let str = "-------------------App信息-------------------"
        let infoStr = "\n \(str) \n \(self.appInfo) \n \(str) \n"
        XHLogDebug(infoStr)
    }
    
    // MARK: - 设备信息
    static var appInfo: String {
        let infoStr = "\n 版本号: \(version) \n Build号: \(buildVersion) \n APP名称: \(displayName) \n 唯一标识: \(identifier) \n 制造商: \(manufacturer) \n 操作系统: \(systemName) \n 操作系统版本: \(osVersion) \n 设备型号: \(deviceModel) \n 屏幕宽度: \(screenWidth) \n 屏幕高度: \(screenHeight) \n 状态栏的高度: \(statusBarHeight) \n 导航栏的高度: \(navigationBarHeight) \n 设备是不是iPhoneX: \(isIPhoneX) \n 安全区域距底部高度: \(tabBarBottomHeight) \n"
        return infoStr
    }
    
    // 屏幕宽度
    static let screenWidth = UIScreen.main.bounds.width
    
    // 屏幕高度
    static let screenHeight = UIScreen.main.bounds.size.height
    
    // 判断设备是不是iPhoneX
    static var isIPhoneX : Bool {
        var iPhoneX = false
        if #available(iOS 11.0, *) {
            if let keyWindow = UIApplication.shared.keyWindow, keyWindow.safeAreaInsets.bottom > 0 {
                iPhoneX = true
            }
        }
        return iPhoneX
    }
    
    // TableBar距底部区域高度
    static var tabBarBottomHeight : CGFloat {
        var bottomHeight : CGFloat = 0.0
        if isIPhoneX {
            bottomHeight = 34.0
        }
        return bottomHeight
    }
    
    // 状态栏的高度
    static var statusBarHeight : CGFloat {
        var height = UIApplication.shared.statusBarFrame.size.height
        height = height < 20 ? (tabBarBottomHeight > 0 ? 44 : 20) : height
        return height
    }
    
    // 导航栏的高度
    static var navigationBarHeight: CGFloat {
        return 44.0
    }
    
    // 状态栏和导航栏的高度
    static var statusBarAndNavigationBarHeight : CGFloat {
        let heigth = statusBarHeight + navigationBarHeight
        return heigth
    }
    
    // 版本号
    static var version: String {
        //2.x.x
        if let str = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return str
        }
        return ""
    }
    
    // build号
    static var buildVersion: String {
        // 2019101910
        if let str = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return str
        }
        return ""
    }
    
    // 名称
    static var displayName: String {
        // 今日水印相机
        if let str = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            return str
        }
        return ""
    }
    
    // 唯一标识
    static var identifier: String {
        // 今日水印相机
        if let str = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String {
            return str
        }
        return ""
    }
    
    // 制造商
    static var manufacturer: String {
        return "Apple"
    }
    
    // 操作系统
    static var systemName: String {
        return UIDevice.current.systemName
    }
    
    // 操作系统版本
    static var osVersion: String {
        return UIDevice.current.systemVersion
    }
    
    // 设备型号
    static var deviceModel: String {
        return SpeedyDevice.deviceModel()
    }
    
    // MARK: - 查找顶层控制器、
    // 获取顶层控制器 根据window
    class func getTopViewController() -> UIViewController? {
        
        var window = UIApplication.shared.keyWindow
        //是否为当前显示的window
        if window?.windowLevel != UIWindow.Level.normal{
            let windows = UIApplication.shared.windows
            for  windowTemp in windows{
                if windowTemp.windowLevel == UIWindow.Level.normal{
                    window = windowTemp
                    break
                }
            }
        }
        let vc = window?.rootViewController
        return getTopViewController(vc)
    }
    
    ///根据控制器获取 顶层控制器
    class func getTopViewController(_ viewController: UIViewController?) -> UIViewController? {
        
        guard let currentVC = viewController else {
            return nil
        }
        
        if let nav = currentVC as? UINavigationController {
            // 控制器是nav
            return getTopViewController(nav.visibleViewController)
        } else if let tabC = currentVC as? UITabBarController {
            // tabBar 的跟控制器
            return getTopViewController(tabC.selectedViewController)
        } else if let presentVC = currentVC.presentedViewController {
            //modal出来的 控制器
            return getTopViewController(presentVC)
        } else {
            // 返回顶控制器
            return currentVC
        }
    }
    
    // MARK: - 顶层控制器
    class var topViewController: UIViewController? {
        return self.getTopViewController()
    }
    
    // MARK: - 顶层控制器的navigationController
    class var topNavigation: UINavigationController? {
        if let topVC = self.getTopViewController() {
            if let nav = topVC.navigationController {
                return nav
            } else {
                return XHBaseNavigationController(rootViewController: topVC)
            }
        }
        return nil
    }
    
    // 跳转到指定的VC
    class func jumpToViewController(_ vcClass: UIViewController.Type) {
        if let topVC = self.getTopViewController() {
            _ = topVC.returnToViewController(vcClass)
        } else {
            XHLogDebug("找不到任何VC，无法完成跳转")
        }
    }
    
    // MARK: - 获取唯一字符串
    class func getUniqueString() -> String {
        
        let str = NSUUID().uuidString.md5()
        return str
    }
    
    // 获取UUID
    class func getUUID() -> String {
        let str = NSUUID().uuidString
        return str
    }
}

/* iPhone XR
 -------------------App信息-------------------
 版本号: 2.8.7
 Build号: 2020022414
 APP名称: 今日水印相机
 唯一标识: com.xhey.XCamera
 制造商: Apple
 操作系统: iOS
 操作系统版本: 13.3.1
 设备型号: iPhone XR
 屏幕宽度: 414.0
 屏幕高度: 896.0
 状态栏的高度: 44.0
 导航栏的高度: 44.0
 设备是不是iPhoneX: true
 安全区域距底部高度: 34.0
 -------------------App信息-------------------
 */

/* iPhone 6S
 -------------------App信息-------------------
 版本号: 2.8.7
 Build号: 2020022414
 APP名称: 今日水印相机
 唯一标识: com.xhey.XCamera
 制造商: Apple
 操作系统: iOS
 操作系统版本: 11.4.1
 设备型号: iPhone 6
 屏幕宽度: 375.0
 屏幕高度: 667.0
 状态栏的高度: 20.0
 导航栏的高度: 44.0
 设备是不是iPhoneX: false
 安全区域距底部高度: 0.0
 -------------------App信息-------------------
 */
