//
//  XHNetworkStatusManager.swift
//  XCamera
//
//  Created by jing_mac on 2020/2/24.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit
import Alamofire

class XHNetworkStatusManager: NSObject {
    static let shared = XHNetworkStatusManager()
    private var reachabilityManager = NetworkReachabilityManager.default
    
    // 禁止外部调用init初始化方法
    private override init(){
        super.init()
    }
    
    // 网络是否可用
    var isNetworkAvailable: Bool {
        if let manager = reachabilityManager {
            let status = manager.status
            if status == .unknown || status == .notReachable {
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
    
    // 网络类型
    var networkType: String {
        var typeName = "未知"
        switch reachabilityManager?.status {
        case .unknown:
            break
        case .notReachable:
            typeName = "不可用的网络(未连接)"
        case .reachable:
            if (reachabilityManager?.isReachableOnCellular == true) {
                typeName = "蜂窝网络"
            } else if (reachabilityManager?.isReachableOnEthernetOrWiFi == true) {
                typeName = "WIFI"
            }
        case .none:
            break
        }
        return typeName
    }
    
    func startCheckingNetworkStatus() {
        
        if let manager = reachabilityManager {
            
            manager.startListening { status in
                var isAvailable = false
                
                switch status {
                case .unknown:
                    isAvailable = false
                    XHLogDebug("[当前的网络状态] - 未识别的网络")
                case .notReachable:
                    isAvailable = false
                    XHLogDebug("[当前的网络状态] - 不可用的网络(未连接)")
                case .reachable(.ethernetOrWiFi):
                    isAvailable = true
                    XHLogDebug("[当前的网络状态] - WiFi的网络")
                case .reachable(.cellular):
                    isAvailable = true
                    XHLogDebug("[当前的网络状态] - 2G,3G,4G...等蜂窝网络")
                }
                
//                NotificationCenter.default.post(name: XHNotification.NetworkStatusDidChanged, object: nil, userInfo: ["isNetworkAvailable": isAvailable])
//                XHLocationManager.shared.isNetworkAvailable = isAvailable
            }
        }
    }
}
