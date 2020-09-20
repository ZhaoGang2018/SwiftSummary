//
//  XHPreviewImageOrVideoModel.swift
//  XCamera
//
//  Created by jing_mac on 2020/9/9.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit


enum XHPreviewImageOrVideoType: String {
    case image = "image"
    case video = "video"
}

class XHPreviewImageOrVideoModel: NSObject {
    
    // 预览的是图片还是视频
    var type: XHPreviewImageOrVideoType = .image
    
    var image: UIImage?
    var imageUrlStr: String?
    
    var videoPath: String?
    var videoUrlStr: String?
    
    var placeholderUrlStr: String?
    var placeholderImage: UIImage?
    
    convenience init(type: XHPreviewImageOrVideoType, image: UIImage? = nil, imageUrlStr: String? = nil, videoPath: String? = nil, videoUrlStr: String? = nil, placeholderUrlStr: String? = nil, placeholderImage: UIImage? = nil) {
        
        self.init()
        self.type = type
        self.image = image
        self.imageUrlStr = imageUrlStr
        self.videoPath = videoPath
        self.videoUrlStr = videoUrlStr
        self.placeholderUrlStr = placeholderUrlStr
        self.placeholderImage = placeholderImage
    }
}

