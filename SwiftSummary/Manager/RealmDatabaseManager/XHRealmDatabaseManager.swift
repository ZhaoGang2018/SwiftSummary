//
//  XHRealmDatabaseManager.swift
//  XCamera
//
//  Created by jing_mac on 2020/7/20.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit
import RealmSwift

fileprivate var tempRealm: Realm?

var realm: Realm? {
    get {
        if Thread.isMainThread {
            if tempRealm == nil{
                tempRealm = XHRealmDatabaseManager.shared.getDefaultRealm()
            }
            return tempRealm
        } else {
            return XHRealmDatabaseManager.shared.getDefaultRealm()
        }
    }
}

class XHRealmDatabaseManager: NSObject {
    
    static let shared = XHRealmDatabaseManager()
    
    private override init() {
        super.init()
    }
    
    func getDefaultRealm() -> Realm? {
        
        do {
            let newRealm = try Realm(configuration: Realm.Configuration(schemaVersion: XHGlobalConstant.realmSchemaVersion, migrationBlock: { [weak self] (migration, oldSchemaVersion) in
                
                XHLogDebug("[数据库调试] - 开始数据迁移oldSchemaVersion:[\(oldSchemaVersion)]")
                // 数据迁移
                self?.dataMigration(migration: migration, oldSchemaVersion: oldSchemaVersion)
            }))
            
            XHLogDebug("[数据库调试] - 生成Realm实例成功")
            return newRealm
            
        }catch let error {
            XHLogError("[数据库调试] - 获取默认的Realm的数据库失败:\n\(error.localizedDescription)")
//            Report.realmInitError(realm_error: error as NSError)
            
            /*
            // 初始化失败，从沙盒里删除default.realm文件
            if let url = Realm.Configuration.defaultConfiguration.fileURL {
                do {
                    try FileManager.default.removeItem(at: url)
                    XHLogDebug("[数据库调试] - 初始化失败，删除数据库成功")
                } catch {
                    XHLogDebug("[数据库调试] 初始化失败，删除数据库失败 - \(error)")
                }
            }
 */
            
            return nil
        }
    }
}
