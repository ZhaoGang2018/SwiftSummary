//
//  UIImage+Blend.swift
//  XCamera
//
//  Created by Quinn Von on 2020/4/7.
//  Copyright © 2020 xhey. All rights reserved.
//

import Foundation
extension UIImage{
    /// inputImageSize 和 backgroundImage同样大小 金属条
    static func overlay_multily_image(with backgroundImage:UIImage,color: UIColor, inputImageSize:CGSize) -> UIImage?{
        let inputImage = UIImage.withColor(color, and: inputImageSize)
        let area = CGRect.init(x: 0, y: 0, width: inputImageSize.width, height: inputImageSize.height)
        let context = CIContext(options: nil)

        let backgroundCIImage50  = CIImage(image: backgroundImage.alphaImage(with: 0.1,rect: area)!)
        let backgroundCIImage80  = CIImage(image: backgroundImage.alphaImage(with: 0.8,rect: area)!)
        
        let inputCIImage = CIImage(image: inputImage!)

        let  outputImage = inputCIImage?
            .applyingFilter("CIOverlayBlendMode", parameters: [kCIInputBackgroundImageKey:backgroundCIImage50!])
            .applyingFilter("CIMultiplyBlendMode", parameters: [kCIInputBackgroundImageKey:backgroundCIImage80!])

        let cgimage = context.createCGImage(outputImage!, from: outputImage!.extent)

        return UIImage.init(cgImage: cgimage!)
        
    }
    
    private var grayImage: UIImage {
         let width = self.size.width
         let height = self.size.height
         let colorSpace = CGColorSpaceCreateDeviceGray()
         let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGBitmapInfo().rawValue)
         let rect = CGRect(x: 0, y: 0, width: width, height: height)
         context?.draw(self.cgImage!, in: rect)
         return UIImage(cgImage: (context?.makeImage())!)
     }
     //调整图片的alpha值
    private func alphaImage(with alpha:CGFloat,rect:CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
         let ctx = UIGraphicsGetCurrentContext()
        let area = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
         ctx?.scaleBy(x: 1, y: -1)
         ctx?.translateBy(x: 0, y: -area.size.height)
         ctx?.setBlendMode(.multiply)
         ctx?.setAlpha(alpha)
         ctx?.draw(self.cgImage!, in: area)
         let newImage = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         return newImage
     }
     // 根据传入颜色生成纯色图片
     private static func withColor(_ color : UIColor, and size: CGSize) -> UIImage? {
         let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
         UIGraphicsBeginImageContext(rect.size)
         let context = UIGraphicsGetCurrentContext()
         context?.setFillColor(color.cgColor)
         context?.fill(rect)
         let image = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         return image
     }
}
