//
//  XHSavePhotoToAlbumTask.swift
//  XCamera
//
//  Created by jing_mac on 2019/11/21.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

typealias XHSavePhotoCompletionHandler = (_ isSuccess: Bool, _ error: Error?) -> ()

class XHSavePhotoToAlbumTask: NSObject {
    
    var fileModel: XHSavePhotoFileModel?
    var completeHandler: XHSavePhotoCompletionHandler?
    
    deinit {
        XHLogDebug("[deinit] - XHSavePhotoToAlbumTask - \(String(describing: self.fileModel?.fileName))")
    }
    
    init(fileModel: XHSavePhotoFileModel, complete: XHSavePhotoCompletionHandler?) {
        super.init()
        self.fileModel = fileModel
        self.completeHandler = complete
    }
    
    func startSave() {
        if let currentModel = self.fileModel {
            if currentModel.isVideo {
                // 保存的是视频
                self.saveVideo(model: currentModel)
            } else {
                // 保存的是图片
                self.savePhoto(model: currentModel)
            }
        } else {
            XHLogDebug("[保存照片到相册调试] - XHSavePhotoToAlbumTask - 保存失败 - fileModel不存在")
            self.completeHandler?(false, nil)
        }
    }
    
    private func saveVideo(model: XHSavePhotoFileModel) {
        
        if model.fileName.count > 0 {
            let videoPath = XHImageCacheManager.shared.getFilePath(model.fileName, cacheType: .UserVideos)
            XHSavePhotoToAlbumTool.saveVideo(filePath: videoPath) { (isSuccess, error, errorMsg) in
                DispatchQueue.main.async {
                    if(isSuccess){
                        XHLogDebug("[保存照片到相册调试] - XHSavePhotoToAlbumTask - 视频-保存成功")
                        self.completeHandler?(true, nil)
                    }else{
                        XHLogDebug("[保存照片到相册调试] - XHSavePhotoToAlbumTask - 视频 - 保存失败:[\(String(describing: error))]")
                        self.completeHandler?(false, error)
                    }
                }
            }
        } else {
            XHLogDebug("[保存照片到相册调试] - XHSavePhotoToAlbumTask - 视频 - 保存失败 - model不存在")
            self.completeHandler?(false, nil)
        }
    }
    
    private func savePhoto(model: XHSavePhotoFileModel) {
        
        if model.fileName.count == 0 {
            XHLogDebug("[保存照片到相册调试] - XHSavePhotoToAlbumTask - 图片 - 保存失败 - 图片数据丢失")
            self.completeHandler?(false, nil)
            return
        }
        
        let imagePath = XHImageCacheManager.shared.getFilePath(model.fileName, cacheType: .UserPhotos)
        
        XHSavePhotoToAlbumTool.savePhoto(filePath: imagePath) { (isSuccess, error, errorMsg) in
            DispatchQueue.main.async {
                if isSuccess {
                    XHLogDebug("[保存照片到相册调试] - XHSavePhotoToAlbumTask - 图片 - 保存成功")
                    self.completeHandler?(true, nil)
                } else {
                    XHLogDebug("[保存照片到相册调试] - XHSavePhotoToAlbumTask - 使用路径保存失败， 尝试使用data保存")
                    if let imageData = model.fileData {
                        self.savePhotoByData(imageData, fileName: model.fileName)
                    }
                }
            }
        }
    }
    
    // 使用路径保存失败， 尝试使用data保存
    private func savePhotoByData(_ data: Data, fileName: String) {
        
        XHSavePhotoToAlbumTool.savePhoto(imageData: data) { (isSuccess, error, errorMsg) in
            DispatchQueue.main.async {
                if isSuccess {
                    XHLogDebug("[保存照片到相册调试] - XHSavePhotoToAlbumTask - 图片 - 保存成功")
                    self.completeHandler?(true, nil)
                } else {
                    XHLogDebug("[保存照片到相册调试] - XHSavePhotoToAlbumTask - 图片 - 保存失败")
                    self.completeHandler?(false, error)
                }
            }
        }
    }
}
