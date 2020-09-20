//
//  XHSavePhotoToAlbumManager+Realm.swift
//  XCamera
//
//  Created by jing_mac on 2020/9/15.
//  Copyright © 2020 xhey. All rights reserved.
//

import Foundation

extension XHSavePhotoToAlbumManager {
    
    // MARK: - 获取所有同步错误的models
    func getAllFailedModelsFromRealm() -> [XHSavePhotoFileModel] {
        
//        var resultModels:[XHSavePhotoFileModel] = []
//
//        if let realmModels = realm?.objects(RealmSavePhotoFileModel.self){
//            for model in realmModels {
//                let memoryModel = XHSavePhotoFileModel.buildModel(realmModel: model)
//                resultModels.append(memoryModel)
//            }
//        }
//        return resultModels
        
        return []
    }
    
    // MARK: - 清空数据库中所有的失败的model
    func removeAllFailedModelsFromRealm() {
        
//        if let realmModels = realm?.objects(RealmSavePhotoFileModel.self) {
//            for model in realmModels {
//                try? realm?.write {
//                    realm?.delete(model)
//                }
//            }
//        }
    }
    
    // MARK: - 获取单张图片的任务
    func getFailedModelFromRealm(_ fileName: String) -> XHSavePhotoFileModel? {
        
//        if let model = realm?.object(ofType: RealmSavePhotoFileModel.self, forPrimaryKey: fileName) {
//            let memoryM = XHSavePhotoFileModel.buildModel(realmModel: model)
//            return memoryM
//        }
        return nil
    }
    
    // MARK: - 移除单张图片的任务
    func removeFailedModelFromRealm(_ fileName: String) {
        
//        if let model = realm?.object(ofType: RealmSavePhotoFileModel.self, forPrimaryKey: fileName) {
//            try? realm?.write {
//                realm?.delete(model)
//            }
//        }
    }
    
    // 增加
    func addRealmModel(_ model: XHSavePhotoFileModel) {
        
//        let realmModel = RealmSavePhotoFileModel.buildModel(memoryModel: model)
//        do {
//            try realm?.write {
//                realm?.add(realmModel, update: .all)
//            }
//        } catch {
//            XHLogDebug("[保存照片到相册调试] - XHSavePhotoToAlbumManager - 保存任务到数据库失败error:[\(error)]")
//        }
    }
    
    // 从数据库删除
    func deleteRealmModel(_ fileName: String) {
        
//        if let realmModel = realm?.object(ofType: RealmSavePhotoFileModel.self, forPrimaryKey: fileName) {
//            do {
//                try realm?.write {
//                    realm?.delete(realmModel)
//                }
//            } catch {
//                XHLogDebug("[保存照片到相册调试] - XHSavePhotoToAlbumManager - 删除任务从数据库失败error:[\(error)]")
//            }
//        }
    }
}
