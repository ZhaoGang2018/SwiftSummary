//
//  Hint.swift
//  XCamera
//
//  Created by Swaying on 2017/12/13.
//  Copyright © 2017年 xhey. All rights reserved.
//

import UIKit

class Hint {
    
    /*
    class func show(text: String,
                    center: CGPoint,
                    textStyle: HintTextStyle = .white,
                    animteType: HintAnimateType = .fadeInOutTypeOne,
                    animateComplete: (()->())? = nil) {
        
        var textView = textStyle.textView()
        textView.text = text
        textView.sizeToFit()
        
        show(view: textView.view(),
             center: center,
             animate: animteType.animate(),
             autoRemove:true,
             animateComplete: animateComplete)
    }
    
    class func show(view: UIView, center: CGPoint, animate: CAAnimation, autoRemove:Bool, animateComplete:(()->())? = nil) {
        guard let vc = CurrentViewController() else {
            return
        }
        view.center = center
        vc.view.addSubview(view)
        view.layer.add(animate, forKey: "hint")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animate.duration) {
            if autoRemove{
                view.removeFromSuperview()
            }
            animateComplete?()
        }
    }
 */
    
}






