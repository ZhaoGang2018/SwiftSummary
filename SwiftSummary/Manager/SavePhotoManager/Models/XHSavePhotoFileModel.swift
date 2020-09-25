//
//  XHSavePhotoFileModel.swift
//  XCamera
//
//  Created by jing_mac on 2019/11/21.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit
import RealmSwift

class XHSavePhotoFileModel: NSObject {
    
    // 是否是视频
    var isVideo: Bool = false
    // 文件名称
    var fileName: String = ""
    // 文件路径
    var filePath: String = ""
    
    // 文件数据，处理图片的情况
    var fileData: Data?
    
    // 用户传值
    weak var delegate: XHSavePhotoToAlbumManagerDelegate?
    
    // 便利构造方法
    convenience init(isVideo: Bool, fileName: String, filePath: String, fileData: Data?, delegate: XHSavePhotoToAlbumManagerDelegate?) {
        self.init()
        
        self.isVideo = isVideo
        self.fileName = fileName
        self.filePath = filePath
        self.fileData = fileData
        self.delegate = delegate
    }
    
    // 获取文件路径
    func getFilePath() -> String {
        let cacheType: XHImageCacheType = self.isVideo ? .UserVideos : .UserPhotos
        let filePath = XHImageCacheManager.shared.getFilePath(self.fileName, cacheType: cacheType)
        return filePath
    }
    
    // 文件是否存在
       func isFileExists() -> Bool {
           let filePath = self.getFilePath()
           let result = FileManager.default.fileExists(atPath: filePath)
           return result
       }
    
//    // 构造视频的model
//    static func buildModel(info: VideoInfo, delegate: XHSavePhotoToAlbumManagerDelegate?) -> XHSavePhotoFileModel {
//        
//        let fileName = info.video_name
//        let filePath = XHImageCacheManager.shared.getFilePath(fileName, cacheType: .UserVideos)
//        
//        let videoModel = XHSavePhotoFileModel(isVideo: true, fileName: fileName, filePath: filePath, fileData: nil, delegate: delegate)
//        return videoModel
//    }
    
    static func buildModel(realmModel: RealmSavePhotoFileModel) -> XHSavePhotoFileModel {
        let memoryModel = XHSavePhotoFileModel(isVideo: realmModel.isVideo, fileName: realmModel.fileName, filePath: realmModel.filePath, fileData: nil, delegate: nil)
        return memoryModel
    }
}

// Realm的model
class RealmSavePhotoFileModel: Object {
    
    // 是否是视频
    @objc dynamic var isVideo: Bool = false
    
    // 文件名称(图片的唯一标识)
    @objc dynamic var fileName: String = ""
    
    // 文件路径
    @objc dynamic var filePath: String = ""
    
    override static func primaryKey() -> String? {
        return "fileName"
    }
    
    class func buildModel(memoryModel: XHSavePhotoFileModel) -> RealmSavePhotoFileModel {
        
        let realmModel = RealmSavePhotoFileModel()
        realmModel.isVideo = memoryModel.isVideo
        realmModel.fileName = memoryModel.fileName
        realmModel.filePath = memoryModel.filePath
        
        return realmModel
    }
}
