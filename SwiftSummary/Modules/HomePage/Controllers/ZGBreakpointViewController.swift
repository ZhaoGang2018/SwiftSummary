//
//  ZGBreakpointViewController.swift
//  SwiftSummary
//
//  Created by jing_mac on 2020/9/6.
//  Copyright © 2020 zhaogang. All rights reserved.
//

import UIKit
import Alamofire

class ZGBreakpointViewController: XHBaseViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    
    var request: DownloadRequest?
    var tempData: Data?
    let filePath = SpeedySandbox.shared.documentDirectory + "/" + "123456"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView.layerCornerRadius = 20.0
    }
    
    
    @IBAction func startAction(_ sender: Any) {
        
        let fileUrl = URL(fileURLWithPath: filePath)
        
        let downloadRequest = Alamofire.AF.download("https://dldir1.qq.com/qqfile/QQIntl/QQi_PC/QQIntl2.11.exe") { (url, response) -> (destinationURL: URL, options: DownloadRequest.Options) in
            
            return (fileUrl, .createIntermediateDirectories)
        }
        
        downloadRequest.downloadProgress { (progress) in
            XHLogInfo("[下载调试] - 下载的进度:[\(progress.fractionCompleted)]")
            self.progressView.progress = Float(progress.fractionCompleted)
        }
        
        downloadRequest.responseData { (response) in
            switch response.result {
            case .success(_):
                XHLogInfo("[下载调试] - 下载成功")
                
            case .failure(let error):
                XHLogInfo("[下载调试] - 下载失败，error:[\(error)]")
                
            }
        }
        
        self.request = downloadRequest
    }
    
    
    @IBAction func stopAction(_ sender: Any) {
        
        guard let currentRequest = self.request else {
            return
        }
        
        if currentRequest.isSuspended {
            currentRequest.resume()
        } else {
            currentRequest.suspend()
            self.tempData = currentRequest.resumeData
            FileManager.default.createFile(atPath: self.filePath, contents: self.tempData, attributes: nil)
        }
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        
    }
    
}
