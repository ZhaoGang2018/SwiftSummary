//
//  XHNetworkRequestResult.swift
//  XCamera
//
//  Created by jing_mac on 2020/2/7.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit
import Foundation
import HandyJSON

enum XHNetworkRequestState {
    case success // 请求成功
    case failure // 请求失败
    case cancel  // 请求被取消
}

/*
 * 说明：这个model记录的是本次http请求的数据以及详细的时间线，不涉及具体的业务。
 * 这里存储了获取的原始data和json数据，需要在业务层进行model的转化。
 */
class XHNetworkRawResultModel {
    var state: XHNetworkRequestState = .success
    
    var statusCode: Int? // 状态码，只用等于200的才算业务层的成功
    
    var json: AnyObject? // 解密后的数据，只有success才会有值，否则为nil
    var data: Data? // 解密后的数据，只有success才会有值，否则为nil
    
    var rawData: Data? // 加密情况下还没有解密，只有success才会有值，否则为nil
    var rawJson: AnyObject? // 加密情况下还没有解密，只有success才会有值，否则为nil
    
    var error: Error? // 只有failure才会有值，否则为nil
    
    // 以下是时间线，用于数据统计
    var startTime: String = "" // 请求的开始时间点
    var initialResponseTime: String = "" // 接收到服务器第一帧数据的时间点
    var serializationCompletedTime: String = "" // 序列化结束时间点
    var requestCompletedTime: String = "" // 请求完成的时间点
    
    var latency: Int = 0 // 建立连接用时(ms)
    var requestDuration: Int = 0 // 请求用时(ms)
    var serializationDuration: Int = 0 // 序列化用时(ms)
    var totalDuration: Int = 0 // 总耗时(ms)
    
    //方便查看数据类型，json:AnyObject 在控制台没有办法查看 Int 类型，还是 String类型
    var jsonString:String{
        if let data = data{
            guard let str = String.init(data: data, encoding: .utf8) else { return "" }
            return str
        }else{
            return ""
        }
    }
}

/*
 * 说明：这个model记录的是业务数据格式
 * 直接使用这个model中的data进行业务开发
 */
struct XHNetworkBusinessResult<T: Codable>: Codable {
    var code: Int = 0
    var msg: String = ""
    var toast_msg: String?
    var data: T?
}

/*
 * 说明：这个model记录的是业务数据格式
 * 直接使用这个model中的data进行业务开发
 */
struct XHNetworkBusinessHandyJsonResult<T: HandyJSON>: HandyJSON {
    var code: Int = 0
    var msg: String = ""
    var toast_msg: String?
    var data: T?
}

//MARK: - handyJSONReques接口请求后台返回的数据的基类
class XHNetworkResponseBaseResult: Codable, HandyJSON {
    
    var status: Int?
    var msg: String?
    required init() {}
}

