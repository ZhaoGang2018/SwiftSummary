//
//  XHSavePhotoToAlbumManager.swift
//  XCamera
//
//  Created by jing_mac on 2019/11/15.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

protocol XHSavePhotoToAlbumManagerDelegate: class {
    // 保存完成
    func savePhotoSuccess(model: XHSavePhotoFileModel)
    // 保存失败
    func savePhotoFailure(model: XHSavePhotoFileModel, error: Error?)
}

class XHSavePhotoToAlbumManager: NSObject {
    
    // 正在执行的任务
    var tasks: [String : XHSavePhotoToAlbumTask] = [:]
    let tasksLock = NSRecursiveLock()
    // 等待的队列
    var waitQueue: [XHSavePhotoToAlbumTask] = []
    
    // 最大并发数
    let maxCacheCount = 9
    
    var delegateModels: [String : XHSavePhotoFileModel] = [:]
    let delegateLock = NSRecursiveLock()
    
    static let shared = XHSavePhotoToAlbumManager()
    
    private override init() {
        super.init()
    }
    
//    // MARK: - 保存视频到手机相册
//    func saveVideoToAlbum(info: VideoInfo, delegate: XHSavePhotoToAlbumManagerDelegate?){
//        
//        let videoModel = XHSavePhotoFileModel.buildModel(info: info, delegate: delegate)
//        // 文件不存在
//        if videoModel.isFileExists() == false {
//            self.deleteRealmModel(videoModel.fileName)
//            delegate?.savePhotoFailure(model: videoModel, error: nil)
//            return
//        }
//        self.startSavePhotoOrVideo(videoModel)
//    }
    
    // MARK: - 保存图片到手机相册
    func savePhotoToAlbum(imageData: Data, delegate: XHSavePhotoToAlbumManagerDelegate?) {
        
        let imageName = NSUUID().uuidString.md5() + ".jpg"
        let imagePath = XHImageCacheManager.shared.getFilePath(imageName, cacheType: .UserPhotos)
        
        let isSuccess = FileManager.default.createFile(atPath: imagePath, contents: imageData, attributes: nil)
        XHLogDebug("[保存照片到相册调试] - XHSavePhotoToAlbumManager - 保存照片到沙盒是否成功:[\(isSuccess)]")
        
        let imageModel = XHSavePhotoFileModel(isVideo: false, fileName: imageName, filePath: imagePath, fileData: imageData, delegate: delegate)
        self.startSavePhotoOrVideo(imageModel)
    }
    
    // MARK: - 开始保存
    func startSavePhotoOrVideo(_ model: XHSavePhotoFileModel) {
        
        let taskKey = model.fileName
        // 视频文件不存在
        if model.isVideo, model.isFileExists() == false {
            self.deleteRealmModel(model.fileName)
            model.delegate?.savePhotoFailure(model: model, error: nil)
            return
        }
        
        self.delegateLock.lock()
        self.delegateModels[taskKey] = model
        self.delegateLock.unlock()
        
        self.addRealmModel(model)
        
        self.tasksLock.lock()
        if let executingTask = self.tasks[taskKey] {
            // 正在执行的任务
            executingTask.completeHandler = {[weak self] (isSuccess, error) in
                if isSuccess {
                    self?.savePhotoSuccess(model: model)
                } else {
                    self?.savePhotoFailure(model: model, error: error)
                }
            }
        } else {
            // 新的任务
            let singleTask = XHSavePhotoToAlbumTask(fileModel: model) { [weak self] (isSuccess, error) in
                if isSuccess {
                    self?.savePhotoSuccess(model: model)
                } else {
                    self?.savePhotoFailure(model: model, error: error)
                }
            }
            
            if self.tasks.count >= self.maxCacheCount {
                self.waitQueue.append(singleTask)
            } else {
                self.tasks[taskKey] = singleTask
                singleTask.startSave()
            }
            
            XHLogDebug("[保存照片到相册调试] - 正在执行队列[\(self.tasks.count)] - 等待队列[\(self.waitQueue.count)]] - delegateModels[\(self.delegateModels.count)]")
        }
        self.tasksLock.unlock()
    }
    
    // 执行等待队列中的任务
    private func startWaitQueueTask(task: XHSavePhotoToAlbumTask) {
        
        if let model = task.fileModel, model.fileName.count > 0 {
            task.completeHandler = {[weak self] (isSuccess, error) in
                if isSuccess {
                    self?.savePhotoSuccess(model: model)
                } else {
                    self?.savePhotoFailure(model: model, error: error as NSError?)
                }
            }
            self.tasks[model.fileName] = task
            task.startSave()
        }
    }
    
    // 保存照片成功
    private func savePhotoSuccess(model: XHSavePhotoFileModel) {
        if model.fileName.count > 0 {
            // 代理传值
            self.delegateLock.lock()
            for delegateModel in self.delegateModels.values {
                if let tempDele = delegateModel.delegate, delegateModel.fileName == model.fileName {
                    DispatchQueue.main.async {
                        tempDele.savePhotoSuccess(model: model)
                    }
                }
            }
            self.delegateModels.removeValue(forKey: model.fileName)
            self.delegateLock.unlock()
            
//            // 如果有 同步任务就不删除
//            let syncModel = XHSyncPhotoManager.shared.getSyncModelFromRealm(model.fileName)
//            if syncModel == nil {
//                var imagePath = ""
//                if model.isVideo {
//                    imagePath = XHImageCacheManager.shared.getFilePath(model.fileName, cacheType: .UserVideos)
//                } else {
//                    imagePath = XHImageCacheManager.shared.getFilePath(model.fileName, cacheType: .UserPhotos)
//                }
//                
//                let isSuccess = SpeedyFileManager.removeFile(at: imagePath)
//                XHLogDebug("[保存照片到相册调试] - XHSavePhotoToAlbumTask - 删除缓存照片:[\(isSuccess)]")
//            }
            self.deleteRealmModel(model.fileName)
            
            XHLogDebug("[保存照片到相册调试] - XHSavePhotoToAlbumManager - 保存成功fileName[\(model.fileName)]")
            // 处理下一条数据
            self.removeTask(key: model.fileName)
        }
    }
    
    // 保存照片失败
    private func savePhotoFailure(model: XHSavePhotoFileModel, error: Error?) {
        if model.fileName.count > 0 {
            // 代理传值
            self.delegateLock.lock()
            for delegateModel in self.delegateModels.values {
                if let tempDele = delegateModel.delegate, delegateModel.fileName == model.fileName {
                    DispatchQueue.main.async {
                        tempDele.savePhotoFailure(model: model, error: error)
                    }
                }
            }
            self.delegateModels.removeValue(forKey: model.fileName)
            self.delegateLock.unlock()
            
            XHLogDebug("[保存照片到相册调试] - XHSavePhotoToAlbumManager - 保存失败fileName[\(model.fileName)]")
            // 处理下一条数据
            self.removeTask(key: model.fileName)
        }
    }
    
    // MARK: - 移除任务
    private func removeTask(key: String) {
        
        self.tasksLock.lock()
        self.tasks.removeValue(forKey: key)
        if self.waitQueue.count > 0 {
            self.startWaitQueueTask(task: self.waitQueue[0])
            self.waitQueue.removeFirst()
        }
        
        XHLogDebug("[保存照片到相册调试] - XHSavePhotoToAlbumManager - 正在执行队列[\(self.tasks.count)] - 等待队列[\(self.waitQueue.count)]] - delegateModels[\(self.delegateModels.count)]")
        self.tasksLock.unlock()
    }
}
