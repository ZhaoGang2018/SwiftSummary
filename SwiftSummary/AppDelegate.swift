//
//  AppDelegate.swift
//  SwiftSummary
//
//  Created by jing_mac on 2020/7/13.
//  Copyright © 2020 zhaogang. All rights reserved.
//

import UIKit
import RealmSwift
import CryptoSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var allowOrentitaionRotation: Bool?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if #available(iOS 13.0, *) {
            
        } else {
            self.configWindow()
        }
        
        XHLogManager.shared.configDDLog()
        return true
    }
    
    // 设置屏幕方向
    /// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        if let temp = self.allowOrentitaionRotation, temp == true {
            return .allButUpsideDown
        }
        return .portrait
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
         return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func configWindow() {
//        let mainTabBarController = ZGMainTabBarController()
        
        let rootVC = ZGVideoPlayerViewController()
        let rootNav = XHBaseNavigationController(rootViewController: rootVC)
        
        self.window = UIWindow()
        self.window?.rootViewController = rootNav //mainTabBarController
        self.window?.makeKeyAndVisible()
        
        UIButton.appearance().isExclusiveTouch = true
    }
}
