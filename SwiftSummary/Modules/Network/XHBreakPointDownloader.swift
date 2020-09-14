//
//  XHBreakPointDownloader.swift
//  XCamera
//
//  Created by jing_mac on 2020/9/14.
//  Copyright © 2020 xhey. All rights reserved.
//  断点续传的下载器:
/*
 存在如下问题：
 1、有时候下载完MP4后，再点击下载，还会从60%继续下载，导致下载的文件越来越大；
 2、存在内存泄漏，deinit方法不被调用；
 */


import UIKit

/*
 typealias XHDownloadProgressHandler = (_ progress: Double, _ receiveByte: Int64, _ allByte: Int64) -> Void
 typealias XHDownloadCompleteHandler = (_ isSuccess: Bool, _ error: Error?, _ errorMsg: String) -> Void
 typealias XHDownloadCallCancelHandler = (_ sourceUrlStr: String) -> Void
 */

class XHBreakPointDownloader: NSObject {
    
    static var tasks: [String: XHDownloadTask] = [:]
    
    static func download(_ sourceUrlStr: String, destinationPath: String, progress:@escaping XHDownloadProgressHandler, complete: @escaping XHDownloadCompleteHandler) -> XHDownloadTask {
        
        let taskKey = sourceUrlStr.md5()
        if let task = self.tasks[taskKey] {
            return task
        } else {
            let task = XHDownloadTask().download(sourceUrlStr, destinationPath: destinationPath, progress: progress, complete: complete) { (str) in
                
                self.tasks.removeValue(forKey: str.md5())
            }
            
            self.tasks[taskKey] = task
            return task
        }
    }
    
    /// 取消
    static func cancel(urlStr:String) {
        
        if let task = self.tasks[urlStr.md5()] {
            task.cancel()
        }
    }
    
    /// 暂停
    static func pause(urlStr: String) {
        
        if let task = self.tasks[urlStr.md5()] {
            task.pause()
        }
    }
}

// MARK: - XHDownloadTask
class XHDownloadTask: NSObject {
    
    var sourceUrl: URL?
    var sourceUrlStr: String = ""
    var destinationPath: String?
    var task: URLSessionDataTask?
    var startFileSize: UInt64 = 0
    
    var progressHandler: XHDownloadProgressHandler?
    var completeHandler: XHDownloadCompleteHandler?
    var callCancel: XHDownloadCallCancelHandler?
    
    deinit {
        XHLogDebug("deinit - XHDownloadTask")
    }
    
    func download(_ sourceUrlStr: String, destinationPath: String, progress: XHDownloadProgressHandler?, complete: XHDownloadCompleteHandler?, callCancel: XHDownloadCallCancelHandler?) -> XHDownloadTask {
        
        guard let urlStr = sourceUrlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let currentUrl = URL(string: urlStr) else {
            
            XHLogInfo("[下载调试] - 下载失败, addingPercentEncoding失败")
            callCancel?(sourceUrlStr)
            completeHandler?(false, nil, "下载失败")
            return self
        }
        
        let urlRequest = NSMutableURLRequest(url: currentUrl)
        
        startFileSize = fileSize(filePath: destinationPath)
        if startFileSize > 0 {
            // 添加本地文件大小到header,告诉服务器我们下载到哪里了
            let requestRange:String = String(format: "bytes=%llu-", startFileSize)
            urlRequest.addValue(requestRange, forHTTPHeaderField: "Range")
        }
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.current)
        let task: URLSessionDataTask = session.dataTask(with: urlRequest as URLRequest)
        
        self.sourceUrl = currentUrl
        self.sourceUrlStr = sourceUrlStr
        self.destinationPath = destinationPath
        
        self.progressHandler = progress
        self.completeHandler = complete
        self.callCancel = callCancel
        
        self.task = task
        self.task?.resume()
        return self
    }
    
    /// 取消下载
    func cancel() -> Void{
        self.task?.cancel()
        self.callCancel?(self.sourceUrlStr)
        XHLogDebug("[下载调试] - 取消下载")
    }
    
    /// 暂停下载即为取消下载
    func pause() -> Void {
        self.task?.cancel()
        self.callCancel?(self.sourceUrlStr)
        XHLogDebug("[下载调试] - 暂停下载")
    }
}

extension XHDownloadTask: URLSessionDataDelegate {
    
    /// 出现错误,取消请求,通知失败
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        
        self.completeHandler?(false, error, "下载失败")
        self.callCancel?(self.sourceUrlStr)
        XHLogDebug("[下载调试] - 下载失败，error:[\(String(describing: error))]")
    }
    
    /// 下载完成
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if error == nil {
            self.completeHandler?(true, error, "下载成功")
            XHLogDebug("[下载调试] - 下载成功")
        } else {
            self.completeHandler?(false, error, "下载失败")
            XHLogDebug("[下载调试] - 下载失败，error:[\(String(describing: error))]")
        }
        self.callCancel?(self.sourceUrlStr)
    }
    
    /// 接收到数据,将数据存储
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        guard let response = dataTask.response as? HTTPURLResponse else {
            return
        }
        
        // 无断点续传时候,一直走200; 断点续传后,一直走206
        if response.statusCode == 200 || response.statusCode == 206 {
            
            let progress: Double = Double(dataTask.countOfBytesReceived + Int64(startFileSize)) / Double(dataTask.countOfBytesExpectedToReceive + Int64(startFileSize))
            let receiveByte = dataTask.countOfBytesReceived + Int64(startFileSize)
            let allByte = dataTask.countOfBytesExpectedToReceive+Int64.init(startFileSize)
            
            XHLogDebug("[下载调试] - 接收到数据, statusCode:[\(response.statusCode)] - progress:[\(progress)] - receiveByte:[\(receiveByte) - allByte:[\(allByte)]]")
            self.progressHandler?(progress, receiveByte, allByte)
            self.save(data: data)
        }
    }
    
    /// 存储数据,将offset标到文件末尾,在末尾写入数据,最后关闭文件
    private func save(data: Data) -> () {
        do {
            let fileUrl = URL(fileURLWithPath: self.destinationPath ?? "")
            let fileHandle = try FileHandle(forUpdating: fileUrl)
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
            fileHandle.closeFile()
            XHLogDebug("[下载调试] - 写入数据成功")
        } catch {
            XHLogDebug("[下载调试] - 写入数据错误，error:[\(error)]")
        }
    }
    
    /*获取对应文件的大小*/
    private func fileSize(filePath: String) -> UInt64 {
        
        var downloadedBytes: UInt64 = 0
        
        if FileManager.default.fileExists(atPath: filePath) {
            do {
                let fileDict: NSDictionary = try FileManager.default.attributesOfItem(atPath: filePath) as NSDictionary
                downloadedBytes = fileDict.fileSize();
            } catch {
                XHLogDebug("[下载调试] - 获取对应文件的大小失败，error:[\(error)]")
            }
        } else {
            let path = filePath as NSString
            if FileManager.default.fileExists(atPath: path.deletingLastPathComponent, isDirectory:nil) {
                
            } else  {
                try? FileManager.default.createDirectory(atPath: path.deletingLastPathComponent, withIntermediateDirectories: true, attributes: nil)
            }
            /*文件不存在,创建文件*/
            if !FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil) {
                XHLogDebug("[下载调试] - 文件不存在,创建文件失败")
            }
        }
        return downloadedBytes;
    }
}
