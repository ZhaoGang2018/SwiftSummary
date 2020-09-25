//
//  XHPreviewTeamPhotoCell.swift
//  XCamera
//
//  Created by jing_mac on 2020/9/7.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit

class XHPreviewTeamPhotoCell: XHPreviewImageCell {
    
    deinit {
        XHLogDebug("deinit - [图片或视频预览调试] - XHPreviewTeamPhotoCell")
    }
    
    override func onPan(_ pan: UIPanGestureRecognizer) {
        super.onPan(pan)
        
//        if let browser = photoBrowser as? XHPreviewTeamPhotoViewController {
//            browser.bottomCustomView?.isHidden = browser.pageIndicator?.isHidden ?? false
//            browser.vipGuideView?.isHidden = browser.pageIndicator?.isHidden ?? false
//            browser.userInfoView?.isHidden = browser.pageIndicator?.isHidden ?? false
//        }
    }
}
