//
//  UIImage+SpeedyExtension.swift
//  XCamera
//
//  Created by jing_mac on 2020/4/7.
//  Copyright © 2020 xhey. All rights reserved.
//

import Foundation
import UIKit

// MARK: 颜色转UIImage
extension UIImage {
    
    // 图片所占的字节数
    var bytesCount: Int {
        if let data = self.jpegData(compressionQuality: 1.0) {
            return data.bytes.count
        }
        return 0
    }
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) {
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: CGPoint.zero, size: size))
        context?.setShouldAntialias(true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        guard let cgImage = image?.cgImage else {
            self.init()
            return nil
        }
        self.init(cgImage: cgImage)
    }
    
    // 通过颜色生成一张图片
    class func imageWithColor(color : UIColor, size : CGSize) -> UIImage? {
        
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        context?.fillPath()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // 通过多个色值生成一张渐变的图片
    class func imageWithGradientColors(colors: [UIColor], size : CGSize) -> UIImage? {
        
        var cgColors: [CGColor] = []
        for currentColor in colors {
            cgColors.append(currentColor.cgColor)
        }
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.startPoint = CGPoint.init(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0.5, y: 0.8)
        
        gradientLayer.colors = cgColors
        
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        
        view.layer.addSublayer(gradientLayer)
        
        let image = UIImage.imageWithView(view, compressionQuality: 1.0)
        
        return image
    }
    
    class func imageWithView(_ view : UIView, compressionQuality : CGFloat) -> UIImage? {
        
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            if compressionQuality == 1 {
                return image
            } else {
                if let data = image.jpegData(compressionQuality: compressionQuality){
                    let tempImage = UIImage.init(data: data)
                    return tempImage
                }else{
                    return nil
                }
            }
        }else{
            return nil
        }
    }
    static func resizedImageCG(at url: URL, for size: CGSize) -> UIImage? {
        precondition(size != .zero)

        guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            return nil
        }
        
        let context = CGContext(data: nil,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: image.bitsPerComponent,
                                bytesPerRow: image.bytesPerRow,
                                space: image.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
                                bitmapInfo: image.bitmapInfo.rawValue)
        context?.interpolationQuality = .high
        context?.draw(image, in: CGRect(origin: .zero, size: size))
        
        guard let scaledImage = context?.makeImage() else { return nil }
        
        return UIImage(cgImage: scaledImage)
    }
}

// MARK: 图片设置圆角
extension UIImage {
    
    public func roundImage(byRoundingCorners: UIRectCorner = UIRectCorner.allCorners, cornerRadi: CGFloat) -> UIImage? {
        return roundImage(byRoundingCorners: byRoundingCorners, cornerRadii: CGSize(width: cornerRadi, height: cornerRadi))
    }
    
