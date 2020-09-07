//
//  UIImage+Extension.swift
//  XCamera
//
//  Created by Swaying on 2018/1/9.
//  Copyright © 2018年 xhey. All rights reserved.
//

import UIKit
import ImageIO

extension UIImage {
    
    var containsAlphaComponent: Bool {
        let alphaInfo = cgImage?.alphaInfo
        
        return (alphaInfo == .first ||
            alphaInfo == .last ||
            alphaInfo == .premultipliedFirst ||
            alphaInfo == .premultipliedLast
        )
    }
    
    /// Returns whether the image is opaque.
    var isOpaque: Bool { return !containsAlphaComponent }

    func scaledToSize(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, isOpaque, 0.0)
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    func scaledToRatioSize(_ ratio: CGFloat) -> UIImage {
        let newSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        let scaledImage = self.scaledToSize(newSize)
        return scaledImage
    }
    
    // 调整图片分辨率和size的大小
    func resetResolutionAndSize(maxLength: CGFloat, maxStorageSpaceKB: CGFloat) -> Data? {
        
        var maxSize = maxStorageSpaceKB
        if (maxSize <= 0.0) {
            maxSize = 1024.0;
        }
        
        var maxImageSize = maxLength
        if (maxImageSize <= 0.0)  {
            maxImageSize = 1024.0;
        }
        
        let sourceImage = self
        //先调整分辨率
        var newSize = CGSize.init(width: sourceImage.size.width, height: sourceImage.size.height)
        let tempHeight = newSize.height / maxImageSize;
        let tempWidth = newSize.width / maxImageSize;
        
        if (tempWidth > 1.0 && tempWidth >= tempHeight) {
            
            newSize = CGSize(width: sourceImage.size.width / tempWidth, height: sourceImage.size.height / tempWidth)
        } else if (tempHeight > 1.0 && tempWidth <= tempHeight){
            
            newSize = CGSize(width: sourceImage.size.width / tempHeight, height: sourceImage.size.height / tempHeight)
        }
        
        UIGraphicsBeginImageContext(newSize)
        
        sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        
        UIGraphicsEndImageContext()
        
        guard var imageData = newImage.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        
        var sizeOriginKB: CGFloat = CGFloat(imageData.count) / 1024.0
        
        //调整大小
        var resizeRate = 0.71;
        while (sizeOriginKB > maxSize && resizeRate > 0.1) {
            if let tempData = newImage.jpegData(compressionQuality: CGFloat(resizeRate)) {
                imageData = tempData
                sizeOriginKB = CGFloat(imageData.count) / 1024.0;
                resizeRate -= 0.1;
            } else {
                break
            }
        }
        
        return imageData
    }
    
    public func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    // MARK: - 调整同步到团队的数据data
    func resizePhotoDataSyncToTeam(maxLength: CGFloat = 1080, maxStorageSpaceKB: CGFloat = 200,isContinueShootImage:Bool?=false) -> Data? {
        
        var data:Data?
        if isContinueShootImage == true{
            data = self.continueShootImageResize()
        }else{
            data = self.resetResolutionAndSize(maxLength: maxLength, maxStorageSpaceKB: maxStorageSpaceKB)
        }
         
        return data
    }
    
    private func continueShootImageResize()->Data?{
        
        //非vip 宽度1000px,大小1M一下 , 大高的. 目前只考虑竖着的image
        let maxKbSize:CGFloat = 1024
        
        let maxImageWidth:CGFloat = 1000
        
        let sourceImage = self
        //先调整分辨率
        let newSize = CGSize.init(width: maxImageWidth, height: sourceImage.size.height/max(sourceImage.size.width, 0.1)*maxImageWidth)
        
        UIGraphicsBeginImageContext(newSize)
        
        sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        
        UIGraphicsEndImageContext()
        
        guard var imageData = newImage.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        
        var sizeOriginKB: CGFloat = CGFloat(imageData.count) / 1024.0
        
        //调整大小
        var resizeRate = 0.71;
        while (sizeOriginKB > maxKbSize && resizeRate > 0.1) {
            if let tempData = newImage.jpegData(compressionQuality: CGFloat(resizeRate)) {
                imageData = tempData
                sizeOriginKB = CGFloat(imageData.count) / 1024.0;
                resizeRate -= 0.1;
            } else {
                break
            }
        }
        
        return imageData
    }

}
