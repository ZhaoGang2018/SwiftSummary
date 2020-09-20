//
//  XHSavePhotoToAlbumManager+RetrySave.swift
//  XCamera
//
//  Created by jing_mac on 2020/9/15.
//  Copyright © 2020 xhey. All rights reserved.
//  重试把图片和视频保存到手机相册

import Foundation

extension XHSavePhotoToAlbumManager {
    
    // 重试保存照片和视频到手机相册
    func retrySavePhotosOrVideosToAlbum() {
//        if XHUserManager.shared.photoVideoSynsLocalType == .saveLocal {
//            let failedModels = self.getAllFailedModelsFromRealm()
//            for tempModel in failedModels {
//                // 如果文件不存在，删除数据库
//                if FileManager.default.fileExists(atPath: tempModel.getFilePath()) {
//                    self.startSavePhotoOrVideo(tempModel)
//                } else {
//                    self.deleteRealmModel(tempModel.fileName)
//                }
//            }
//        }
    }
}

