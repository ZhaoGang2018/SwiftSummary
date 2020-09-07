//
//  UIImage+Downsampling.swift
//  XCamera
//
//  Created by Quinn Von on 2020/4/10.
//  Copyright © 2020 xhey. All rights reserved.
//

import Foundation

/// 参考：https://swift.gg/2019/11/01/image-resizing/


extension UIImage{
    /// UIGraphicsImageRenderer 速度最佳
    static func downsamplingImageByUI(at url: URL, for size: CGSize) -> UIImage? {
        guard let image = UIImage(contentsOfFile: url.path) else {
            return nil
        }

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    /// Core Graphics Context
    static func downsamplingImageByCG(at url: URL, for size: CGSize) -> UIImage? {
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
    /// Image I/O
    static func downsamplingImageByImageIO(at url: URL, for size: CGSize) -> UIImage? {
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
        ]

        guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
        else {
            return nil
        }

        return UIImage(cgImage: image)
    }
}
