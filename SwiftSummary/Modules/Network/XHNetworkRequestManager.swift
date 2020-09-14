////
////  XHNetworkRequestManager.swift
////  XCamera
////
////  Created by 赵刚 on 2020/2/1.
////  Copyright © 2020 xhey. All rights reserved.
////  网络请求的管理类
//
//import UIKit
//import Foundation
//import Alamofire
//import HandyJSON
//
//// 请求方法
//enum MethodType {
//    case get
//    case post
//}
//
//// 网络请求的等级
//enum XHNetworkRequestLevel: Int {
//    case high = 2
//    case normal = 1
//    case low = 0
//}
//
//typealias XHNetworkRequestCompleteHandler = (_ result: XHNetworkRawResultModel) -> ()
//
//class XHNetworkRequestManager: NSObject {
//
//    static let shared = XHNetworkRequestManager()
//
//    // 正在执行的任务
//    var tasks: [String : XHNetworkRequestTask] = [:]
//    let tasksLock = NSRecursiveLock()
//
//    // 等待的队列
//    var waitQueue: [XHNetworkRequestTask] = []
//
//    // 所有的任务,包括正在执行的和等待的
//    var allTasks: [String : XHNetworkRequestTask] = [:]
//
//    // 最大并发数
//    let maxCacheCount = 6
//
//    var isStopDevice: Bool = false
//
//    private override init() {
//        super.init()
//    }
//
//    // MARK: - 外部调用的方法
//    func request<T:Codable>(requestAPI: XHNetworkRequestAPI?,
//                            requestKey: String? = nil,
//                            path: String,
//                            methodType: MethodType,
//                            params : [String : Any]?,
//                            encoding: ParameterEncoding = URLEncoding.default, // JSONEncoding.default 不能修改成这个，有些接口使用的是这个
//                            headers: [String : String]? = nil,
//                            level: XHNetworkRequestLevel = .normal,
//                            finishedHandle: @escaping ((_ error: Error?, _ resultModel: T?, _ httpResult: XHNetworkRawResultModel) -> ())) {
//
//        if self.isStopDevice {
//            return
//        }
//
//        self.requestRawData(requestAPI: requestAPI, requestKey: requestKey, path: path, methodType: methodType, params: params, encoding: encoding, headers: headers, level: level) { (httpResult) in
//
//            if httpResult.state == .success {
//                let model = SpeedyModel.dataToModel(XHNetworkBusinessResult<T>.self, data: httpResult.data)
//                if let resultModel = model, let toast = resultModel.toast_msg, toast.count > 0{
//                    SpeedyApp.topViewController?.showNetError(toast)
//                }
//
//                if model?.code == 200{
//                    finishedHandle(nil, model?.data, httpResult)
//                } else {
//                    XHLogDebug("[网络请求调试] - HTTP请求成功，但是code不等于200，按失败处理，code:[\((model?.code ?? -1))]")
//                    let error = NSError(domain: model?.msg ?? "", code: (model?.code ?? -1), userInfo: ["message":model?.msg ?? ""])
//                    finishedHandle(error, nil, httpResult)
//                }
//            } else {
//                finishedHandle(httpResult.error, nil, httpResult)
//            }
//        }
//    }
//
//    // MARK: -HandyJson外部调用的方法
//    func handyjsonRequest<T:HandyJSON>(requestAPI: XHNetworkRequestAPI?,
//                            requestKey: String? = nil,
//                            path: String,
//                            methodType: MethodType,
//                            params : [String : Any]?,
//                            encoding: ParameterEncoding = URLEncoding.default, // JSONEncoding.default 不能修改成这个，有些接口使用的是这个
//                            headers: [String : String]? = nil,
//                            level: XHNetworkRequestLevel = .normal,
//                            finishedHandle: @escaping ((_ error: Error?, _ resultModel: T?, _ httpResult: XHNetworkRawResultModel) -> ())) {
//
//        if self.isStopDevice {
//            return
//        }
//
//        self.requestRawData(requestAPI: requestAPI, requestKey: requestKey, path: path, methodType: methodType, params: params, encoding: encoding, headers: headers, level: level) { (httpResult) in
//
//            if httpResult.state == .success {
//                let model: XHNetworkBusinessHandyJsonResult<T>? = XHNetworkBusinessHandyJsonResult.deserialize(from: httpResult.jsonString)
//                if let resultModel = model, let toast = resultModel.toast_msg, toast.count > 0{
//                    SpeedyApp.topViewController?.showNetError(toast)
//                }
//
//                if model?.code == 200 {
//                    finishedHandle(nil, model?.data, httpResult)
//                } else {
//                     XHLogDebug("[网络请求调试] - handyjsonRequest - HTTP请求成功，但是code不等于200，按失败处理，code:[\((model?.code ?? -1))]")
//                    let error = NSError(domain: model?.msg ?? "", code: (model?.code ?? -1), userInfo: ["message":model?.msg ?? ""])
//                    finishedHandle(error, nil, httpResult)
//                }
//            } else {
//                finishedHandle(httpResult.error, nil, httpResult)
//            }
//        }
//    }
//
//    private func requestRawData(requestAPI: XHNetworkRequestAPI?,
//                                requestKey: String? = nil,
//                                path: String,
//                                methodType: MethodType,
//                                params : [String : Any]?,
//                                encoding: ParameterEncoding = URLEncoding.default,
//                                headers: [String : String]? = nil,
//                                level: XHNetworkRequestLevel = .normal,
//                                finishedHandle: @escaping XHNetworkRequestCompleteHandler) {
//
//        self.tasksLock.lock()
//
//        // 用于标识接口的唯一性
//        var currentRequestKey: String = requestKey ?? ""
//        if currentRequestKey.count == 0 {
//            currentRequestKey = "\(path)"
//            if let tempParams = params {
//                let paramsStr = SpeedyJSON.dictionaryToJsonString(tempParams)
//                currentRequestKey = "\(path)-\(paramsStr)"
//            }
//            currentRequestKey = currentRequestKey.md5()
//        }
//
//        if let tempTask = self.allTasks[currentRequestKey], tempTask.requestAPI?.caller?.isEqual(requestAPI?.caller) == true {
//
//            XHLogDebug("[网络请求调试] - 该任务已经存在（执行或排队）,不再创建任务 - 正在执行的数量[\(self.tasks.count)] - 排队的数量[\(self.waitQueue.count)] - path:[\(path)]")
//            self.tasksLock.unlock()
//            return
//        }
//
//        if let executingTask = self.tasks[currentRequestKey] {
//            XHLogDebug("[网络请求调试] - 该任务正在执行 - 正在执行的数量[\(self.tasks.count)] - 排队的数量[\(self.waitQueue.count)] - path:[\(path)]")
//            executingTask.completeHandler = {[weak self] (currentTask, result) in
//                if let weakSelf = self {
//                    if let handler = currentTask.requestHandler {
//                        handler(result)
//                    }
//                    weakSelf.removeTask(key: currentTask.requestKey)
//                }
//            }
//        } else {
//            let singleTask = XHNetworkRequestTask()
//
//            singleTask.requestKey = currentRequestKey
//            singleTask.level = level
//            singleTask.requestAPI = requestAPI
//
//            singleTask.path = path
//            singleTask.methodType = methodType
//            singleTask.params = params
//            singleTask.encoding = encoding
//            singleTask.headers = headers
//            singleTask.requestHandler = finishedHandle
//
//            // 添加到所有的任务列表
//            self.allTasks[singleTask.requestKey] = singleTask
//
//            if self.tasks.count >= self.maxCacheCount {
//                var index = self.waitQueue.count
//                for i in 0..<self.waitQueue.count {
//                    let waitTask = self.waitQueue[i]
//                    if waitTask.level.rawValue < singleTask.level.rawValue {
//                        index = i
//                        break
//                    }
//                }
//                self.waitQueue.insert(singleTask, at: index)
//                XHLogDebug("[网络请求调试] - 任务需要排队 - 插入的index[\(index)] - path[\(singleTask.path)]")
//            } else {
//                self.startRequest(task: singleTask)
//            }
//            XHLogDebug("[网络请求调试] - 创建新的任务 - 正在执行的数量[\(self.tasks.count)] - 排队的数量[\(self.waitQueue.count)]")
//        }
//
//        self.tasksLock.unlock()
//    }
//
//    private func startRequest(task: XHNetworkRequestTask) {
//        self.tasks[task.requestKey] = task
//        task.startRequest()
//        task.completeHandler = {[weak self] (currentTask, result) in
//            if let weakSelf = self {
//                if let handler = currentTask.requestHandler {
//                    handler(result)
//                }
//                weakSelf.removeTask(key: currentTask.requestKey)
//            }
//        }
//
//        XHLogDebug("[网络请求调试] - 开始新的任务 - 正在执行的数量[\(self.tasks.count)] - 排队的数量[\(self.waitQueue.count)]")
//    }
//
//    // MARK: - 移除任务
//    private func removeTask(key: String) {
//
//        self.tasksLock.lock()
//
//        self.allTasks.removeValue(forKey: key)
//        self.tasks.removeValue(forKey: key)
//        if self.waitQueue.count > 0 {
//            self.startRequest(task: self.waitQueue[0])
//            self.waitQueue.removeFirst()
//        }
//
//        XHLogDebug("[网络请求调试] - 正在执行的数量[\(self.tasks.count)] - 排队的数量[\(self.waitQueue.count)]")
//        self.tasksLock.unlock()
//    }
//}
//
//
//// MARK: - 取消网络请求
//extension XHNetworkRequestManager {
//
//    // MARK: - 取消所有的任务
//    func cancleAllTasks(){
//        for (_, currentTask) in self.allTasks {
//            self.cancleTask(path: currentTask.path)
//        }
//    }
//
//    func cancelTasks(caller: AnyObject?, callKey: String?) {
//
//        if let callKey = callKey, callKey.count > 0 {
//            for (_, currentTask) in self.allTasks {
//                if currentTask.requestAPI?.callerKey == callKey {
//                    self.cancleTask(path: currentTask.path)
//                    XHLogDebug("[网络请求调试] - 通过key取消，path[\(currentTask.path)]")
//                }
//            }
//        } else {
//            if let caller = caller {
//                for (_, currentTask) in self.allTasks {
//                    if currentTask.requestAPI?.caller?.isEqual(caller) == true {
//                        self.cancleTask(path: currentTask.path)
//                        XHLogDebug("[网络请求调试] - 通过caller取消，path[\(currentTask.path)]")
//                    }
//                }
//            }
//        }
//    }
//
//    // MARK: - 取消多个任务
//    func cancleTasks(paths: [String]) {
//        for tempPath in paths {
//            self.cancleTask(path: tempPath)
//        }
//    }
//
//    // MARK: - 取消单条任务
//    func cancleTask(path: String) {
//
//        self.tasksLock.lock()
//
//        for (_, currentTask) in self.tasks {
//            if path == currentTask.path {
//                currentTask.cancleRequset()
//            }
//        }
//
//        let waitTask = self.getTaskFromWaitQueue(path)
//        if waitTask.0 < self.waitQueue.count, let currentTask = waitTask.1 {
//            let result = XHNetworkRawResultModel()
//            result.state = .cancel
//            result.error = NSError(domain: "用户手动取消请求", code: NSURLErrorCancelled, userInfo: nil)
//
//            if let handler = currentTask.requestHandler {
//                handler(result)
//            }
//
//            self.waitQueue.remove(at: waitTask.0)
//        }
//
//        for (key, currentTask) in self.allTasks {
//            if path == currentTask.path {
//                self.allTasks.removeValue(forKey: key)
//                break
//            }
//        }
//
//        XHLogDebug("[网络请求调试] - 取消请求任务path[\(path)]")
//        self.tasksLock.unlock()
//    }
//
//    /*
//    func cancleAllTasks(){
//
//        DENetManager.manager.session.getAllTasks { (tasks) in
//            tasks.forEach({ (task) in
//                task.cancel()
//            })
//        }
//
//        DENetManager.longTimeoutManager.session.getAllTasks { (tasks) in
//            tasks.forEach({ (task) in
//                task.cancel()
//            })
//        }
//    }
// */
//
//    private func getTaskFromWaitQueue(_ path: String) -> (Int, XHNetworkRequestTask?) {
//
//        var result: (Int, XHNetworkRequestTask?) = (-1, nil)
//
//        for index in 0..<self.waitQueue.count {
//            let tempTask = self.waitQueue[index]
//            if tempTask.path == path {
//                result = (index, tempTask)
//                break
//            }
//        }
//
//        return result
//    }
//}
//
//// MARK: - 请求百度，用于验证网络权限
//extension XHNetworkRequestManager {
//    //  请求百度，用于验证网络权限
//    class func requestBaidu(retryCount: Int = 5, retryTimeInterval: Double = 2, complete: ((_ error: Error?)->())? = nil) {
//
//        let url = URL(string: "https://www.baidu.com")!
//
//        AF.request(url).response { (response) in
//
//            let statusCode: Int
//            if let tempError = response.error {
//                statusCode = (tempError as NSError).code
//            } else {
//                statusCode = response.response?.statusCode ?? 0
//            }
//            if statusCode == -1009 {
//                let retry = retryCount-1
//                if retry <= 0 {
//                    let error = NSError(domain: "request error", code: statusCode, userInfo: nil)
//                    complete?(error)
//                } else {
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + retryTimeInterval, execute: {
//                        self.requestBaidu(retryCount: retry, retryTimeInterval: retryTimeInterval, complete: complete)
//                    })
//                }
//            } else {
//                complete?(nil)
//            }
//        }
//    }
//}
//
//
//// MARK: - 下载
//extension XHNetworkRequestManager {
//
//    func download(_ urlPath: String, destination: URL, progressHandler: ((_ percent: Double) -> ())? = nil, completeHandler: @escaping SpeedyCompleteHandler) {
//
//        guard let urlStr = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let currentUrl = URL(string: urlStr)  else {
//            XHLogInfo("[下载调试] - 下载失败, addingPercentEncoding失败")
//            completeHandler(false, nil, "下载失败")
//            return
//        }
//
//        let downloadRequest = Alamofire.AF.download(currentUrl) { (url, response) -> (destinationURL: URL, options: DownloadRequest.Options) in
//
//            return (destination, .createIntermediateDirectories)
//        }
//
//        downloadRequest.downloadProgress { (progress) in
//            XHLogInfo("[下载调试] - 下载的进度:[\(progress.fractionCompleted)]")
//            progressHandler?(progress.fractionCompleted)
//        }
//
//        downloadRequest.responseData { (response) in
//            switch response.result {
//            case .success(_):
//                XHLogInfo("[下载调试] - 下载成功")
//                completeHandler(true, nil, "下载成功")
//            case .failure(let error):
//                XHLogInfo("[下载调试] - 下载失败，error:[\(error)]")
//                completeHandler(false, error, "下载失败")
//            }
//        }
//    }
//}
