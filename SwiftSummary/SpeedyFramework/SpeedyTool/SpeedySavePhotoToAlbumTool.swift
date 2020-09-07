//
//  SpeedySavePhotoToAlbumTool.swift
//  XCamera
//
//  Created by jing_mac on 2020/7/22.
//  Copyright © 2020 xhey. All rights reserved.
//  通用的保存图片和视频到手机相册的工具

import UIKit

typealias SpeedySavePhotoCompletionHandler = (_ isSuccess: Bool, _ error: Error?, _ errorMsg: String?) -> ()

class SpeedySavePhotoToAlbumTool: NSObject {
    
    // MARK: - 通过UIImage保存到手机相册(这种方式会丢失exif信息)
    class func savePhoto(image: UIImage, albumName: String? = "今日水印相机", complete: SpeedySavePhotoCompletionHandler?) {
        
        self.saveByImage(image, albumName: albumName, complete: complete)
    }
    
    // MARK: - 通过Data保存到手机相册（注意下面的备注）
    class func savePhoto(imageData: Data, albumName: String? = "今日水印相机", complete: SpeedySavePhotoCompletionHandler?) {
        
        if let name = albumName, name.count > 0 {
            // 如果要保存到自定义相册，可以尝试用这种方式，保证exif信息不会丢失
            let fileName = NSUUID().uuidString.md5() + ".jpg"
            let isSuccess = XHImageCacheManager.saveImage(imageData, fileName: fileName, cacheType: .UserPhotos)
            let filePath = XHImageCacheManager.getFilePath(fileName, cacheType: .UserPhotos)
            if isSuccess {
                // 通过路径保存
                self.saveByPath(filePath, albumName: albumName, isVideo: false, isDeleteFromSanbox: true, complete: complete)
            } else {
                // 如果保存到沙盒失败，则保存到系统相册
                self.saveByData(imageData, complete: complete)
            }
        } else {
            // 直接保存到手机的系统相册
            self.saveByData(imageData, complete: complete)
        }
    }
    
    // MARK: - 通过文件路径保存图片到手机相册
    class func savePhoto(filePath: String, albumName: String? = "今日水印相机", complete: SpeedySavePhotoCompletionHandler?) {
        
        self.saveByPath(filePath, albumName: albumName, isVideo: false, isDeleteFromSanbox: false, complete: complete)
    }
    
    // MARK: - 通过文件路径保存视频到手机相册
    class func saveVideo(filePath: String, albumName: String? = "今日水印相机", complete: SpeedySavePhotoCompletionHandler?) {
        
        self.saveByPath(filePath, albumName: albumName, isVideo: true, isDeleteFromSanbox: false, complete: complete)
    }
    
    // MARK: - 通过路径保存
    private class func saveByPath(_ filePath: String, albumName: String?, isVideo: Bool, isDeleteFromSanbox: Bool, complete: SpeedySavePhotoCompletionHandler?) {
        
        if filePath.count == 0 || FileManager.default.fileExists(atPath: filePath) == false {
            complete?(false, nil, "获取数据失败")
            return
        }
        
        func beginSave() {
            
            var newCollect: PHAssetCollection?
            var newAssets: PHFetchResult<PHAsset>?
            if let currentAlbumName = albumName, currentAlbumName.count > 0 {
                newCollect = self.createdCollection(albumName: currentAlbumName)
                newAssets = self.createdAssets(filePath: filePath, isVideo: isVideo)
            }
            
            PHPhotoLibrary.shared().performChanges({
                if let collect = newCollect, let createdAssets = newAssets {
                    // 保存到自定义相册
                    let request = PHAssetCollectionChangeRequest(for: collect)
                    request?.insertAssets(createdAssets, at: NSIndexSet(index: 0) as IndexSet)
                } else {
                    // 保存到系统相册
                    let fileUrl = URL(fileURLWithPath: filePath)
                    if isVideo {
                        PHAssetCreationRequest.forAsset().addResource(with: .video, fileURL: fileUrl, options: nil)
                    } else {
                        PHAssetCreationRequest.forAsset().addResource(with: .photo, fileURL: fileUrl, options: nil)
                    }
                }
                
            }, completionHandler: { (success, error) in
                // NOT on main thread
                DispatchQueue.main.async {
                    if success {
                        XHLogDebug("[保存照片或视频到相册调试]- \(isVideo ? "视频": "图片") - 保存成功")
                        if isDeleteFromSanbox {
                            do {
                                try FileManager.default.removeItem(atPath: filePath)
                            } catch  {
                                XHLogDebug("[保存照片或视频到相册调试] - 删除保存成功的图片失败error:[\(error)]")
                            }
                        }
                        complete?(true, nil, nil)
                    } else {
                        XHLogDebug("[保存照片或视频到相册调试] - \(isVideo ? "视频": "图片") - 保存失败")
                        complete?(false, error, "保存失败")
                    }
                }
            })
        }
        
        SpeedyCheckAuthorizationTool.checkPhotoAlbumPermission { (hasPermission) in
            if hasPermission {
                beginSave()
            } else {
                complete?(false, nil, "请打开相册访问权限")
            }
        }
    }
    
