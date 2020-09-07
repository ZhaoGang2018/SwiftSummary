//
//  HintAnimateType.swift
//  ShowHint
//
//  Created by Swaying on 2017/12/14.
//  Copyright © 2017年 xhey. All rights reserved.
//

import QuartzCore

enum HintAnimateType {
    case fadeInOutTypeOne
    case fadeInOut(fadeInFromValue: Double, fadeInToValue: Double, fadeInDelay: Double, fadeInDuration: Double, fadeOutFromValue: Double, fadeOutToValue: Double, fadeOutDelay: Double, fadeOutDuration: Double)
    case fadeInOutWithMovedAndScaleTypeOne
    case fadeInOutWithMovedAndScaleTypeTwo
    case fadeInOutWithMovedAndScale(fromPosition:CGPoint, toPosition:CGPoint, inDelay: Double, inDuration: Double, inScaleFrom:Double, inScaleTo:Double ,outDelay: Double, outDuration: Double,outScaleFrom:Double, outScaleTo:Double,outOpacityFrom:Double, outOpacityTo:Double)

    func animate() -> CAAnimation {
        
        switch self {
        case .fadeInOutTypeOne:
            return fadeInout(inFromValue: 0, inToValue: 1, inDelay: 0, inDuration: 0.1, outFromValue: 1, outToValue: 0, outDelay: 1.5, outDuration: 0.3)
        case .fadeInOut(let inFromValue, let inToValue, let fadeInDelay,let fadeInDuration, let outFromValue, let outToValue,let fadeOutDelay,let fadeOutDuration):
            return fadeInout(inFromValue: inFromValue,
                             inToValue: inToValue,
                             inDelay: fadeInDelay,
                             inDuration: fadeInDuration,
                             outFromValue: outFromValue,
                             outToValue: outToValue,
                             outDelay: fadeOutDelay,
                             outDuration: fadeOutDuration)
        case .fadeInOutWithMovedAndScaleTypeOne:
            return fadeInOutWithMovedAndScaleAnimation(fromPosition: CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2+30),
                                                       toPosition: CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2),
                                                       inDelay: 0,
                                                       inDuration: 0.15,
                                                       inScaleFrom: 0.6,
                                                       inScaleTo: 1,
                                                       outDelay: 1.2,
                                                       outDuration: 0.3,
                                                       outScaleFrom:1,
                                                       outScaleTo:0.9,
                                                       outOpacityFrom: 1,
                                                       outOpacityTo: 0)
        case .fadeInOutWithMovedAndScaleTypeTwo:
            return fadeInOutWithMovedAndScaleAnimation(fromPosition: CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2+30),
                                                       toPosition: CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2),
                                                       inDelay: 0,
                                                       inDuration: 0.15,
                                                       inScaleFrom: 0.9,
                                                       inScaleTo: 1,
                                                       outDelay: 1.2,
                                                       outDuration: 0.3,
                                                       outScaleFrom:1,
                                                       outScaleTo:1,
                                                       outOpacityFrom: 1,
                                                       outOpacityTo: 1)
        case .fadeInOutWithMovedAndScale(let fromPosition, let toPosition, let inDelay, let inDuration,let inScaleFrom,let inScaleTo, let outDelay, let outDuration,let outScaleFrom,let outScaleTo,let outOpacityFrom,let outOpacityTo):
            return fadeInOutWithMovedAndScaleAnimation(fromPosition: fromPosition,
                             toPosition: toPosition,
                             inDelay: inDelay,
                             inDuration: inDuration,
                            inScaleFrom: inScaleFrom,
                            inScaleTo: inScaleTo,
                             outDelay: outDelay,
                             outDuration: outDuration,
                             outScaleFrom: outScaleFrom,
                             outScaleTo: outScaleTo,
                             outOpacityFrom: outOpacityFrom,
                             outOpacityTo: outOpacityTo)
        }
    }
    
    private func fadeInout(inFromValue: Double,inToValue: Double,inDelay: Double, inDuration: Double ,outFromValue: Double, outToValue: Double, outDelay: Double, outDuration: Double) -> CAAnimation {
        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.duration = inDuration
        fadeIn.beginTime = inDelay
        fadeIn.fromValue = inFromValue
        fadeIn.toValue = inToValue
        fadeIn.isRemovedOnCompletion = false
        fadeIn.fillMode = CAMediaTimingFillMode.forwards
        
        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.duration = outDuration
        fadeOut.beginTime = outDelay
        fadeOut.fromValue = outFromValue
        fadeOut.toValue = outToValue
        
        let animateGroup = CAAnimationGroup()
        animateGroup.duration = fadeOut.beginTime + fadeOut.duration
        animateGroup.animations = [fadeIn,fadeOut]
        
        return animateGroup
    }
    /// 入：渐显 出：渐隐 伴随 位移、缩放
    /// - Parameters:
    ///   - fromPosition: 起始点
    ///   - toPosition: 终点
    ///   - inDelay: 延迟多久
    ///   - inDuration: 入场时间
    ///   - inScaleFrom: 入场缩放起始值
    ///   - inScaleTo: 入场缩放最终值
    ///   - outDelay: 出场延迟
    ///   - outDuration: 出场时间
    ///   - outScaleFrom: 出场缩放起始值
    ///   - outScaleTo: 出场缩放最终值
    ///   - outOpacityFrom: 出场透明度起始值
    ///   - outOpacityTo: 出场透明度最终值
    /// - Returns: 一个满足上述条件的CoreAnimation动画组
    private func fadeInOutWithMovedAndScaleAnimation(fromPosition:CGPoint, toPosition:CGPoint, inDelay: Double, inDuration: Double,inScaleFrom:Double, inScaleTo:Double ,outDelay: Double, outDuration: Double,outScaleFrom:Double, outScaleTo:Double, outOpacityFrom:Double, outOpacityTo:Double) -> CAAnimation {

        let fadeIn1 = CABasicAnimation(keyPath: "position")
        fadeIn1.duration = inDuration
        fadeIn1.beginTime = inDelay
        fadeIn1.fromValue = fromPosition
        fadeIn1.toValue = toPosition

        let fadeIn2 = CABasicAnimation(keyPath: "transform.scale")
        fadeIn2.duration = inDuration
        fadeIn2.beginTime = inDelay
        fadeIn2.fromValue = inScaleFrom
        fadeIn2.toValue = inScaleTo
        
        let fadeIn3 = CABasicAnimation(keyPath: "opacity")
        fadeIn3.duration = inDuration
        fadeIn3.beginTime = inDelay
        fadeIn3.fromValue = 0
        fadeIn3.toValue = 1
        
        let fadeOut1 = CABasicAnimation(keyPath: "transform.scale")
        fadeOut1.duration = outDuration
        fadeOut1.beginTime = outDelay
        fadeOut1.fromValue = outScaleFrom
        fadeOut1.toValue = outScaleTo
        
        let fadeOut2 = CABasicAnimation(keyPath: "opacity")
        fadeOut2.duration = outDuration
        fadeOut2.beginTime = outDelay
        fadeOut2.fromValue = outOpacityFrom
        fadeOut2.toValue = outOpacityTo
        
        let animateGroup = CAAnimationGroup()
        animateGroup.duration = outDelay + outDuration
        animateGroup.animations = [fadeIn1,fadeIn2,fadeIn3,fadeOut1,fadeOut2]
        animateGroup.fillMode = CAMediaTimingFillMode.forwards
        animateGroup.isRemovedOnCompletion = false
        return animateGroup
    }
}
