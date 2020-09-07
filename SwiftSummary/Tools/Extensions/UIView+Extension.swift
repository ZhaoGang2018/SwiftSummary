//
//  UIView+Extension.swift
//  ThreeDSwing
//
//  Created by 孙凡 on 16/7/24.
//  Copyright © 2016年 Xhey. All rights reserved.
//

import UIKit

extension UIView {
    var x : CGFloat {
        get {
            return frame.origin.x
        }
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.x     = newVal
            frame                 = tmpFrame
        }
    }
    
    // y
    var y : CGFloat {
        get {
            return frame.origin.y
        }
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.y     = newVal
            frame                 = tmpFrame
        }
    }
    
    // height
    var height : CGFloat {
        get {
            return frame.size.height
        }
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.size.height  = newVal
            frame                 = tmpFrame
        }
    }
    
    // width
    var width : CGFloat {
        get {
            return frame.size.width
        }
        set(newVal) {
            
            var tmpFrame : CGRect = frame
            tmpFrame.size.width   = newVal
            frame                 = tmpFrame
        }
    }
    
    // left
    var left : CGFloat {
        get {
            return x
        }
        set(newVal) {
            x = newVal
        }
    }
    
    // right
    var right : CGFloat {
        get {
            return x + width
        }
        set(newVal) {
            x = newVal - width
        }
    }
    
    // top
    var top : CGFloat {
        get {
            return y
        }
        set(newVal) {
            y = newVal
        }
    }
    
    // bottom
    var bottom : CGFloat {
        get {
            return y + height
        }
        set(newVal) {
            y = newVal - height
        }
    }
    
    var centerX : CGFloat {
        get {
            return center.x
        }
        set(newVal) {
            center = CGPoint(x: newVal, y: center.y)
        }
    }
    
    var centerY : CGFloat {
        get {
            return center.y
        }
        set(newVal) {
            center = CGPoint(x: center.x, y: newVal)
        }
    }
    
    var middleX : CGFloat {
        get {
            return width / 2
        }
    }
    
    var middleY : CGFloat {
        get {
            return height / 2
        }
    }
    
    var middlePoint : CGPoint {
        get {
            return CGPoint(x: middleX, y: middleY)
        }
    }
    
    func animateLeave(completion: (()->())? = nil) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.y = self.height
        }, completion: { b in
            completion?()
        })
    }
    
    func animateCome(completion: (()->())? = nil) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.y = 0
        }, completion: { b in
            completion?()
        })
    }
    
    func fadeOut(duration: TimeInterval = 0.1, delay: TimeInterval = 0, completion: (()->())? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
            self.alpha = 0
        }, completion: { b in
            completion?()
        })
    }
    
    func fadeIn(duration: TimeInterval = 0.3, delay: TimeInterval = 0,completion: (()->())? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
            self.alpha = 1
        }, completion: { b in
            completion?()
        })
    }
    
    func showNetError(_ text: String = "当前网络不佳\n请稍后重试"){
        self.showToast(text)
    }
    
    // Toast提示
    func showToast(_ text: String, textStyle: HintTextStyle = .textWithImageTypeOne(image: "hint_cam_general"), animteType: HintAnimateType = .fadeInOutWithMovedAndScaleTypeOne, autoRemove: Bool = true, animateComplete: (()->())? = nil) {
        
        if let _ = self.viewWithTag(10004) {
            return
        }
        
        let animate = animteType.animate()
        
        var textView = textStyle.textView()
        textView.text = text
        textView.sizeToFit()
        
        let toastView = textView.view()
        toastView.tag = 10004
        toastView.center = self.center
        self.addSubview(toastView)
        toastView.layer.add(animate, forKey: "hint")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animate.duration) {
            if autoRemove{
                toastView.removeFromSuperview()
            }
            animateComplete?()
        }
    }
    
    func showSuccessToast(_ text: String, textStyle: HintTextStyle = .textWithImageTypeOne(image: "notification_workgroup_sync"), animteType: HintAnimateType = .fadeInOutWithMovedAndScaleTypeOne, autoRemove: Bool = true, animateComplete: (()->())? = nil) {
        
        self.showToast(text, textStyle: textStyle, animteType: animteType, autoRemove: autoRemove, animateComplete: animateComplete)
    }
    
    func hideToast() {
        if let tempView = self.viewWithTag(10004) {
            tempView.isHidden = true
            tempView.layer.removeAnimation(forKey: "hint")
            tempView.removeFromSuperview()
        }
    }
    //添加自定义圆角边框
    func addCustomCornerLayer(showTopTwoCorner:Bool,radius:CGFloat, colorStr:String = "#D0021B", boderW:CGFloat = 1) {
        
        let path = UIBezierPath()
        path.lineWidth = boderW
        if showTopTwoCorner == true {
            // 左上角
            path.move(to: CGPoint(x:0, y:radius))
            path.addQuadCurve(to: CGPoint(x:radius, y:0), controlPoint: CGPoint(x:radius, y:radius))
            // 右上角
            path.addLine(to: CGPoint(x:width-radius, y:0))
            path.addQuadCurve(to: CGPoint(x:width, y:radius), controlPoint: CGPoint(x:width-radius, y:radius))
            // 右下角
            path.addLine(to: CGPoint(x:width, y:height))
            // 左下角
            path.addLine(to: CGPoint(x:0, y:height))
        } else {
            
            path.move(to: CGPoint(x:0, y:0))
            path.addLine(to: CGPoint(x:width, y:0))
            path.addLine(to: CGPoint(x:width, y:height-radius))
            
            // 右下角
            path.addQuadCurve(to: CGPoint(x:width-radius, y:height), controlPoint:CGPoint(x:width-radius, y:height-radius))
            
            // 左下角
            path.addLine(to: CGPoint(x:radius, y:height))
            path.addQuadCurve(to: CGPoint(x:0, y:height-radius), controlPoint: CGPoint(x:radius, y:height-radius))
        }
        
        path.close()
        
        let boderLayer = CAShapeLayer()
        boderLayer.path = path.cgPath
        boderLayer.fillColor = UIColor.white.cgColor
        boderLayer.lineWidth = boderW
        boderLayer.strokeColor = UIColor.fromHex(colorStr).cgColor
        self.layer.insertSublayer(boderLayer, at: 0)
    }
}