    public func roundImage(byRoundingCorners: UIRectCorner = UIRectCorner.allCorners, cornerRadii: CGSize) -> UIImage? {
        
        let imageRect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        guard context != nil else {
            return nil
        }
        context?.setShouldAntialias(true)
        let bezierPath = UIBezierPath(roundedRect: imageRect,
                                      byRoundingCorners: byRoundingCorners,
                                      cornerRadii: cornerRadii)
        bezierPath.close()
        bezierPath.addClip()
        self.draw(in: imageRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}

// MARK: 图片缩放
extension UIImage {
    
    public func scaleTo(size targetSize: CGSize) -> UIImage? {
        let srcSize = self.size
        if __CGSizeEqualToSize(srcSize, targetSize) {
            return self
        }
        
        let scaleRatio = targetSize.width / srcSize.width
        var dstSize = CGSize(width: targetSize.width, height: targetSize.height)
        let orientation = self.imageOrientation
        var transform = CGAffineTransform.identity
        switch orientation {
        case .up:
            transform = CGAffineTransform.identity
        case .upMirrored:
            transform = CGAffineTransform(translationX: srcSize.width, y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
        case .down:
            transform = CGAffineTransform(translationX: srcSize.width, y: srcSize.height)
            transform = transform.scaledBy(x: 1.0, y: CGFloat(Double.pi))
        case .downMirrored:
            transform = CGAffineTransform(translationX: 0.0, y: srcSize.height)
            transform = transform.scaledBy(x: 1.0, y: -1.0)
        case .leftMirrored:
            dstSize = CGSize(width: dstSize.height, height: dstSize.width)
            transform = CGAffineTransform(translationX: srcSize.height, y: srcSize.width)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
            transform = transform.rotated(by: CGFloat(3.0) * CGFloat(Double.pi / 2))
        case .left:
            dstSize = CGSize(width: dstSize.height, height: dstSize.width)
            transform = CGAffineTransform(translationX: 0.0, y: srcSize.width)
            transform = transform.rotated(by: CGFloat(3.0) * CGFloat(Double.pi / 2))
        case .rightMirrored:
            dstSize = CGSize(width: dstSize.height, height: dstSize.width)
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            transform = transform.rotated(by:  CGFloat(Double.pi / 2))
        default:
            dstSize = CGSize(width: dstSize.height, height: dstSize.width)
            transform = CGAffineTransform(translationX: srcSize.height, y: 0.0)
            transform = transform.rotated(by:  CGFloat(Double.pi / 2))
        }
        
        UIGraphicsBeginImageContextWithOptions(dstSize, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        guard context != nil else {
            return nil
        }
        context?.setShouldAntialias(true)
        if orientation == UIImage.Orientation.right || orientation == UIImage.Orientation.left {
            context?.scaleBy(x: -scaleRatio, y: scaleRatio)
            context?.translateBy(x: -srcSize.height, y: 0)
        }
        else {
            context?.scaleBy(x: scaleRatio, y: -scaleRatio)
            context?.translateBy(x: 0, y: -srcSize.height)
        }
        context?.concatenate(transform)
        guard let cgImage = self.cgImage else {
            return nil
        }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: srcSize.width, height: srcSize.height))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    public func scaleTo(fitSize targetSize: CGSize, scaleIfSmaller: Bool = false) -> UIImage? {
        let srcSize = self.size
        if __CGSizeEqualToSize(srcSize, targetSize) {
            return self
        }
        
        let orientation = self.imageOrientation
        var dstSize = targetSize
        switch orientation {
        case .left, .right, .leftMirrored, .rightMirrored:
            dstSize = CGSize(width: dstSize.height, height: dstSize.width)
        default:
            break
        }
        if !scaleIfSmaller && (srcSize.width < dstSize.width) && (srcSize.height < dstSize.height) {
            dstSize = srcSize
        }
        else {
            let wRatio = dstSize.width / srcSize.width
            let hRatio = dstSize.height / srcSize.height
            dstSize = wRatio < hRatio ?
                CGSize(width: dstSize.width, height: srcSize.height * wRatio) :
                CGSize(width: srcSize.width * wRatio, height: dstSize.height)
        }
        return self.scaleTo(size: dstSize)
    }
}

// MARK: 通过String生成二维码
extension UIImage {
    
    public static func generateQRImage(QRCodeString: String, logo: UIImage?, size: CGSize = CGSize(width: 50, height: 50)) -> UIImage? {
        guard let data = QRCodeString.data(using: .utf8, allowLossyConversion: false) else {
            return nil
        }
        let imageFilter = CIFilter(name: "CIQRCodeGenerator")
        imageFilter?.setValue(data, forKey: "inputMessage")
        imageFilter?.setValue("H", forKey: "inputCorrectionLevel")
        let ciImage = imageFilter?.outputImage
        
        // 创建颜色滤镜
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter?.setDefaults()
        colorFilter?.setValue(ciImage, forKey: "inputImage")
        colorFilter?.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter?.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        
        // 返回二维码图片
        let qrImage = UIImage(ciImage: (colorFilter?.outputImage)!)
        let imageRect = size.width > size.height ?
            CGRect(x: (size.width - size.height) / 2, y: 0, width: size.height, height: size.height) :
            CGRect(x: 0, y: (size.height - size.width) / 2, width: size.width, height: size.width)
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        qrImage.draw(in: imageRect)
        if logo != nil {
            let logoSize = size.width > size.height ?
                CGSize(width: size.height * 0.25, height: size.height * 0.25) :
                CGSize(width: size.width * 0.25, height: size.width * 0.25)
            logo?.draw(in: CGRect(x: (imageRect.size.width - logoSize.width) / 2, y: (imageRect.size.height - logoSize.height) / 2, width: logoSize.width, height: logoSize.height))
        }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}

/*
 //MARK: -传进去字符串,生成二维码图片
 func setupQRCodeImage(_ text: String, image: UIImage?) -> UIImage {
     //创建滤镜
     let filter = CIFilter(name: "CIQRCodeGenerator")
     filter?.setDefaults()
     //将url加入二维码
     filter?.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
     //取出生成的二维码（不清晰）
     if let outputImage = filter?.outputImage {
         //生成清晰度更好的二维码
         let qrCodeImage = setupHighDefinitionUIImage(outputImage, size: 300)
         //如果有一个头像的话，将头像加入二维码中心
         if var image = image {
             //给头像加一个白色圆边（如果没有这个需求直接忽略）
             image = circleImageWithImage(image, borderWidth: 50, borderColor: UIColor.white)
             //合成图片
             let newImage = syntheticImage(qrCodeImage, iconImage: image, width: 100, height: 100)
             
             return newImage
         }
         
         return qrCodeImage
     }
     
     return UIImage()
 }

 //image: 二维码 iconImage:头像图片 width: 头像的宽 height: 头像的宽
 func syntheticImage(_ image: UIImage, iconImage:UIImage, width: CGFloat, height: CGFloat) -> UIImage{
     //开启图片上下文
     UIGraphicsBeginImageContext(image.size)
     //绘制背景图片
     image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
     
     let x = (image.size.width - width) * 0.5
     let y = (image.size.height - height) * 0.5
     iconImage.draw(in: CGRect(x: x, y: y, width: width, height: height))
     //取出绘制好的图片
     let newImage = UIGraphicsGetImageFromCurrentImageContext()
     //关闭上下文
     UIGraphicsEndImageContext()
     //返回合成好的图片
     if let newImage = newImage {
         return newImage
     }
     return UIImage()
 }

 //MARK: - 生成高清的UIImage
 func setupHighDefinitionUIImage(_ image: CIImage, size: CGFloat) -> UIImage {
     let integral: CGRect = image.extent.integral
     let proportion: CGFloat = min(size/integral.width, size/integral.height)
     
     let width = integral.width * proportion
     let height = integral.height * proportion
     let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
     let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0)!
     
     let context = CIContext(options: nil)
     let bitmapImage: CGImage = context.createCGImage(image, from: integral)!
     
     bitmapRef.interpolationQuality = CGInterpolationQuality.none
     bitmapRef.scaleBy(x: proportion, y: proportion);
     bitmapRef.draw(bitmapImage, in: integral);
     let image: CGImage = bitmapRef.makeImage()!
     return UIImage(cgImage: image)
 }

 //生成边框
 func circleImageWithImage(_ sourceImage: UIImage, borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
     let imageWidth = sourceImage.size.width + 2 * borderWidth
     let imageHeight = sourceImage.size.height + 2 * borderWidth
     
     UIGraphicsBeginImageContextWithOptions(CGSize(width: imageWidth, height: imageHeight), false, 0.0)
     UIGraphicsGetCurrentContext()
     
     let radius = (sourceImage.size.width < sourceImage.size.height ? sourceImage.size.width:sourceImage.size.height) * 0.5
     let bezierPath = UIBezierPath(arcCenter: CGPoint(x: imageWidth * 0.5, y: imageHeight * 0.5), radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
     bezierPath.lineWidth = borderWidth
     borderColor.setStroke()
     bezierPath.stroke()
     bezierPath.addClip()
     sourceImage.draw(in: CGRect(x: borderWidth, y: borderWidth, width: sourceImage.size.width, height: sourceImage.size.height))
     
     let image = UIGraphicsGetImageFromCurrentImageContext()
     UIGraphicsEndImageContext()
     
     return image!
 }

 */