    // MARK: - 通过UIImage保存
    private class func saveByImage(_ image: UIImage, albumName: String?, complete: SpeedySavePhotoCompletionHandler?) {
        
        func beginSave() {
            var newCollect: PHAssetCollection?
            var newAssets: PHFetchResult<PHAsset>?
            if let currentAlbumName = albumName, currentAlbumName.count > 0 {
                newCollect = self.createdCollection(albumName: currentAlbumName)
                newAssets = self.createdAssets(image: image)
            }
            
            PHPhotoLibrary.shared().performChanges({
                if let currentCollect = newCollect, let currentAssets = newAssets  {
                    // 保存到自定义相册
                    let request = PHAssetCollectionChangeRequest(for: currentCollect)
                    request?.insertAssets(currentAssets, at: NSIndexSet(index: 0) as IndexSet)
                } else {
                    // 保存到系统相册
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }
                
            }, completionHandler: { (success, error) in
                // NOT on main thread
                DispatchQueue.main.async {
                    if success {
                        XHLogDebug("[保存照片或视频到相册调试] - 图片 - 保存成功")
                        complete?(true, nil, nil)
                    } else {
                        XHLogDebug("[保存照片或视频到相册调试] - 图片 - 保存失败")
                        complete?(false, error, "保存失败")
                    }
                }
            })
        }
        
        SpeedyCheckAuthorizationTool.checkPhotoAlbumPermission { (hasPermission) in
            if hasPermission {
                beginSave()
            } else {
                complete?(false, nil, "请打开相册访问权限")
            }
        }
    }
    
    // MARK: - 通过data保存
    private class func saveByData(_ imageData: Data, complete: SpeedySavePhotoCompletionHandler?) {
        
        func beginSave() {
            
            PHPhotoLibrary.shared().performChanges({
                // 保存到系统相册
                PHAssetCreationRequest.forAsset().addResource(with: .photo, data: imageData, options: nil)
                
            }, completionHandler: { (success, error) in
                // NOT on main thread
                DispatchQueue.main.async {
                    if success {
                        XHLogDebug("[保存照片或视频到相册调试] - 图片 - 保存成功")
                        complete?(true, nil, nil)
                    } else {
                        XHLogDebug("[保存照片或视频到相册调试] - 图片 - 保存失败")
                        complete?(false, error, "保存失败")
                    }
                }
            })
        }
        
        SpeedyCheckAuthorizationTool.checkPhotoAlbumPermission { (hasPermission) in
            if hasPermission {
                beginSave()
            } else {
                complete?(false, nil, "请打开相册访问权限")
            }
        }
    }
}

extension SpeedySavePhotoToAlbumTool {
    
    // MARK: - 创建自定义的相册
    private class func createdCollection(albumName: String) -> PHAssetCollection? {
        
        // 相册的名称不能为空
        if albumName.count == 0 {
            return nil
        }
        
        // 抓取所有的自定义相册
        let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        
        // 查找当前App对应的自定义相册
        for index in 0..<collections.count {
            let collection = collections.object(at: index)
            if collection.localizedTitle == albumName {
                return collection
            }
        }
        
        // 当前App对应的自定义相册没有被创建过
        // 创建一个`自定义相册`
        var createdCollectionID: String = ""
        guard let _ = try? PHPhotoLibrary.shared().performChangesAndWait({
            createdCollectionID = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName).placeholderForCreatedAssetCollection.localIdentifier
        }) else {
            return nil
        }
        
        // 根据唯一标识获得刚才创建的相册
        let result = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [createdCollectionID], options: nil).firstObject
        
        return result
    }
    
    // MARK: - 创建相片(通过路径)
    private class func createdAssets(filePath: String, isVideo: Bool) -> PHFetchResult<PHAsset>? {
        
        // 文件不存在
        if filePath.count == 0 || FileManager.default.fileExists(atPath: filePath) == false {
            return nil
        }
        
        let fileUrl = URL(fileURLWithPath: filePath)
        var assetID: String = ""
        if isVideo {
            guard let _ = try? PHPhotoLibrary.shared().performChangesAndWait({
                assetID = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileUrl)?.placeholderForCreatedAsset?.localIdentifier ?? ""
            }) else {
                return nil
            }
        } else {
            guard let _ = try? PHPhotoLibrary.shared().performChangesAndWait({
                assetID = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileUrl)?.placeholderForCreatedAsset?.localIdentifier ?? ""
            }) else {
                return nil
            }
        }
        
        let result = PHAsset.fetchAssets(withLocalIdentifiers: [assetID], options: nil)
        return result
    }
    
    // MARK: - 创建相片(通过UIImage)
    private class func createdAssets(image: UIImage) -> PHFetchResult<PHAsset>? {
        
        var assetID: String = ""
        guard let _ = try? PHPhotoLibrary.shared().performChangesAndWait({
            assetID = PHAssetChangeRequest.creationRequestForAsset(from: image).placeholderForCreatedAsset?.localIdentifier ?? ""
        }) else {
            return nil
        }
        
        let result = PHAsset.fetchAssets(withLocalIdentifiers: [assetID], options: nil)
        return result
    }
}
