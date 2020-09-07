//
//  CGSize+Extension.swift
//  XCamera
//
//  Created by Swaying on 2017/9/17.
//  Copyright © 2017年 xhey. All rights reserved.
//

import Foundation

extension CGSize {
    
    //size fit a size ratio
    func fitCropSizeRatio(_ size: CGSize) -> CGSize {

        let oldSizeRatio: CGFloat = width / height
        let newSizeRatio: CGFloat = size.width / size.height
        
        let newWidth: CGFloat
        let newHeight: CGFloat
        
        if oldSizeRatio > newSizeRatio {
            newWidth = height * newSizeRatio
            newHeight = height
        } else {
            newWidth = width
            newHeight = width / newSizeRatio
        }
        
        return CGSize(width: newWidth, height: newHeight)
    }
    
    func scaleShortTo(_ short: CGFloat) -> CGSize {
        let scale: CGFloat
        if width > height {
            scale = short / height
        } else {
            scale = short / width
        }
        if scale >= 1 {
            return self
        } else {
            let _width = width * scale
            let _height = height * scale
            return CGSize(width: _width , height: _height)
        }
    }
    
    func reverse() -> CGSize {
        return CGSize(width: height, height: width)
    }
    
}

func *(left: CGSize, right: Double) -> CGSize {
    return left * CGFloat(right)
}

func *(left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width * right, height: left.height * right)
}
