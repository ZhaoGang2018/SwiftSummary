//
//  SpeedyDisableMultipleClickButton.swift
//  XCamera
//
//  Created by 管理员 Cc on 2020/7/24.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit

public class SpeedyDisableMultipleClickButton: UIButton {

    public var disableMultipleClickTimeInterval:TimeInterval = 1
    private var isEnabledClick: Bool = true
    
    public override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        
        isUserInteractionEnabled = false
        super.sendAction(action, to: target, for: event)
        
     DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + disableMultipleClickTimeInterval) {[weak self] in
            self?.isUserInteractionEnabled = true
        }
    }
    
    public override func sendActions(for controlEvents: UIControl.Event) {
        
        isUserInteractionEnabled = false
        super.sendActions(for: controlEvents)
       
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + disableMultipleClickTimeInterval) {[weak self] in
            self?.isUserInteractionEnabled = true
        }
    }
    
}

