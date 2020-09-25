//
//  XHRealmDatabaseManager+RealmDataMigration.swift
//  XCamera
//
//  Created by jing_mac on 2020/7/20.
//  Copyright © 2020 xhey. All rights reserved.
//

import Foundation
import RealmSwift

//MARK: - 主要处理数据迁移
extension XHRealmDatabaseManager {
    
    // 数据迁移
    func dataMigration(migration: Migration, oldSchemaVersion: UInt64) {
        
        // 数据库迁移,在V2.9.15中修改
        if (oldSchemaVersion < 22) {
            self.dataMigration_2_9_15(migration: migration)
        }
        
        // 在V2.9.45中修改
        self.dataMigration_2_9_45(migration: migration, oldSchemaVersion: oldSchemaVersion)
        
        // 对团队水印的数据做了修改，需要迁移数据库（在V2.9.50添加）
        if (oldSchemaVersion < 31) {
            self.dataMigration_2_9_50(migration: migration)
        }
    }
    
    // MARK: - 在V2.9.50中修改
    private func dataMigration_2_9_50(migration: Migration) {
        
//        // 主题model
//        migration.enumerateObjects(ofType: XHTeamWatermarkThemeModel_Realm.className()) { (oldObject, newObject) in
//
//            if let oldModel = oldObject {
//                let propertyNames = oldModel.getPropertyNames_xh()
//                if propertyNames.contains("id") {
//                    newObject?["id"] = oldObject?["id"] ?? 0
//                }
//            }
//        }
//
//        // logo的model
//        migration.enumerateObjects(ofType: XHTeamWatermarkLogoModel_Realm.className()) { oldObject, newObject in
//
//            if let oldModel = oldObject {
//                let propertyNames = oldModel.getPropertyNames_xh()
//                if propertyNames.contains("id") {
//                    newObject?["id"] = oldObject?["id"] ?? 0
//                }
//            }
//        }
//
//        // 编辑项的model
//        migration.enumerateObjects(ofType: XHTeamWatermarkEditItem_Realm.className()) { oldObject, newObject in
//
//            if let oldModel = oldObject {
//                let propertyNames = oldModel.getPropertyNames_xh()
//                if propertyNames.contains("id") {
//                    newObject?["id"] = oldObject?["id"] ?? 0
//                }
//
//                if propertyNames.contains("style") {
//                    newObject?["style"] = oldObject?["style"] ?? 0
//                }
//
//                if propertyNames.contains("editType") {
//                    newObject?["editType"] = oldObject?["editType"] ?? 0
//                }
//
//                if propertyNames.contains("userCustom") {
//                    newObject?["userCustom"] = oldObject?["userCustom"] ?? false
//                }
//            }
//        }
//
//        // 旧model
//        migration.enumerateObjects(ofType: XHWatermarkLogoModel_Realm.className()) { oldObject, newObject in
//
//            if let oldModel = oldObject {
//                let propertyNames = oldModel.getPropertyNames_xh()
//                if propertyNames.contains("id") {
//                    newObject?["id"] = oldObject?["id"] ?? 0
//                }
//            }
//        }
//
//        migration.enumerateObjects(ofType: XHWatermarkThemeModel_Realm.className()) { oldObject, newObject in
//
//            if let oldModel = oldObject {
//                let propertyNames = oldModel.getPropertyNames_xh()
//                if propertyNames.contains("id") {
//                    newObject?["id"] = oldObject?["id"] ?? 0
//                }
//            }
//        }
//
//        migration.enumerateObjects(ofType: XHWatermarkEditItem_Realm.className()) { oldObject, newObject in
//
//            if let oldModel = oldObject {
//                let propertyNames = oldModel.getPropertyNames_xh()
//                if propertyNames.contains("id") {
//                    newObject?["id"] = oldObject?["id"] ?? 0
//                }
//
//                if propertyNames.contains("style") {
//                    newObject?["style"] = oldObject?["style"] ?? 0
//                }
//
//                if propertyNames.contains("editType") {
//                    newObject?["editType"] = oldObject?["editType"] ?? 0
//                }
//            }
//        }
        
    }
    
