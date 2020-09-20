//
//  UIView+SpeedyFrameLayout.swift
//  XCamera
//
//  Created by jing_mac on 2019/10/30.
//  Copyright © 2019 xhey. All rights reserved.
//

import UIKit

// 线的位置
enum LinePosition: Int {
    case top = 0
    case bottom = 1
    case center = 2
}

// MARK: UIView的构造和函数
extension UIView {
    
    convenience init(backgroundColor: UIColor = UIColor.white, cornerRadius: CGFloat? = nil) {
        self.init()
        self.backgroundColor = backgroundColor
        
        if let radius = cornerRadius {
            self.layerCornerRadius = radius
        }
    }
    
    /// 添加阴影
    ///
    /// - Parameters:
    ///   - color: shadow color (default is #137992).
    ///   - radius: shadow radius (default is 3).
    ///   - offset: shadow offset (default is .zero).
    ///   - opacity: shadow opacity (default is 0.5).
    public func addShadow(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    /// 添加颜色渐变
    ///
    /// - Parameters:
    ///   - colors: 颜色数组
    ///   - layerframe: 坐标
    ///   - startPoint: 开始值
    ///   - endPoint: 结束值
    func addGradualLayerWith(colors:Array<CGColor>,layerframe:CGRect,startPoint:CGPoint,endPoint:CGPoint) -> Void
    {
        let _gradientLayer = CAGradientLayer()
        _gradientLayer.startPoint = startPoint
        _gradientLayer.endPoint = endPoint
        _gradientLayer.frame = layerframe
        _gradientLayer.colors = colors
        self.layer.insertSublayer(_gradientLayer, at: 0)

    }
    // MARK: - 添加细线 ply线高
    func addLine(position : LinePosition, color : UIColor, ply : CGFloat, leftPadding : CGFloat, rightPadding : CGFloat) -> UIView {
        
        let line = UIView.init()
        line.backgroundColor = color;
        self.addSubview(line)
        
        line.snp.makeConstraints { (make) in
            
            make.left.equalTo(leftPadding)
            make.right.equalTo(rightPadding)
            make.height.equalTo(ply)
            
            switch position {
            case .top:
                make.top.equalToSuperview()
            case .bottom:
                make.bottom.equalToSuperview()
            case .center:
                make.centerY.equalToSuperview()
            }
        }
        return line
    }
    
    // MARK: - 添加点击手势
    
    /// 添加点击手势
    /// - Parameters:
    ///   - target: 事件响应者
    ///   - action: 事件
    ///   - numberOfTapsRequired: 点击次数
    ///   - numberOfTouchesRequired: 手指个数
    /// - Returns: 
    func addTapGestureRecognizer(target : Any?, action : Selector?, numberOfTapsRequired: Int = 1, numberOfTouchesRequired: Int = 1) -> UITapGestureRecognizer {
        
        let tapGesture = UITapGestureRecognizer.init(target: target, action: action)
        tapGesture.numberOfTapsRequired    = numberOfTapsRequired;
        tapGesture.numberOfTouchesRequired = numberOfTouchesRequired;
        tapGesture.cancelsTouchesInView    = true;
        tapGesture.delaysTouchesBegan      = true;
        tapGesture.delaysTouchesEnded      = true;
        
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
        
        return tapGesture
    }
    
    // MARK: - 获取view的UIViewController
    func parentViewController() -> UIViewController?{
        for view in sequence(first: self.superview, next: {$0?.superview}){
            if let responder = view?.next{
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
    
    // MARK: - 空内容的抖动动画
    func shakeAnimation() {
        let lbl = self.layer
        let posLbl = lbl.position
        let x = CGPoint(x: posLbl.x + 5, y: posLbl.y)
        let y = CGPoint(x: posLbl.x - 5, y: posLbl.y)
        
        let animation = CABasicAnimation.init(keyPath: "position")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fromValue = NSValue.init(cgPoint: x)
        animation.toValue = NSValue.init(cgPoint: y)
        animation.autoreverses = true
        animation.duration = 0.08
        animation.repeatCount = 3
        lbl.add(animation, forKey: nil)
    }
    
    // MARK: - 获取当前的viewController
    var currentViewController: UIViewController? {
        var next: UIView? = self
        while (next != nil) {
            if let nextResponder = next?.next as? UIViewController {
                return nextResponder
            }
            next = next?.superview
        }
        return nil
    }
    
    // 使用贝塞尔曲线设置圆角
    func setBezierCornerRadius(position: UIRectCorner, cornerRadius: CGFloat, roundedRect: CGRect) {
        
        let path = UIBezierPath(roundedRect:roundedRect, byRoundingCorners: position, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let layer = CAShapeLayer()
        layer.frame = roundedRect
        layer.path = path.cgPath
        self.layer.mask = layer
    }
}

// MARK: UIView的frame相关
extension UIView {
    
    var viewFrameX: CGFloat {
        set {
            self.frame = CGRect(x: newValue, y: self.viewFrameY, width:self.viewFrameWidth, height: self.viewFrameHeight)
        }
        
        get {
            return self.frame.origin.x
        }
    }
    
    var viewFrameY: CGFloat {
        set {
            self.frame = CGRect(x: self.viewFrameX, y: newValue, width: self.viewFrameWidth, height: self.viewFrameHeight)
        }
        
        get {
            return self.frame.origin.y;
        }
    }
    
    var viewFrameWidth: CGFloat {
        set {
            self.frame = CGRect(x: self.viewFrameX, y: self.viewFrameY, width: newValue, height: self.viewFrameHeight)
        }
        
        get {
            return self.frame.size.width;
        }
    }
    
    var viewFrameHeight: CGFloat {
        set {
            self.frame = CGRect(x: self.viewFrameX, y: self.viewFrameY, width: self.viewFrameWidth, height: newValue)
        }
        
        get {
            return self.frame.size.height;
        }
    }
    
    var viewCenterX: CGFloat {
        set{
            self.center = CGPoint(x: newValue, y: self.viewCenterY)
        }
        
        get {
            return self.center.x
        }
    }
    
    var viewCenterY: CGFloat {
        set {
            self.center = CGPoint(x: self.viewCenterX, y: newValue)
        }
        
        get {
            return self.center.y
        }
    }
    
    var viewXY: CGPoint {
        set {
            self.viewFrameX = newValue.x
            self.viewFrameY = newValue.y
        }
        
        get {
            return CGPoint(x: self.viewFrameX, y: self.viewFrameY)
        }
    }
    
    var viewSize: CGSize {
        set {
            self.viewFrameWidth = newValue.width
            self.viewFrameHeight = newValue.height
        }
        
        get {
            return CGSize(width: self.viewFrameWidth, height: self.viewFrameHeight)
        }
    }
    
    var viewRightX: CGFloat {
        get {
            return self.viewFrameX + self.viewFrameWidth;
        }
    }
    
    var viewBottomY: CGFloat {
        get {
            return self.viewFrameY+self.viewFrameHeight;
        }
    }
    
    var viewMidX: CGFloat {
        
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
        
        get {
            return self.viewFrameX / 2
        }
    }
    
    var viewMidY: CGFloat {
        
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
        
        get {
            return self.viewFrameY / 2
        }
    }
    
    var viewMidWidth: CGFloat {
        get {
            return self.viewFrameWidth / 2
        }
    }
    
    var viewMidHeight: CGFloat {
        get {
            return self.viewFrameHeight / 2
        }
    }
    
    var viewMidWidthAndHeight: CGPoint {
        get {
            return CGPoint(x: self.viewMidWidth, y: self.viewMidHeight)
        }
    }
    
    // 设置圆角
    var layerCornerRadius: CGFloat {
        set {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = newValue
        }
        
        get {
            return self.layer.cornerRadius
        }
    }
    
    // 设置边框线颜色
    func setBorder(color: UIColor, width: CGFloat = 1.0) {
        self.layer.masksToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    
    //将当前视图转为UIImage
    func screenshots() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { (rendererContext) in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
