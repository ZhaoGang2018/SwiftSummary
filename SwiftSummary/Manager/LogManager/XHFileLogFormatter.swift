//
//  XHFileLogFormatter.swift
//  XCamera
//
//  Created by jing_mac on 2019/10/18.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit
import CocoaLumberjack

class XHFileLogFormatter: DDAbstractLogger, DDLogFormatter {
    func format(message logMessage: DDLogMessage) -> String? {
        
        var loglevelStr = ""
        switch logMessage.flag {
        case .error:
            loglevelStr = "[ERROR]-->"
        case .warning:
            loglevelStr = "[WARN]-->"
        case .info:
            loglevelStr = "[INFO]-->"
        case .debug:
            loglevelStr = "[DEBUG]-->"
        case .verbose:
            loglevelStr = "[VBOSE]-->"
        default:
            loglevelStr = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss Z"
        
        let dateNow = logMessage.timestamp
        let currentTimeStr = dateFormatter.string(from: dateNow)
        
        let resultStr = "\(loglevelStr)time:[\(currentTimeStr)]__fileName:[\(logMessage.fileName)]__line:[\(logMessage.line)]__message:[\(logMessage.message)]"
        return resultStr
    }
}
