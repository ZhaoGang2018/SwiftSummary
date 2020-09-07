//
//  SpeedyModel.swift
//  XCamera
//
//  Created by jing_mac on 2019/9/18.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

enum SpeedyModelError: Error {
    case message(String)
}

struct SpeedyModel {
    
    //TODO:转换模型(单个) 把字典转换成model
    public static func dictionaryToModel<T>(_ type: T.Type, param: [String:Any]) throws -> T where T: Decodable {
        
        guard let jsonData = SpeedyJSON.jsonToData(param) else {
            throw SpeedyModelError.message("转换data失败")
        }
        guard let model = try? JSONDecoder().decode(type, from: jsonData) else {
            throw SpeedyModelError.message("转换模型失败")
        }
        return model
    }
    
    //TODO:转换模型(多个) 把数组转换成models
    public static func arrayToModels<T>(_ type: T.Type, array: [[String:Any]]) throws -> T where T: Decodable{
        
        if let data = SpeedyJSON.jsonToData(array) {
            if let models = try? JSONDecoder().decode([T].self, from: data) {
                return models as! T
            }
        } else {
            XHLogDebug("模型转换->转换data失败")
        }
        throw SpeedyModelError.message("模型转换->转换data失败")
    }
    
    // MARK: - 把model转换成json字符串
    public static func modelToString<T>(_ model: T) -> String? where T: Encodable {
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(model)
            if let jsonStr = String(data: data, encoding: .utf8)  {
                return jsonStr
            }
        } catch let error as NSError {
            XHLogDebug("把model转换成字符串，error - [\(error)]")
        }
        return nil
    }
    
    // MARK: - 把model转换成字典
    public static func modelToDictionary<T>(_ model: T) -> [String:Any]? where T: Encodable {
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(model)
            if let dict = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String:Any] {
                return dict
            }
        } catch let error as NSError {
            XHLogDebug("把model转换成字典，error - [\(error)]")
        }
        
        return nil
    }
    
    // MARK: - 把model转换成AnyObject
    public static func modelToAnyObject<T>(_ model: T) -> AnyObject? where T: Encodable {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(model)
            let object = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as AnyObject
            return object
        } catch let error as NSError {
            XHLogDebug("把model转换成字典，error - [\(error)]")
        }
        return nil
    }
    
    // MARK: - 把AnyObject转换成model
    public static func anyToModel<T: Codable>(_ type: T.Type, param: Any) -> T? {
        
        guard let jsonData = SpeedyJSON.jsonToData(param) else {
            XHLogDebug("转换data失败")
            return nil
        }
        
        do {
            let model = try JSONDecoder().decode(type, from: jsonData)
            return model
        } catch {
            XHLogDebug("转换成model失败，error - [\(error)]")
        }
        return nil
    }
    
    public static func anyToModel2<T: Codable>(_ type: T.Type, param: Any) throws -> T {
        
        guard let jsonData = SpeedyJSON.jsonToData(param) else {
            throw SpeedyModelError.message("转换data失败")
        }
        guard let model = try? JSONDecoder().decode(type, from: jsonData) else {
            throw SpeedyModelError.message("转换模型失败")
        }
        return model
    }
    
    // MARK: - 把data转换成model
    static func dataToModel<T>(_ type: T.Type, data: Data?) -> T? where T : Decodable {
        
        if let currentData = data {
            do {
                let model = try JSONDecoder().decode(type, from: currentData)
                return model
            } catch {
                XHLogDebug("转换成model失败，error - [\(error)]")
            }
        }
        return nil
    }
    
    static func dataToModel2<T>(_ type: T.Type, data: Data?) throws -> T where T : Decodable {
        
        if let currentData = data {
            guard let model = try? JSONDecoder().decode(type, from: currentData) else {
                throw SpeedyModelError.message("转换模型失败")
            }
            return model
        } else {
            throw SpeedyModelError.message("data数据不存在")
        }
    }
}
