//
//  UIImage+Watermark.swift
//  XCamera
//
//  Created by Quinn Von on 2020/4/7.
//  Copyright © 2020 xhey. All rights reserved.
//

import Foundation
extension UIImage{
    /// 防盗图
    // 传入底图image和字符串text，生成水印遮罩图
    // image 指定的方形格子图 4*4 布局
    // text应当手动插入换行符号
    // 内部attr为属性字符串 可以调整
    static func watermarkImage(with image:UIImage,text:String) -> UIImage? {
        // angle可以旋转
        let angle : CGFloat = 0.0
        let img_w = CGFloat((image.cgImage?.width)!)
        let img_h = CGFloat((image.cgImage?.height)!)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: img_w, height: img_h), false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: img_w, height: img_h))
        let font = UIFont.QiHeiX2_FEW(16)
        let attr = [
            NSAttributedString.Key.font:font,
            NSAttributedString.Key.foregroundColor:UIColor.white
        ]
        
        let attr_str = NSMutableAttributedString(string: text as String, attributes: attr)
        let str_w = attr_str.size().width
        let str_h = attr_str.size().height
        
        let context = UIGraphicsGetCurrentContext()
        context?.concatenate(.init(translationX: CGFloat(img_w / 2), y: CGFloat(img_h / 2)))
        context?.concatenate(.init(rotationAngle: angle))
        context?.concatenate(.init(translationX: -CGFloat(img_w / 2), y: -CGFloat(img_h / 2)))
        
        let originX = img_w / 2 - str_w / 2
        let originY = img_h / 2 - str_h / 2
        text.draw(in: CGRect(x: originX, y: originY, width: str_w, height: str_h), withAttributes: attr)
        
//        let originX = img_w / 8 - str_w / 2;
//        let originY = img_h / 8 - str_h / 2;
//
//        var overlayOriginX = originX
//        var overlayOriginY = originY
//
//        for i in 0...16 {
//            text.draw(in: CGRect(x: overlayOriginX, y: overlayOriginY, width: str_w, height: str_h), withAttributes: attr)
//            if i%4 == 0 && i != 0 {
//                overlayOriginX = originX
//                overlayOriginY += img_h / 4
//            }else{
//                overlayOriginX += img_w/4
//            }
//        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
//        context?.restoreGState()
        
        return newImage
    }
}
