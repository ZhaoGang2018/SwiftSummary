//
//  XHKTVHTTPCacheManager.swift
//  XCamera
//
//  Created by jing_mac on 2020/9/14.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit

class XHKTVHTTPCacheManager: NSObject {
    
    static func setupHTTPCache() {
        
        KTVHTTPCache.logSetConsoleLogEnable(false)
        
        do {
            try KTVHTTPCache.proxyStart()
        } catch  {
            XHLogDebug("[KTVHTTPCache] - 开启KTVHTTPCache失败，error:[\(error)]")
        }
        
        KTVHTTPCache.encodeSetURLConverter { (url) -> URL? in
            XHLogDebug("[KTVHTTPCache] - URL Filter reviced URL:[\(String(describing: url))]")
            return url
        }
        
        KTVHTTPCache.downloadSetUnacceptableContentTypeDisposer { (url, contentType) -> Bool in
            
            XHLogDebug("[KTVHTTPCache] - Unsupport Content-Type Filter reviced URL:[\(String(describing: url))] - contentType:[\(String(describing: contentType))]")
            return false
        }
    }
    
    // 获取代理url
    static func getProxyURL(_ originalURL: URL) -> URL? {
        
        let proxyURL = KTVHTTPCache.proxyURL(withOriginalURL: originalURL)
        return proxyURL
    }
    
    // 所有的缓存
    static func getAllCacheItems() -> [KTVHCDataCacheItem] {
        KTVHTTPCache.cacheAllCacheItems()
    }
    
    static func deleteAllCaches() {
        KTVHTTPCache.cacheDeleteAllCaches()
    }
    
    // 获取缓存的Item
    static func getCacheItem(_ url: URL) -> KTVHCDataCacheItem? {
        
        let result = KTVHTTPCache.cacheCacheItem(with: url)
        return result
    }
    
    // 获取完整的url
    static func getCompleteFileURL(_ url: URL) -> URL? {
        let url = KTVHTTPCache.cacheCompleteFileURL(with: url)
        return url
    }
    
    // 删除单个文件
    static func deleteCacheItem(_ url: URL) {
        KTVHTTPCache.cacheDelete(with: url)
    }
}
