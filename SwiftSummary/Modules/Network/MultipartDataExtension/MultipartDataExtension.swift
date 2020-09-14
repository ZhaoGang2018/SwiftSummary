//
//  MultipartDataExtension.swift
//  XCamera
//
//  Created by Quinn Von on 2019/5/20.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit
import Alamofire

/*
extension MultipartFormData{
    private func xheyContentHeaders(withName name: String, fileName: String? = nil, mimeType: String? = nil) -> [String: String] {
        var disposition = "form-data; name=\"\(name)\""
        if let fileName = fileName { disposition += "; filename=\"\(fileName)\"" }
        
        var headers = ["Content-Disposition": disposition]
        if let mimeType = mimeType { headers["Content-Type"] = mimeType }
        
        return headers
    }
    public func xheyAppend(_ data: Data, withName name: String, mimeType: String) {
        var headers = xheyContentHeaders(withName: name, mimeType: mimeType)
        let stream = InputStream(data: data)
        let length = UInt64(data.count)
        headers["Content-Length"] = "\(length)"
        append(stream, withLength: length, headers: headers)
    }
    public func xheyAppend(_ data: Data, withName name: String, fileName: String, mimeType: String) {
        var headers = xheyContentHeaders(withName: name, fileName: fileName, mimeType: mimeType)
        let stream = InputStream(data: data)
        let length = UInt64(data.count)
        headers["Content-Length"] = "\(length)"
        
        append(stream, withLength: length, headers: headers)
    }
}
 */


extension MultipartFormData{
    private func xheyContentHeaders(withName name: String, fileName: String? = nil, mimeType: String? = nil) -> Alamofire.HTTPHeaders {
        var disposition = "form-data; name=\"\(name)\""
        if let fileName = fileName { disposition += "; filename=\"\(fileName)\"" }
        
        var headers: [Alamofire.HTTPHeader] = [Alamofire.HTTPHeader(name: "Content-Disposition", value: disposition)]
        if let mimeType = mimeType {
            headers.append(Alamofire.HTTPHeader(name: "Content-Type", value: mimeType))
        }
        return Alamofire.HTTPHeaders(headers)
    }
    
    public func xheyAppend(_ data: Data, withName name: String, mimeType: String) {
        var headers = xheyContentHeaders(withName: name, mimeType: mimeType)
        let stream = InputStream(data: data)
        let length = UInt64(data.count)
        
        headers.add(name: "Content-Length", value: "\(length)")
        append(stream, withLength: length, headers: headers)
    }
    
    public func xheyAppend(_ data: Data, withName name: String, fileName: String, mimeType: String) {
        var headers = xheyContentHeaders(withName: name, fileName: fileName, mimeType: mimeType)
        let stream = InputStream(data: data)
        let length = UInt64(data.count)
        headers.add(name: "Content-Length", value: "\(length)")
        append(stream, withLength: length, headers: headers)
    }
}