    // MARK: - 在V2.9.45中修改
    private func dataMigration_2_9_45(migration: Migration, oldSchemaVersion: UInt64) {
        
//        // 以前数据中没有这个字段，所以新版本都要赋值（在V2.9.45版本添加）
//        if oldSchemaVersion < 29 {
//            migration.enumerateObjects(ofType: XHTeamWatermarkThemeModel_Realm.className()) { oldObject, newObject in
//                newObject?["fontScale"] = "1.0"
//                newObject?["sizeScale"] = "1.0"
//            }
//        }
//
//        if oldSchemaVersion < 25 {
//            // 小于25的没有这个字段，直接赋值
//            migration.enumerateObjects(ofType: XHWatermarkThemeModel_Realm.className()) { oldObject, newObject in
//                newObject?["fontScale"] = "1.0"
//                newObject?["sizeScale"] = "1.0"
//            }
//        } else if oldSchemaVersion == 25 {
//            // 只在25的这个版本中添加了以下两个字段，大于25的版本中修改了字段的属性
//            migration.enumerateObjects(ofType: XHWatermarkThemeModel_Realm.className()) { oldObject, newObject in
//
//                var fontScale: String = "1.0"
//                var sizeScale: String = "1.0"
//                if let oldModel = oldObject {
//                    let propertyNames = oldModel.getPropertyNames_xh()
//
//                    if propertyNames.contains("fontScale") {
//                        if let font = oldModel["fontScale"] as? Double{
//                            fontScale = String(format: "%.3f", font)
//                        }
//                    }
//
//                    if propertyNames.contains("sizeScale") {
//                        if let size = oldModel["sizeScale"] as? Double{
//                            sizeScale  = String(format: "%.3f", size)
//                        }
//                    }
//                }
//
//                newObject?["fontScale"] = fontScale
//                newObject?["sizeScale"] = sizeScale
//            }
//        }
    }
    
    // MARK: - 在V2.9.15中修改
    private func dataMigration_2_9_15(migration: Migration) {
        
//        // enumerateObjects(ofType:_:) 方法遍历了存储在 Realm 文件中的每一个“XHUploadRealmImageInfoModel”对象
//        migration.enumerateObjects(ofType: XHUploadRealmImageInfoModel.className()) { oldObject, newObject in
//            
//            if let oldModel = oldObject {
//                let propertyNames = oldModel.getPropertyNames_xh()
//                if propertyNames.contains("fileData") && propertyNames.contains("user_id") && propertyNames.contains("fileName") {
//                    
//                    // 去掉fileData
//                    if let imageData = oldObject?["fileData"] as? Data, let fileName = oldObject?["fileName"] as? String {
//                        let filePath = XHImageCacheManager.shared.getFilePath(fileName, cacheType: .UserPhotos)
//                        if FileManager.default.fileExists(atPath: filePath) == false {
//                            let isSuccess = FileManager.default.createFile(atPath: filePath, contents: imageData, attributes: nil)
//                            XHLogDebug("[同步照片调试] - 数据迁移照片保存到沙盒是否成功<3>[\(isSuccess)] - fileName[\(fileName)]")
//                        }
//                    }
//                }
//            }
//        }
//        
//        // 处理：ID20RealmLogoModel
//        migration.enumerateObjects(ofType: ID20RealmLogoModel.className()) { oldObject, newObject in
//            // 去掉fileData
//            if let oldModel = oldObject {
//                let propertyNames = oldModel.getPropertyNames_xh()
//                if propertyNames.contains("picData") {
//                    if let imageData = oldObject?["picData"] as? Data {
//                        let fileName = NSUUID().uuidString.md5()
//                        _ = XHImageCacheManager.shared.saveImage(imageData, fileName: fileName, cacheType: .UserLogos)
//                        newObject?["imageName"] = fileName
//                    }
//                }
//            }
//        }
//        
//        // 处理：XHWatermarkLogoModel_Realm
//        migration.enumerateObjects(ofType: XHWatermarkLogoModel_Realm.className()) { oldObject, newObject in
//            // 去掉fileData
//            if let oldModel = oldObject {
//                let propertyNames = oldModel.getPropertyNames_xh()
//                if propertyNames.contains("data") {
//                    if let imageData = oldModel["data"] as? Data {
//                        let fileName = NSUUID().uuidString.md5()
//                        _ = XHImageCacheManager.shared.saveImage(imageData, fileName: fileName, cacheType: .UserLogos)
//                        newObject?["imageName"] = fileName
//                    }
//                }
//            }
//        }
    }
    
}




/*
 // 数据迁移的方法：
 Realm.Configuration.defaultConfiguration = Realm.Configuration(
 schemaVersion: 1,
 migrationBlock: { migration, oldSchemaVersion in
 if (oldSchemaVersion < 1) {
 // enumerateObjects(ofType:_:) 方法遍历了存储在 Realm 文件中的每一个“Person”对象
 migration.enumerateObjects(ofType: Person.className()) { oldObject, newObject in
 // 将名字进行合并，存放在 fullName 域中
 let firstName = oldObject!["firstName"] as! String
 let lastName = oldObject!["lastName"] as! String
 newObject!["fullName"] = "\(firstName) \(lastName)"
 }
 }
 })
 */
