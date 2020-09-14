//
//  DENetManager.swift
//  U4d
//
//  Created by Quinn Von on 2019/11/22.
//  Copyright © 2019 Quinn Von. All rights reserved.
//
///DisableEvaluationNetManager
//MARK: 禁止证书校验的 sessionManager

import Foundation
import Alamofire

/*
class DENetManager{
    // MARK: - 不校验的域名列表
    static var disabledTrustEvaluators: [String: ServerTrustEvaluating] {
        
        var paraments = [String: ServerTrustEvaluating]()
        
        for info in XHIPManager.shared.realAccountIpList{
            paraments[info] = DisabledTrustEvaluator()
        }
        
        for info in XHIPManager.shared.tryAccountIpList{
            paraments[info] = DisabledTrustEvaluator()
        }
        return paraments
    }
    
    public static let manager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        configuration.urlCredentialStorage = nil
        configuration.protocolClasses = nil
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.timeoutIntervalForRequest = XHIPManager.shared.timeOut
        configuration.timeoutIntervalForResource = XHIPManager.shared.timeOut
        configuration.httpMaximumConnectionsPerHost = 50
        
        let serverTrustManager = Alamofire.ServerTrustManager(allHostsMustBeEvaluated: false, evaluators: disabledTrustEvaluators)
        let session = Alamofire.Session(configuration: configuration, serverTrustManager: serverTrustManager)
        
        return session
    }()
    
    public static let longTimeoutManager: Alamofire.Session = {
        let timeOut:TimeInterval = 60
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        configuration.urlCredentialStorage = nil
        configuration.protocolClasses = nil
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.timeoutIntervalForRequest = timeOut
        configuration.timeoutIntervalForResource = timeOut
        configuration.httpMaximumConnectionsPerHost = 50
        
        let serverTrustManager = Alamofire.ServerTrustManager(allHostsMustBeEvaluated: false, evaluators: disabledTrustEvaluators)
        
        let session = Alamofire.Session(configuration: configuration, serverTrustManager: serverTrustManager)
        return session
    }()
}

 */
