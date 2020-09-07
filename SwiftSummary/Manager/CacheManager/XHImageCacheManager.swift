//
//  XHImageCacheManager.swift
//  XCamera
//
//  Created by Quinn Von on 2/25/20.
//  Copyright © 2020 xhey. All rights reserved.
//  图片缓存

import UIKit
import Kingfisher

// 图片缓存的类型
enum XHImageCacheType: String {
    // 未加工的图片，是从底层直接获取的没有添加任何信息的图片，所有的其他图片都是由这张图生成的。
    case UnprocessedImages = "UnprocessedImages"
    // 用户拍摄或保存的图片
    case UserPhotos = "UserPhotos"
    // 用户拍摄的视频
    case UserVideos = "UserVideos"
    // 水印上设置的logo
    case UserLogos = "UserLogos"
    // 拼图生成的图片
    case imageStitching = "imageStitching"
    // 连拍生成的图片
    case continueShoot = "continueShoot"
}

class XHImageCacheManager {
    
    static let cacheTypes: [XHImageCacheType] = [.UnprocessedImages, .UserPhotos, .UserVideos, .UserLogos, .imageStitching, .continueShoot]
    
    // MARK: - 创建所有的缓存文件夹
    class func createBaseDirectorys() {
        for tempType in self.cacheTypes {
            let path = self.getFolderPath(tempType)
            SpeedyFileManager.checkDirectory(at: path)
        }
    }
    
    class func saveImage(_ imageData: Data, fileName: String, cacheType: XHImageCacheType) -> Bool {
        
        let filePath = self.getFilePath(fileName, cacheType: cacheType)
        let isSuccess = FileManager.default.createFile(atPath: filePath, contents: imageData, attributes: nil)
        XHLogDebug("[缓存图片调试]-保存图片到沙盒是否成功[\(isSuccess)]")
        return isSuccess
    }
    
    // 获取图片缓存文件路径
    class func getPhotoCacheFilePath(userId: String?, fileName: String) -> String {
        
        let folderPath = self.getFolderPath(.UserPhotos)
        
        var newPath: String = folderPath
        if let tempSubPath = userId, tempSubPath.count > 0 {
            newPath = folderPath + "/" + tempSubPath.md5()
        }
        
        SpeedyFileManager.checkDirectory(at: newPath)
        newPath = newPath + "/" + fileName
        return newPath
    }
    
    // 获取文件夹缓存路径
    class func getFolderPath(_ cacheType: XHImageCacheType) -> String {
        
        let folderPath = SpeedySandbox.shared.documentDirectory + "/" + cacheType.rawValue
        SpeedyFileManager.checkDirectory(at: folderPath)
        return folderPath
    }
    
    // 获取文件的缓存路径
    class func getFilePath(_ fileName: String, cacheType: XHImageCacheType) -> String {
        
        let folderPath = self.getFolderPath(cacheType)
        let fullPath = folderPath + "/" + fileName
        return fullPath
    }
    
    // 删除文件件
    class func deleteFolder(cacheType: XHImageCacheType) {
        
        let folderPath = self.getFolderPath(cacheType)
        
        _ = SpeedyFileManager.deleteFile(at: folderPath)
        SpeedyFileManager.createDirectory(at: folderPath)
    }
    
    // MARK: - 删除文件
    class func deleteFile(_ fileName: String, cacheType: XHImageCacheType) -> Bool {
        
        let filePath = self.getFilePath(fileName, cacheType: cacheType)
        return SpeedyFileManager.deleteFile(at: filePath)
    }
}

extension XHImageCacheManager {
    
    // 设置KingFisher参数
    class func setupKingFisherCache() {
        let cache = ImageCache(name: "default")
        KingfisherManager.shared.cache = cache
        
        // 设置内存缓存的大小，默认是0 pixel表示no limit ，注意它是像素为单位，与我们平时的bytes不同
        KingfisherManager.shared.cache.memoryStorage.config.totalCostLimit = 30 * 1024 * 1024
        
        // 磁盘缓存大小，默认0 bytes表示no limit （50 * 1024）
        KingfisherManager.shared.cache.diskStorage.config.sizeLimit = 0
        
        // 设置缓存周期 (默认1 week）
        //        cache.maxCachePeriodInSecond = 60 * 60 * 24 * 7
        cache.diskStorage.config.expiration = .seconds(60 * 60 * 24 * 7)
    }
    
    // 下载图片,不会缓存图片到disk
    class func downloadImage(url str: String?, finishedHandler: ((_ img:UIImage?,_ imageData:Data?,_ error:Error?)->())?) {
        if let imageUrlStr = str, let url = URL(string: imageUrlStr) {
            
            KingfisherManager.shared.downloader.downloadImage(with: url, options: nil) { (result) in
                switch result {
                case .success(let value):
                    finishedHandler?(value.image, value.originalData, nil)
                    
                case .failure(let error):
                    finishedHandler?(nil, nil, error)
                }
            }
        }else{
            let error = NSError(domain: "url is error", code: -1, userInfo: nil)
            finishedHandler?(nil,nil,error)
        }
    }
}
