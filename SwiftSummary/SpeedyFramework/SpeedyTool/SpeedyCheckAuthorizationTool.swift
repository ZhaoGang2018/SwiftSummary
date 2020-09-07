//
//  SpeedyCheckAuthorizationTool.swift
//  XCamera
//
//  Created by jing_mac on 2020/7/22.
//  Copyright © 2020 xhey. All rights reserved.
//  请求权限

import UIKit

typealias SpeedyCheckAuthorizationCompletionHandler = (_ hasPermission: Bool) -> ()

class SpeedyCheckAuthorizationTool: NSObject {
    
    /*
     // 检查相册访问权限
     typedef NS_ENUM(NSInteger, PHAuthorizationStatus) {
     PHAuthorizationStatusNotDetermined = 0, // 默认还没做出选择
     PHAuthorizationStatusRestricted,        // 此应用程序没有被授权访问的照片数据
     PHAuthorizationStatusDenied,            // 用户已经明确否认了这一照片数据的应用程序访问
     PHAuthorizationStatusAuthorized         //  用户已经授权应用访问照片数据
     } NS_AVAILABLE_IOS(8_0);
     */
    class func checkPhotoAlbumPermission(completeHandler: SpeedyCheckAuthorizationCompletionHandler?) {
        
        let currentStatus = PHPhotoLibrary.authorizationStatus()
        if currentStatus == .restricted || currentStatus == .denied {
            // restricted: 此应用程序没有被授权访问的照片数据
            // denied:用户已经明确否认了这一照片数据的应用程序访问
            if let handler = completeHandler {
                handler(false)
            }
        } else if currentStatus == .authorized {
            // 用户已经授权应用访问照片数据
            if let handler = completeHandler {
                handler(true)
            }
        } else if currentStatus == .notDetermined {
            // 默认还没做出选择
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    if status == .authorized {
                        if let handler = completeHandler {
                            handler(true)
                        }
                    } else {
                        if let handler = completeHandler {
                            handler(false)
                        }
                    }
                }
            }
        }
    }
    
    /*
     检查相机访问权限
     AVAuthorizationStatusNotDetermined = 0, // 未进行授权选择
     AVAuthorizationStatusRestricted,　　　　  // 未授权，且用户无法更新，如家长控制情况下
     AVAuthorizationStatusDenied,　　　　　　   // 用户拒绝App使用
     AVAuthorizationStatusAuthorized,　　　　  // 已授权，可使用
     */
    class func checkCameraPermission(completeHandler: SpeedyCheckAuthorizationCompletionHandler?) {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == .restricted || authStatus == .denied {
            if let handler = completeHandler {
                handler(false)
            }
        } else if authStatus == .authorized {
            if let handler = completeHandler {
                handler(true)
            }
        } else if authStatus == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                DispatchQueue.main.async {
                    if let handler = completeHandler {
                        handler(granted)
                    }
                }
            }
        }
    }
    
    /*
     检查麦克风权限
     AVAuthorizationStatusNotDetermined = 0,  // 未进行授权选择
     AVAuthorizationStatusRestricted,　　　　  // 未授权，且用户无法更新，如家长控制情况下
     AVAuthorizationStatusDenied,　　　　　　   // 用户拒绝App使用
     AVAuthorizationStatusAuthorized,　　　　  // 已授权，可使用
     */
    class func checkMicrophonePermission(completeHandler: SpeedyCheckAuthorizationCompletionHandler?) {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        
        if authStatus == .restricted || authStatus == .denied {
            if let handler = completeHandler {
                handler(false)
            }
        } else if authStatus == .authorized {
            if let handler = completeHandler {
                handler(true)
            }
        } else if authStatus == .notDetermined {
            AVCaptureDevice.requestAccess(for: .audio) { (granted) in
                DispatchQueue.main.async {
                    if let handler = completeHandler {
                        handler(granted)
                    }
                }
            }
        }
    }
    
    class func requestVideo(captureAcessHandler: @escaping((_ isSuccess: Bool)->())){
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized{
            captureAcessHandler(true)
        }else if AVCaptureDevice.authorizationStatus(for: .video) == .denied || AVCaptureDevice.authorizationStatus(for: .video) == .restricted{
            captureAcessHandler(false)
        }else{
            AVCaptureDevice.requestAccess(for: .video) { (isVideoSuccess) in
                captureAcessHandler(isVideoSuccess)
            }
        }
    }
}
