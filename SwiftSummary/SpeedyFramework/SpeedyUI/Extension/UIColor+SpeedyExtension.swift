//
//  UIColor+SpeedyExtension.swift
//  XCamera
//
//  Created by jing_mac on 2019/12/20.
//  Copyright © 2019 xhey. All rights reserved.
//

import Foundation

extension UIColor {
    
    // Hex String -> UIColor
    convenience init(hex: String, _ alpha: CGFloat = 1.0) {
        
        let tempStr = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let hexint = UIColor.intFromHexString(tempStr)
        self.init(red: ((CGFloat) ((hexint & 0xFF0000) >> 16))/255, green: ((CGFloat) ((hexint & 0xFF00) >> 8))/255, blue: ((CGFloat) (hexint & 0xFF))/255, alpha: alpha)
    }
    
    class func fromHex(_ hex: String, alpha: CGFloat = 1.0) -> UIColor{
        
        let tempStr = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let hexint = intFromHexString(tempStr)
        let color = UIColor(red: ((CGFloat) ((hexint & 0xFF0000) >> 16))/255, green: ((CGFloat) ((hexint & 0xFF00) >> 8))/255, blue: ((CGFloat) (hexint & 0xFF))/255, alpha: alpha)
        return color
    }
    
    // 通过rgb设置颜色
    class func fromRGBA(_ r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    // UIColor -> Hex String
    var toHexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
    
    /// 左右渐变色
    /// - Parameters:
    ///   - left: 左侧颜色
    ///   - right: 右侧颜色
    ///   - rect: 渐变区域
    ///   return :  渐变图层
    static func gradient(left:UIColor,right:UIColor,rect:CGRect)->CAGradientLayer{
        func gradientLayer(rect:CGRect)->CAGradientLayer{
            let colorLayer = CAGradientLayer()
            colorLayer.frame = rect
            colorLayer.colors = [left.cgColor,right.cgColor]
            colorLayer.startPoint = CGPoint(x: 0, y: 0.5)
            colorLayer.endPoint = CGPoint(x: 1, y: 0.5)
            return colorLayer
        }
        return gradientLayer(rect: rect)
    }
    
    // MARK: - 生成随机颜色
    class func randromColor() -> UIColor {
        let r = CGFloat(arc4random()%256)/255.0
        let g = CGFloat(arc4random()%256)/255.0
        let b = CGFloat(arc4random()%256)/255.0
        let color = UIColor(displayP3Red: r, green: g, blue: b, alpha: 1)
        return color
    }
    
    // 从Hex装换int
    class func intFromHexString(_ hexString:String)->UInt32{
        let scanner = Scanner(string: hexString)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        var result : UInt32 = 0
        scanner.scanHexInt32(&result)
        return result
    }
    
    class func UIColorFromRGBA(_ r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    class func UIColorFromHex(_ hex6: UInt32, alpha: CGFloat = 1) -> UIColor {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    class func RandomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(256))
        let green = CGFloat(arc4random_uniform(256))
        let blue = CGFloat(arc4random_uniform(256))
        return UIColorFromRGBA(red, g: green, b: blue)
    }
}


/*
 convenience init(hexString: String, alpha: CGFloat = 1.0) {
 let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
 let scanner = Scanner(string: hexString)
 
 if hexString.hasPrefix("#") {
 scanner.scanLocation = 1
 }
 
 var color: UInt32 = 0
 scanner.scanHexInt32(&color)
 
 let mask = 0x000000FF
 let r = Int(color >> 16) & mask
 let g = Int(color >> 8) & mask
 let b = Int(color) & mask
 
 let red   = CGFloat(r) / 255.0
 let green = CGFloat(g) / 255.0
 let blue  = CGFloat(b) / 255.0
 
 self.init(red: red, green: green, blue: blue, alpha: alpha)
 }
 */
