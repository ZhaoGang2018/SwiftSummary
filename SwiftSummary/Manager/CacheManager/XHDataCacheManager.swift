//
//  XHDataCacheManager.swift
//  XCamera
//
//  Created by jing_mac on 2019/9/18.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

enum XHDataCacheType: String {
    case WorkgroupCache = "workgroup" // 工作圈缓存
    case MessageListCache = "messageListCache"
    case CommmetListCache = "commmetListCache"
    case ActivityCache = "activityCache"
    case HDgrouplist = "hdgrouplist"
    case AttendanceReport = "AttendanceReport" // 考勤报表(这个文件夹和其他的不同，存放的文件不需要经过md5加密)
}

class XHDataCacheManager: NSObject {
    
    static let shared = XHDataCacheManager()
    let cachePath = SpeedySandbox.shared.cachesDirectory + "/" + "XCameraCache"
    let lock = NSLock()
    
    let cacheTypes: [XHDataCacheType] = [.WorkgroupCache, .MessageListCache, .CommmetListCache, .ActivityCache, .HDgrouplist, .AttendanceReport]
    
    // 禁止外部调用init初始化方法
    private override init() {
        super.init()
        
        SpeedyFileManager.checkDirectory(at: cachePath)
        for type in self.cacheTypes {
            let folderPath = self.cachePath + "/" + type.rawValue
            SpeedyFileManager.checkDirectory(at: folderPath)
        }
    }
    
    /**
     写入/更新缓存(异步) [按APP版本号缓存,不同版本APP,同一接口缓存数据互不干扰]
     - parameter jsonResponse: 要写入的数据(JSON)
     - parameter URL:          数据请求URL
     - parameter subPath:      二级文件夹路径subPath（可设置-可不设置）
     - parameter completed:    异步完成回调(主线程回调)
     */
    func asyncSaveCache(_ jsonObject: AnyObject, cacheKey: String, cacheType: XHDataCacheType?, completeHandler: @escaping (_ isSuccess: Bool) -> ()) {
        DispatchQueue.global().async{
            let result = self.saveCache(jsonObject, cacheKey: cacheKey, cacheType: cacheType)
            DispatchQueue.main.async(execute: {
                completeHandler(result)
            })
        }
    }
    
    /**
     写入/更新缓存(同步) [按APP版本号缓存,不同版本APP,同一接口缓存数据互不干扰]
     - parameter jsonResponse: 要写入的数据(JSON)
     - parameter URL:          数据请求URL
     - parameter subPath:      二级文件夹路径subPath（可设置-可不设置）
     - returns: 是否写入成功
     */
    func saveCache(_ jsonObject: AnyObject, cacheKey: String, cacheType: XHDataCacheType?) -> Bool {
        
        lock.lock()
        let data = SpeedyJSON.jsonToData(jsonObject)
        let atPath = getCacheFilePath(cacheKey: cacheKey, cacheType: cacheType)
        
        let isSuccess = FileManager.default.createFile(atPath:atPath, contents: data, attributes: nil)
        lock.unlock()
        return isSuccess
    }
    
    /**
     获取缓存的对象(同步)
     - parameter URL: 数据请求URL
     - parameter subPath:      二级文件夹路径subPath（可设置-可不设置）
     - returns: 缓存对象
     */
    func getCacheObject(cacheKey: String, cacheType: XHDataCacheType?) -> AnyObject? {
        
        lock.lock()
        var resultObject: AnyObject?
        
        // 文件路径
        let filePath = getCacheFilePath(cacheKey: cacheKey, cacheType: cacheType)
        
        if FileManager.default.fileExists(atPath: filePath),
            let data = FileManager.default.contents(atPath: filePath),
            let tempObject = SpeedyJSON.dataToJson(data) {
            
            resultObject = tempObject
        }
        lock.unlock()
        return resultObject
    }
    
    /// 获取缓存文件路径
    /// - Parameters:
    ///   - cacheKey: 缓存的key
    ///   - subPath: 子路径
    /// - Returns: 全路径
    func getCacheFilePath(cacheKey: String, cacheType: XHDataCacheType?) -> String {
        
        // 文件夹的路径
        var folderPath: String = self.cachePath
        
        // 缓存的文件名称
        var fileName: String = "URL:\(cacheKey) AppVersion:\(SpeedyApp.version)".md5()
        if let tempType = cacheType {
            folderPath = self.cachePath + "/" + tempType.rawValue
            if tempType == .AttendanceReport {
                // 如果是考勤统计，不对cacheKey做处理
                fileName = cacheKey
            }
        }
        
        // 检查目录
        SpeedyFileManager.checkDirectory(at: folderPath)
        
        // 全路径
        let fullPath = folderPath + "/" + fileName
        return fullPath
    }
}

// MARK: - 清楚缓存
extension XHDataCacheManager {
    
    func clearCache() {
        // 1、清除工作圈数据缓存
        self.clearCacheFolder(cacheType: .WorkgroupCache)
    }
    
    // 清除指定文件夹下的全部缓存
    func clearCacheFolder(cacheType: XHDataCacheType) {
        
        let folderPath: String = self.cachePath + "/" + cacheType.rawValue
        SpeedyFileManager.removeFolder(folderPath)
        XHLogDebug("[数据缓存调试] - 清除缓存")
    }
    
    // 删除指定文件
    func deleteFile(cacheKey: String, cacheType: XHDataCacheType?) -> Bool {
        let filePath = self.getCacheFilePath(cacheKey: cacheKey, cacheType: cacheType)
        do {
            try FileManager.default.removeItem(atPath: filePath)
            XHLogDebug("[数据缓存调试] - 删除文件成功")
            return true
        } catch let error as NSError {
            XHLogDebug("[数据缓存调试] - 删除文件失败，error - [\(error)]")
            return false
        }
    }
}
