//
//  SpeedyJSON.swift
//  XCamera
//
//  Created by jing_mac on 2019/9/19.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

class SpeedyJSON {
    
    // MARK: - JSONString转换为字典
    class func stringToDictionary(_ jsonString: String) -> [String : Any]? {
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            let dict = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String : Any]
            return dict
        } catch let error as NSError {
            XHLogDebug("把jsonString转换成字典，error - [\(error)]")
        }
        return nil
    }
    
    // MARK: - JSONString转换为数组
    class func stringToArray(_ jsonString:String) -> [Any]?{
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            let array = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [Any]
            return array
        } catch let error as NSError {
            XHLogDebug("把jsonString转换成Array，error - [\(error)]")
        }
        
        return nil
    }
    
    // MARK: - 字典转换成字符串
    class func dictionaryToJsonString(_ dictionary: Dictionary<AnyHashable, Any>) -> String {
        
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            XHLogDebug("无法解析出JSONString")
            return ""
        }
        
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            XHLogDebug("解析成data失败")
            return ""
        }
        
        if let jsonStr = String(data: data, encoding: .utf8) {
            return jsonStr
        } else {
            return ""
        }
    }
    
    // MARK: - 数组转换为JSONString
    class func arrayToJsonString(_ array: Array<Any>) -> String {
        
        if (!JSONSerialization.isValidJSONObject(array)) {
            XHLogDebug("无法解析出JSONString")
            return ""
        }
        
        guard let data = try? JSONSerialization.data(withJSONObject: array, options: []) else {
            XHLogDebug("解析成data失败")
            return ""
        }
        
        if let jsonStr = String(data: data, encoding: .utf8) {
            return jsonStr
        } else {
            return ""
        }
    }
    
    // MARK: - data转换成json
    class func dataToJson(_ data: Data) -> AnyObject? {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
            return json
        } catch {
            XHLogDebug("data转换成json失败，error - [\(error)]")
            return nil
        }
    }
    
    // MARK: - 把任意类型的数据转换成data
    class func jsonToData(_ param: Any) -> Data?{
        
        if let string = param as? String, let strData = string.data(using: .utf8) {
            return strData
        }
        
        if !JSONSerialization.isValidJSONObject(param) {
            XHLogDebug("转换成data失败-非法的JSONObject")
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: param, options: [])
            return data
        } catch let error as NSError {
            XHLogDebug("转换成data失败，error - [\(error)]")
        }
        return nil
    }
    
    // MARK: - 把data转换成json
    class func dataToAnyObject(data: Data) -> AnyObject? {
        
        var result: AnyObject?
        do {
            result = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
        } catch {
            XHLogDebug("转换成json失败，error - [\(error)]")
        }
        return result
    }
    
    class func dataToAnyObject2(data: Data) throws -> AnyObject {
        
        guard let result = try? JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as AnyObject else {
            throw SpeedyModelError.message("转换成json失败")
        }
        return result
    }
}
