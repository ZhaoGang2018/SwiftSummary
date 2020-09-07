//
//  SpeedyMemoryCache.swift
//  XCamera
//
//  Created by jing_mac on 2019/11/9.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

class SpeedyMemoryCache: NSObject {
    
    // 内存低的时候是否清空任务，默认是true
    var clearWhenMemoryLow: Bool = true
    
    // 最大的缓存数量
    var maxCacheCount: Int = 99999
    
    // 当前的缓存数量
    var cachedCount: Int = 0
    
    // 所有的keys
    var cacheKeys: [String] = []
    
    // 所有的objects
    var cacheObjects: [String:AnyObject] = [:]
    
    var allKeys:[String] {
        get {
            return cacheKeys
        }
    }
    
    var memoryWarningHandler: ((SpeedyMemoryCache) -> ())?

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(receiveMemoryWarning(_:)), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    func hasObjectForKey(_ key: String) -> Bool {
        
        if self.cacheObjects[key] != nil {
            return true
        }
        return false
    }
    
    func objectForKey(_ key: String) -> AnyObject? {
        let object = self.cacheObjects[key]
        return object
    }
    
    func removeAllObjects() {
        self.cacheKeys.removeAll()
        self.cacheObjects.removeAll()
        self.cachedCount = 0
    }
    
    func removeObjectForKey(_ key: String) {
        if self.cacheObjects[key] != nil {
            for i in 0..<self.cacheKeys.count {
                let currentKey = self.cacheKeys[i]
                if currentKey == key {
                    self.cacheKeys.remove(at: i)
                    break
                }
            }
            self.cacheObjects.removeValue(forKey: key)
            self.cachedCount -= 1
        }
    }
    
    func setObject(_ object: AnyObject?, key: String?) {
        
        if let currentObject = object, let currentKey = key {
            self.cachedCount += 1
            while self.cachedCount >= self.maxCacheCount {
                if let tempKey = self.cacheKeys.first{
                    self.cacheObjects.removeValue(forKey: tempKey)
                    self.cacheKeys.removeFirst()
                    self.cachedCount -= 1
                }
            }
            
            self.cacheKeys.append(currentKey)
            self.cacheObjects[currentKey] = currentObject
        }
    }
    
    // MARK: - 接到内存警告的通知
    @objc private func receiveMemoryWarning(_ notifi:NSNotification) {
        if self.clearWhenMemoryLow {
            self.removeAllObjects()
        }
    }
    

}

