//
//  XHLinkageBaseTableView.swift
//  XCamera
//
//  Created by 赵刚 on 2020/6/9.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit

class XHLinkageBaseTableView: UITableView, UIGestureRecognizerDelegate {

    // YES:同时识别多个手势; NO:只能识别一个手势
    var gesturesRecognizeWithOthers: Bool = true
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.gesturesRecognizeWithOthers = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return self.gesturesRecognizeWithOthers
    }
}
