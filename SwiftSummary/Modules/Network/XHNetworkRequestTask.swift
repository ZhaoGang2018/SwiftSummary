////
////  XHNetworkRequestTask.swift
////  XCamera
////
////  Created by 赵刚 on 2020/2/1.
////  Copyright © 2020 xhey. All rights reserved.
////
//
//import UIKit
//import Foundation
//import Alamofire
//
//class XHNetworkRequestTask: NSObject {
//
//    var manager = DENetManager.manager
//    var longTimeoutManager = DENetManager.longTimeoutManager
//    var defauleHeader: Alamofire.HTTPHeaders {
//
//        let version: String = SpeedyApp.version  //XHGlobalConstant.appBuildVersion
//        let deviceId: String = "\(XCAMERA_SENSORS_DEVICE_ID)"
//        let dict = ["iOS-Version" : version, "device_id" : deviceId, "platform": "iOS"]
//        let headers = Alamofire.HTTPHeaders(dict)
//        return headers
//    }
//
//    // 每一次请求都有一个唯一的标识（用于区分每次请求）
//    var requestKey: String = ""
//
//    // 请求的等级，等级越高越优先调用（用于优先调用重要接口）
//    var level: XHNetworkRequestLevel = .normal
//
//    // 保存从最开始传过来的handler
//    var requestHandler: XHNetworkRequestCompleteHandler?
//
//    // 保存谁调用的接口
//    var requestAPI: XHNetworkRequestAPI?
//
//    // 请求接口的具体参数
//    var path: String = ""
//    var methodType: MethodType = .get
//    var params : [String : Any]?
//    var encoding: ParameterEncoding = URLEncoding.default
//    var headers: [String : String]?
//
//    // 完成的回调
//    var completeHandler: ((_ task: XHNetworkRequestTask, _ result: XHNetworkRawResultModel) -> ())?
//
//    // 请求的url
//    var currentUrl: String?
//
//    // 记录当前的请求
//    var currentRequest: DataRequest?
//
//    deinit {
//        XHLogDebug("[网络请求调试] - deinit - XHNetworkRequestTask")
//    }
//
//    // 具体请求的方法
//    func startRequest() {
//        var using_manager = manager
//        if path == "ios/config"{
//            using_manager = longTimeoutManager
//        }
//
//        let _headers: Alamofire.HTTPHeaders = (headers != nil) ? Alamofire.HTTPHeaders(headers ?? [:]) : defauleHeader
//
//        let currentUrl = XHIPManager.shared.buildUrl(by: path)
//        XHLogDebug("[网络请求调试] - 请求的url:[\(currentUrl)]")
//        XHLogDebug("[网络请求调试] - 请求的参数:[\(String(describing: params))]")
//        let method: HTTPMethod = methodType == .get ? HTTPMethod.get : HTTPMethod.post
//        var finalParams = params
//        if isEncryptTransport == true, let currentParams = params, let _ = encoding as? JSONEncoding {
//            var encryptParams:[String : Any] = [:]
//            let jsonStr = SpeedyJSON.dictionaryToJsonString(currentParams)
//            let encryptStr = XHSecurityManager.shared.encryptAES(str: jsonStr)
//            encryptParams["params"] = encryptStr
//            XHLogDebug("[网络请求调试] - 加密后的参数:[\(String(describing: encryptParams))]")
//            finalParams = encryptParams
//        } else {
//            XHLogDebug("[网络请求调试] - 不需要加密的参数:[\(String(describing: finalParams))]")
//        }
//
//        if XHIPManager.shared.retryDic[path] == nil{
//            XHIPManager.shared.retryDic[path] = 1
//        }
//
//        // 完整的url
//        self.currentUrl = currentUrl
//        self.currentRequest = using_manager.request(currentUrl,
//                                                    method: method,
//                                                    parameters: finalParams,
//                                                    encoding: encoding,
//                                                    headers: _headers)
//        
//        self.currentRequest?.responseJSON(completionHandler: { [weak self] (response) in
//            if let weakSelf = self {
//                weakSelf.requestFinished(response: response)
//            }
//        })
//    }
//
//    // 请求结束
//    private func requestFinished(response: AFDataResponse<Any>) {
//
//        let result = XHNetworkRawResultModel()
//
//        // 配置时间线
////        self.configTimeline(response: response, result: result)
//
//        switch response.result{
//        case .success(_):
//            result.state = .success
//            result.statusCode = response.response?.statusCode
//            result.rawData = response.data
//            result.rawJson = response.value as AnyObject?
//
//            var finalData = response.data
//            if let currentData = response.data, isEncryptTransport == true {
//                if let jsonStr = String(data: currentData, encoding: .utf8),
//                    let jsonDict = SpeedyJSON.stringToDictionary(jsonStr),
//                    let encryptStr = jsonDict["result"] as? String {
//                    let decryptStr = XHSecurityManager.shared.decryptAES(str: encryptStr)
//
//                    if let decryptDict = SpeedyJSON.stringToDictionary(decryptStr),
//                        let decryptData = SpeedyJSON.jsonToData(decryptDict) {
//                        finalData = decryptData
//                    }
//                }
//            }
//
//            result.data = finalData
//            if let tempData = finalData {
//                result.json = SpeedyJSON.dataToAnyObject(data: tempData)
//            }
//
//            XHIPManager.shared.update_default_ip(path: path)
//            XHIPManager.shared.retryDic[path] = 1
//            XHIPManager.shared.ip_index_Dic[path] = nil
//
//            if let handler = self.completeHandler {
//                handler(self, result)
//            }
//
//            XHLogDebug("[网络请求调试] - 请求成功 - 返回结果:[\(String(describing: result.json))]")
//
//        case .failure(let error):
//            if (error as NSError).code == NSURLErrorCancelled {
//                // 用户手动取消
//                XHIPManager.shared.retryDic[path] = 1
//                XHIPManager.shared.ip_index_Dic[path] = nil
//
//                XHLogDebug("[网络请求调试] - 请求取消:[\(String(describing: error))]")
//                result.state = .cancel
//                result.error = error
//                if let handler = self.completeHandler {
//                    handler(self, result)
//                }
//            } else {
//                XHLogDebug("[网络请求调试] - 请求失败:[\(String(describing: error))]")
//                result.state = .failure
//                result.error = error
//                self.retryRequest(response: response, error: error, result: result)
//            }
//        }
//    }
//
//    // 重试
//    private func retryRequest(response: AFDataResponse<Any>, error: Error, result: XHNetworkRawResultModel) {
//
//        let currentIpList = XHIPManager.shared.getCurrentUseIpList(path: nil)
//
//        /*
//         let ip_count = currentIpList.count - 1 //不包含域名
//         let total_count = ip_count + 1 //包含域名
//         let judgeCount = path == "ios/config" ? total_count : ip_count
//         */
//
//        if let count = XHIPManager.shared.retryDic[path], currentIpList.count <= count{
//            let des = error.localizedDescription + "\(error)"
//            Report.connect_server_error(path: path, errorInfo: des, needPingBaidu:true)
//            XHIPManager.shared.retryDic[path] = 1
//            XHIPManager.shared.ip_index_Dic[path] = nil
//
//            if let handler = self.completeHandler {
//                handler(self, result)
//            }
//        }else{
//            let des = error.localizedDescription + "\(error)"
//            Report.connect_server_error(path: path, errorInfo: des, needPingBaidu: false)
//            if let count = XHIPManager.shared.retryDic[path]{
//                XHIPManager.shared.retryDic[path] = count + 1
//            }
//            XHIPManager.shared.updateIpIndex(path: path)
//
//            // 开始下一次请求
//            XHLogDebug("[网络请求调试] - 请求失败，开始重试")
//            self.startRequest()
//        }
//    }
//
//    /*
//    // MARK: - 统计此次接口的时间线
//    private func configTimeline(response: AFDataResponse<Any>, result: XHNetworkRawResultModel) {
//
//        // 网络请求的时间线
//        let time = response.timeline
//        //时间超过预期，且请求成功
//        if time.totalDuration > 5.0,response.response?.statusCode == 200{
//            Report.connect_api_timeline_over(serverIP: XHIPManager.shared.getReportHostname(by: self.path), connectTime: time.totalDuration*1000, api: self.path)
//        }
//
//        // 时间段
//        let latency = Int(response.timeline.latency * 1000)
//        let requestDuration = Int(response.timeline.requestDuration * 1000)
//        let serializationDuration = Int(response.timeline.serializationDuration * 1000)
//        let totalDuration = Int(response.timeline.totalDuration * 1000)
//        XHLogInfo("[网络请求调试] - 建立连接[\(latency)ms] - 请求时间[\(requestDuration)ms] - 序列化用时[\(serializationDuration)ms] - 总耗时[\(totalDuration)ms] - url:[\(String(describing: self.currentUrl))]")
//
//        result.latency = latency
//        result.requestDuration = requestDuration
//        result.serializationDuration = serializationDuration
//        result.totalDuration = totalDuration
//
//        // 时间点
//        let startTime = Date.init(timeIntervalSinceReferenceDate: response.timeline.requestStartTime).convertString(format: "yyyy-MM-dd HH:mm:ss.SSS")
//        let initialResponseTime = Date.init(timeIntervalSinceReferenceDate: response.timeline.initialResponseTime).convertString(format: "yyyy-MM-dd HH:mm:ss.SSS")
//        let requestCompletedTime = Date.init(timeIntervalSinceReferenceDate: response.timeline.requestCompletedTime).convertString(format: "yyyy-MM-dd HH:mm:ss.SSS")
//        let serializationCompletedTime = Date.init(timeIntervalSinceReferenceDate: response.timeline.serializationCompletedTime).convertString(format: "yyyy-MM-dd HH:mm:ss.SSS")
//
//        result.startTime = startTime
//        result.initialResponseTime = initialResponseTime
//        result.requestCompletedTime = requestCompletedTime
//        result.serializationCompletedTime = serializationCompletedTime
//
//        XHLogInfo("[网络请求调试] - 请求开始时间[\(startTime)] - 接到数据时间[\(initialResponseTime)] - 序列化完成时间[\(serializationCompletedTime)] - 请求完成时间[\(requestCompletedTime) - url:[\(String(describing: self.currentUrl))]")
//    }
// */
//
//    // MARK: - 取消网络请求
//    func cancleRequset(){
//
//        self.currentRequest?.task?.cancel()
//
//        /*
//         manager.session.getAllTasks { (tasks) in
//         tasks.forEach({ (task) in
//         if let str = task.currentRequest?.url?.absoluteString, str.contains(self.path) {
//         task.cancel()
//         }
//         })
//         }
//
//         longTimeoutManager.session.getAllTasks { (tasks) in
//         tasks.forEach({ (task) in
//         if let str = task.currentRequest?.url?.absoluteString, str.contains(self.path) {
//         task.cancel()
//         }
//         })
//         }
//         */
//    }
//
//    /*
//    // MARK: - 下载
//    func download(_ urlPath: String, destination: URL, progress: ((_ percent: Double) -> ())? = nil, finished: @escaping ((_ error: Error?) -> ())) {
//
//        let aDestination: DownloadRequest.DownloadFileDestination = { _, _ in
//            return (destination, [.removePreviousFile, .createIntermediateDirectories])
//        }
//
//        let utilityQueue = DispatchQueue.main
//        Alamofire.download(urlPath, to: aDestination)
//            .downloadProgress(queue: utilityQueue) { aProgress in
//                if let progress = progress {
//                    progress(aProgress.fractionCompleted)
//                }
//        }
//        .responseData { response in
//            var err: Error?
//            switch response.result {
//            case .success( _):
//                break
//            case .failure(let error):
//                err = error
//            }
//
//            finished(err)
//        }
//    }
// */
//
//    /*
//    // MARK: - 下载
//    func download(_ urlPath: String, destination: URL, progress: ((_ percent: Double) -> ())? = nil, completeHandler: @escaping SpeedyCompleteHandler) {
//
//        let downloadRequest = Alamofire.AF.download(urlPath) { (url, response) -> (destinationURL: URL, options: DownloadRequest.Options) in
//
//            return (destination, .createIntermediateDirectories)
//        }
//
//        downloadRequest.downloadProgress { (progress) in
//            XHLogInfo("[下载调试] - 下载的进度:[\(progress)]")
//        }
//
//        downloadRequest.responseData { (response) in
//            switch response.result {
//            case .success(_):
//                XHLogInfo("[下载调试] - 下载成功")
//                completeHandler(true, nil, "下载成功")
//            case .failure(let error):
//                XHLogInfo("[下载调试] - 下载失败")
//                completeHandler(false, error, "下载失败")
//            }
//        }
//    }
// */
//
//}
