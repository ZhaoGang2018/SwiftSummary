//
//  XHAlamofireDownloadTask.swift
//  XCamera
//
//  Created by jing_mac on 2020/9/14.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit
import Alamofire

typealias XHDownloadProgressHandler = (_ progress: Double, _ receiveByte: Int64, _ allByte: Int64) -> Void
typealias XHDownloadCompleteHandler = (_ isSuccess: Bool, _ error: Error?, _ errorMsg: String) -> Void
typealias XHDownloadCallCancelHandler = (_ sourceUrlStr: String) -> Void

class XHAlamofireDownloader: NSObject {
    
    static var tasks: [String: XHAlamofireDownloadTask] = [:]
    
    static func download(_ sourceUrlStr: String, destinationPath: String, progress:@escaping XHDownloadProgressHandler, complete: @escaping XHDownloadCompleteHandler) -> XHAlamofireDownloadTask {
        
        let taskKey = sourceUrlStr.md5()
        
        if let task = self.tasks[taskKey] {
            return task
        } else {
            let task = XHAlamofireDownloadTask().download(sourceUrlStr, destinationPath: destinationPath, progress: progress, complete: complete) { (str) in
                
                self.tasks.removeValue(forKey: str.md5())
            }
            self.tasks[taskKey] = task
            return task
        }
    }
    
    /// 取消
    static func cancel(urlStr: String) {
        if let task = self.tasks[urlStr.md5()] {
            task.cancel()
        }
    }
}

// MARK: - XHAlamofireDownloadTask
class XHAlamofireDownloadTask: NSObject {
    
    var downloadRequest: DownloadRequest?
    var tmpData: Data?
    
    var sourceUrlStr: String = ""
    var destinationPath: String = ""
    
    var progressHandler: XHDownloadProgressHandler?
    var completeHandler: XHDownloadCompleteHandler?
    var callCancel: XHDownloadCallCancelHandler?
    
    deinit {
        XHLogDebug("deinit - XHAlamofireDownloadTask")
    }
    
    // MARK: - 下载
    func download(_ sourceUrlStr: String, destinationPath: String, progress: XHDownloadProgressHandler?, complete: XHDownloadCompleteHandler?, callCancel: XHDownloadCallCancelHandler?) -> XHAlamofireDownloadTask {
        
        self.sourceUrlStr = sourceUrlStr
        self.destinationPath = destinationPath
        self.progressHandler = progress
        self.completeHandler = complete
        self.callCancel = callCancel
        
        guard let urlStr = sourceUrlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let currentUrl = URL(string: urlStr)  else {
                XHLogInfo("[下载调试] - 下载失败, addingPercentEncoding失败")
                self.completeHandler?(false, nil, "下载失败")
                self.callCancel?(self.sourceUrlStr)
                return self
        }
        
        // 目标的url
        let destinationUrl = URL(fileURLWithPath: destinationPath)
        if let tempData = FileManager.default.contents(atPath: destinationPath) {
            // 断点续传
            downloadRequest = Alamofire.AF.download(resumingWith: tempData) { (url, response) -> (destinationURL: URL, options: DownloadRequest.Options) in
                
                return (destinationUrl, [.createIntermediateDirectories, .removePreviousFile])
            }
        } else {
            // 重新下载
            downloadRequest = Alamofire.AF.download(currentUrl) { (url, response) -> (destinationURL: URL, options: DownloadRequest.Options) in
                
                return (destinationUrl, [.createIntermediateDirectories, .removePreviousFile])
            }
        }
        
        downloadRequest?.downloadProgress { [weak self] (progress) in
            XHLogInfo("[下载调试] - 下载的进度:[\(progress.fractionCompleted)]")
            self?.progressHandler?(progress.fractionCompleted, progress.completedUnitCount, progress.totalUnitCount)
        }
        
        downloadRequest?.responseData {[weak self] (response) in
            switch response.result {
            case .success(_):
                XHLogInfo("[下载调试] - 下载成功")
                self?.completeHandler?(true, nil, "下载成功")
            case .failure(let error):
                XHLogInfo("[下载调试] - 下载失败，error:[\(error)]")
                if let tempData = response.resumeData {
                    FileManager.default.createFile(atPath: destinationPath, contents: tempData, attributes: nil)
                }
                self?.completeHandler?(false, error, "下载失败")
            }
            self?.callCancel?(self?.sourceUrlStr ?? "")
        }
        return self
    }
    
    // 取消任务
    func cancel() {
        self.downloadRequest?.cancel(producingResumeData: true)
        self.callCancel?(self.sourceUrlStr)
    }
}
