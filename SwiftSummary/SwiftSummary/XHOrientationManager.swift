//
//  XHOrientationMamager.swift
//  XCamera
//
//  Created by wangxs on 2017/11/14.
//  Copyright © 2017年 xhey. All rights reserved.
//

import UIKit
import CoreMotion

protocol XHOrientationMamagerDelegate: class {
    func XHOrientationMamagerOrientationChange(currentOrientation: XHOrientation, oldOrientation: XHOrientation)
}

public enum XHOrientation:Int {
    case portraitDirection = 1
    case downDirection = 2
    case leftDirection = 3
    case rightDirection = 4
    case unknownDirection = 5
}

class XHOrientationManager: NSObject {
    let sensitive = 0.6
    
    static let shared = XHOrientationManager()
    
    private override init(){}
    
    private var monitor = CMMotionManager()
    weak var delegate: XHOrientationMamagerDelegate?
    private var oldOrientation = XHOrientation.unknownDirection
    private(set) var lastOrientation = XHOrientation.unknownDirection
    
    // MARK: - 屏幕方向 1:横屏  2:竖屏
    var screenType: Int {
        var orientation = self.getOrientation()
        if orientation == .unknownDirection {
            orientation = self.lastOrientation
        }
        
        if orientation == .unknownDirection{
            orientation = .portraitDirection
        }
        
        // 1:横屏  2:竖屏
        var type = 0
        if orientation == .portraitDirection || orientation == .downDirection {
            type = 2
        }else{
            type = 1
        }
        return type
    }
    
    func getOrientation()->XHOrientation{
        
        if let myMotion = monitor.deviceMotion{
            return deviceMotion(myMotion)
        }
        return .portraitDirection
    }
    
    // 开始监测
    func startMonitor() {
        self.monitor.deviceMotionUpdateInterval = 1/10.0
        if self.monitor.isDeviceMotionAvailable {
            self.monitor.startDeviceMotionUpdates(to: .main, withHandler: { [weak self](motion, error) in
                
                self?.updateDeviceOrientation(motion, error)
            })
        }
    }
    
    // 停止陀螺仪
    func stopMonitor(){
        monitor.stopDeviceMotionUpdates()
        XHLogInfo("[屏幕方向调试] - 停止陀螺仪")
    }
    
    // 更新屏幕方向
    private func updateDeviceOrientation(_ motion: CMDeviceMotion?, _ error: Error?) {
        
        if error == nil, let myMotion = motion {
            let currentOrientation = self.deviceMotion(myMotion)
            let oldOrientation = self.oldOrientation
            
            if currentOrientation != oldOrientation {
                XHLogInfo("[屏幕方向调试] - 更新水印方向")
                self.delegate?.XHOrientationMamagerOrientationChange(currentOrientation: currentOrientation, oldOrientation: oldOrientation)
                self.oldOrientation = currentOrientation
                if currentOrientation != .unknownDirection {
                    self.lastOrientation = currentOrientation
                }
            }
        }
    }
    
    private func deviceMotion(_ motion: CMDeviceMotion) -> XHOrientation {
        
        let x = motion.gravity.x
        let y = motion.gravity.y
        XHLogInfo("[屏幕方向调试] - 陀螺仪方向发生变化x:[\(x)] - y:[\(y)]")
        
        if(y < 0){
            if(fabs(y) > sensitive){
                return .portraitDirection
            }
        }else{
            if(y > sensitive){
                return .downDirection
            }
        }
        if(x < 0){
            if(fabs(x) > sensitive){
                return.leftDirection
            }
        }else{
            if(x > sensitive){
                return .rightDirection
            }
        }
        return .unknownDirection
    }
}







/*
 //////////////////////////////////////////////////////////////////
 // 这是参考代码
 class XZDeviceOrientation: NSObject {
     
     private let sensitive = 0.77
     
     private let motionManager = CMMotionManager()
     
     private var direction: UIInterfaceOrientation = .portrait
  
     
     // 每隔一个间隔做轮询
     func start() {
         
         print("------走了start")
         
         motionManager.deviceMotionUpdateInterval = 0.5
         
         if motionManager.isDeviceMotionAvailable {
             
             motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) {[weak self] (motion, error) in
  
                 self?.performSelector(onMainThread: #selector(self?.deviceMotion(motion:)), with: motion, waitUntilDone: true)
  
             }
             
             
         }
     }
     
     @objc func deviceMotion(motion: CMDeviceMotion) {
         
         let x = motion.gravity.x
         let y = motion.gravity.y
  
         
         if y < 0 {
             if fabs(y) > sensitive {
                 
                 if direction != .portrait {
                     direction = .portrait
                     
                     NotificationCenter.default.post(name: UIDevice.orientationDidChangeNotification, object: nil, userInfo: ["direction": direction])
                 }
             }
         }else {
             
             if y > sensitive {
                 if direction != .portraitUpsideDown {
                     direction = .portraitUpsideDown
                     
                     NotificationCenter.default.post(name: UIDevice.orientationDidChangeNotification, object: nil, userInfo: ["direction": direction])
                     
                 }
             }
         }
         
         
         if x < 0 {
             if fabs(x) > sensitive {
                 if direction != .landscapeLeft {
                     direction = .landscapeLeft
                     
                     NotificationCenter.default.post(name: UIDevice.orientationDidChangeNotification, object: nil, userInfo: ["direction": direction])
                 }
             }
         }else {
             if x > sensitive {
                 if direction != .landscapeRight {
                     direction = .landscapeRight
                     
                     NotificationCenter.default.post(name: UIDevice.orientationDidChangeNotification, object: nil, userInfo: ["direction": direction])
                 }
             }
         }
         
  
 //        print("---------direction:", direction.rawValue)
  
     }
     
     func stop() {
         motionManager.stopDeviceMotionUpdates()
     }
 }

 */
