//
//  XHPreviewTeamVideoCell.swift
//  XCamera
//
//  Created by jing_mac on 2020/9/10.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit

class XHPreviewTeamVideoCell: XHPreviewVideoCell {

    deinit {
        XHLogDebug("deinit - [图片或视频预览调试] - XHPreviewTeamVideoCell")
    }
    
    override func onPan(_ pan: UIPanGestureRecognizer) {
           super.onPan(pan)
           
//           if let browser = photoBrowser as? XHPreviewTeamPhotoViewController {
//               browser.bottomCustomView?.isHidden = browser.pageIndicator?.isHidden ?? false
//               browser.vipGuideView?.isHidden = browser.pageIndicator?.isHidden ?? false
//               browser.userInfoView?.isHidden = browser.pageIndicator?.isHidden ?? false
//           }
       }

}
