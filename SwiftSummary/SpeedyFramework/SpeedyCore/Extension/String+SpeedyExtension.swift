//
//  String+SpeedyExtension.swift
//  XCamera
//
//  Created by jing_mac on 2019/11/5.
//  Copyright © 2019 xhey. All rights reserved.
//

import Foundation

extension String {
    
    // MARK: - 手机号校验
    func phoneVerify() -> Bool {
        let chars = NSCharacterSet.init(charactersIn: "0123456789").inverted
        let filtered = self.components(separatedBy: chars).joined(separator: "")
        let result = self == filtered
        return result
    }
    
    // MARK: - 密码校验
    func passwordVerify() -> Bool {
        let chars = NSCharacterSet.init(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_").inverted
        let filtered = self.components(separatedBy: chars).joined(separator: "")
        let result = self == filtered
        return result
    }
    
    // MARK: - 16进制色值码校验
    func colorHexVerify() -> Bool {
        let chars = NSCharacterSet.init(charactersIn: "0123456789abcdefABCDEF").inverted
        let filtered = self.components(separatedBy: chars).joined(separator: "")
        let result = self == filtered
        return result
    }
    
    // 根据字符串计算宽度或高度
    func size(WithFont font: UIFont, ConstrainedToWidth width: CGFloat) -> CGSize {
        
        let size = CGSize.init(width: width, height: 99999.0)
        
        let attributes = [NSAttributedString.Key.font : font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.boundingRect(with: size, options:option, attributes: attributes,context:nil)
        
        return rect.size
    }
    
    func size(WithFont font: UIFont, ConstrainedToHeight height: CGFloat) -> CGSize {
        
        let size = CGSize.init(width: 999999.0, height: height)
        let attributes = [NSAttributedString.Key.font : font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.boundingRect(with: size, options:option, attributes: attributes,context:nil)
        
        return rect.size
    }
    
    /// MARK: - 字符串转换成Date
    func toDate(_ dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        
        let dateFormater = DateFormatter()
        dateFormater.timeZone = TimeZone.current
        dateFormater.locale = Locale.current // Locale(identifier: "zh_CN")
        dateFormater.dateFormat = dateFormat
        let date = dateFormater.date(from: self)
        return date
    }
    
    // MARK: - 获取字符串占多少位
    func getByteLength() ->Int {
        var bytes: [UInt8] = []
        for char in self.utf8 {
            bytes.append(char.advanced(by:0))
        }
        return bytes.count
    }
    
    // MARK: - 计算字符个数（英文 = 1，数字 = 1，汉语 = 2）
    func numberOfChars() -> Int {
        var number = 0
        guard self.count > 0 else {
            return 0
        }
        
        for i in 0...self.count - 1 {
            let c: unichar = (self as NSString).character(at: i)
            if (c >= 0x4E00) {
                number += 2
            }else {
                number += 1
            }
        }
        return number
    }
    
    // MARK: - 根据字符个数返回截取的字符串（英文 = 1，数字 = 1，汉语 = 2）
    func speedySubString(to index: Int) -> String {
        if self.count == 0 {
            return ""
        }
        
        var number = 0
        var strings: [String] = []
        for c in self {
            let subStr: String = "\(c)"
            let num = subStr.numberOfChars()
            
            number += num
            
            if number <= index {
                strings.append(subStr)
            } else {
                break
            }
        }
        
        var resultStr: String = ""
        for str in strings {
            resultStr = resultStr + "\(str)"
        }
        
        return resultStr
    }
    
    // 通用字符串截取，不区分数字、汉字、英文
    func speedyCommonSubString(fromIndex index: Int, endIndex: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: index)
        let end = self.index(self.startIndex, offsetBy: endIndex)
        return String(self[start...end])
    }
    
//    // 字符串的字节数
//    var bytes: Array<UInt8> {
//        if let data = data(using: String.Encoding.utf8, allowLossyConversion: true) {
//            return data.bytes
//        }
//        return Array(utf8)
//    }
//    
//    var bytesCount: Int {
//        return self.bytes.count
//    }
    
    var bytes2: Array<UInt8> {
        var bytes: [UInt8] = []
        
        for char in self.utf8 {
            bytes.append(char.advanced(by: 0))
        }
        return bytes
    }
    
    var bytesCount2: Int {
        
        return self.bytes2.count
    }
    
    func isThisYear(date:Date) -> Bool {
        let calendar = Calendar.current
        let nowCmps = calendar.dateComponents([.year], from: Date())
        let selfCmps = calendar.dateComponents([.year], from: date)
        let result = nowCmps.year == selfCmps.year
        return result
    }
}

// MARK: - 获取汉字的拼音
extension String {
    /// 判断字符串中是否有中文
    func isIncludeChinese() -> Bool {
        for ch in self.unicodeScalars {
            // 中文字符范围：0x4e00 ~ 0x9fff
            if (0x4e00 < ch.value  && ch.value < 0x9fff) {
                return true
            }
        }
        return false
    }
    
    /// 将中文字符串转换为拼音
    /// - Parameter hasBlank: 是否带空格（默认不带空格）
    func transformToPinyin(hasBlank: Bool = false) -> String {
        
        let stringRef = NSMutableString(string: self) as CFMutableString
        // 转换为带音标的拼音
        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false)
        // 去掉音标
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false)
        let pinyin = stringRef as String
        return hasBlank ? pinyin : pinyin.replacingOccurrences(of: " ", with: "")
    }
    
    /// 获取中文首字母
    /// - Parameter lowercased: 是否小写（默认大写）
    func transformToPinyinHead(lowercased: Bool = false) -> String {
        // 字符串转换为首字母大写
        let pinyin = self.transformToPinyin(hasBlank: true).capitalized
        var headPinyinStr = ""
        for ch in pinyin {
            if ch <= "Z" && ch >= "A" {
                // 获取所有大写字母
                headPinyinStr.append(ch)
            }
        }
        return lowercased ? headPinyinStr.lowercased() : headPinyinStr
    }
}


public extension String {
    /// 从url中获取后缀 例：.pdf
    var pathExtension: String {
        guard let url = URL(string: self) else {
            return ""
        }
        return url.pathExtension.isEmpty ? "" : ".\(url.pathExtension)"
    }
}
