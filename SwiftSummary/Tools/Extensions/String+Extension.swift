//
//  String+Extension.swift
//  TestForSpeech
//
//  Created by EdwardD on 2017/10/17.
//  Copyright © 2017年 Edward. All rights reserved.
//

import Foundation

let punctuationSet = "＃，？@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\",.，。？:“”！（）()!《》【】「」…?"

extension String {

    static var uniqueString: String {
        let dataString: String = "\(Int64(Date().timeIntervalSince1970 * 1000))"
        let randomString: String = "\(arc4random_uniform(1000))"
        return dataString + randomString
    }
    static var uniqueOrderString: String {
        let dataString: String = "\(Int64(Date().timeIntervalSince1970 * 1000))"
        let staticStr: String = "XHCamera"
        return staticStr + dataString
    }
    
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    
 var md5: String {
//        let str = self.cString(using: String.Encoding.utf8)
//        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
//        CC_MD5(str!, strLen, result)
//        let hash = NSMutableString()
//        for i in 0 ..< digestLen {
//            hash.appendFormat("%02x", result[i])
//        }
//        result.deallocate()
//
//        return String(format: hash as String)
        return md5()
    }
    
    func parametersFromQueryString() -> Dictionary<String, String> {
        var parameters = Dictionary<String, String>()
        
        let scanner = Scanner(string: self)
        
        var key: NSString?
        var value: NSString?
        
        while !scanner.isAtEnd {
            key = nil
            scanner.scanUpTo("=", into: &key)
            scanner.scanString("=", into: nil)
            
            value = nil
            scanner.scanUpTo("&", into: &value)
            scanner.scanString("&", into: nil)
            
            if (key != nil && value != nil) {
                parameters.updateValue(value! as String, forKey: key! as String)
            }
        }
        
        return parameters
    }
    
    
    func toPinyinString() -> String {
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let str = String(mutableString)
        return str
    }
    
    func toCharacterArray() -> [Character] {
        return Array(self)
    }
    
    func toPinyinArray() -> [String] {
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        return string.components(separatedBy: " ")
    }
    
    func toPinyinCharacterArray() -> [[Character]] {
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        return string.components(separatedBy: " ").map{ $0.toCharacterArray() }
    }
    
//    func toPinyinData() -> [PinyinData] {
//        var datas = [PinyinData]()
//        var substr: String = ""
//        for (index, char) in self.characters.enumerated() {
//            if char.isEnglishLetter {
//                substr.append(char)
//            } else if substr != "" {
//                let data = PinyinData(origin: substr, originRange: NSMakeRange(index - substr.characters.count, substr.characters.count), pinyin: substr)
//                datas.append(data)
//                substr = ""
//            }
//            
//            if (!char.isEnglishLetter && char != " ") {
//                let str = String(char)
//                let pinyin: String
//                if (char.isNumber) {
//                    switch char {
//                    case "0":
//                        pinyin = "ling"
//                    case "1":
//                        pinyin = "yi"
//                    case "2":
//                        pinyin = "er"
//                    case "3":
//                        pinyin = "san"
//                    case "4":
//                        pinyin = "si"
//                    case "5":
//                        pinyin = "wu"
//                    case "6":
//                        pinyin = "liu"
//                    case "7":
//                        pinyin = "qi"
//                    case "8":
//                        pinyin = "ba"
//                    case "9":
//                        pinyin = "jiu"
//                    default:
//                        pinyin = str.toPinyinString()
//                    }
//                } else {
//                    pinyin = str.toPinyinString()
//                }
//                let data = PinyinData(origin: str, originRange: NSMakeRange(index, 1), pinyin: pinyin)
//                datas.append(data)
//            }
//            
//        }
//        
//        if substr != "" {
//            let data = PinyinData(origin: substr, originRange: NSMakeRange(self.characters.count - substr.characters.count, substr.characters.count), pinyin: substr)
//            datas.append(data)
//            substr = ""
//        }
//        
//        return datas
//    }
    
    func removePunctuation() -> String {
        var newStr = ""
        for c in self {
            let s = String(c)
            if !punctuationSet.contains(s) {
                newStr += s
            }
        }
        return newStr
    }
    func QuinnSubString(to index: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    
    func QuinnSubString(from index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }
    
    // MARK: - 表情编码
    func emojiEncode() -> String {
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    // MARK: - 表情解码
    func emojiDecode() -> String? {
        let data = self.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
    
    var containEmoji: Bool {
        // http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x1F1E6...0x1F1FF, // Regional country flags
            0x2600...0x26FF, // Misc symbols
            0x2700...0x27BF, // Dingbats
            0xE0020...0xE007F, // Tags
            0xFE00...0xFE0F, // Variation Selectors
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            127000...127600, // Various asian characters
            65024...65039, // Variation selector
            9100...9300, // Misc items
            8400...8447: // Combining Diacritical Marks for Symbols
                return true
            default:
                continue
            }
        }
        return false
    }
    
    // 移除表情
    func removeEmoji() -> String {
        do {
            let regex = try NSRegularExpression(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: NSRegularExpression.Options.caseInsensitive)
            
            let modifiedString = regex.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
            return modifiedString
        } catch {
            print(error)
        }
        return ""
    }
    
    // MARK: - 判断是不是九宫格
    func isNineKeyBoard() -> Bool{
        let other : NSString = "➋➌➍➎➏➐➑➒"
        let len = self.count
        for _ in 0 ..< len {
            if !(other.range(of: self).location != NSNotFound) {
                return false
            }
        }
        
        return true
    }
    
    
    //当URL字符串种带中文时，必须先进行编码，否则 URL(string:urlStr)会返回 nil
    func xhAddPercentEncode() -> String {
            
            var charset = CharacterSet.urlQueryAllowed
            charset.remove(charactersIn: "+")
    //        charset.remove(charactersIn: "=")
            return self.removingPercentEncoding?.addingPercentEncoding(withAllowedCharacters:charset) ?? ""
    }
    
    // MARK: - 通过毫秒的字符串获取日期时间
    func getDateTimeByMilliStr() -> String {
        
        let currentTimeStamp = Date().toTimeStamp_ms_int()
        if let lastTimeStamp = Int(self){
            let diff = (currentTimeStamp - lastTimeStamp) / 1000
            if diff < 60{
                return "刚刚"
            }else {
                let minute = diff/60
                if minute >= 1 , minute < 60{
                    return "\(minute)分钟前"
                }else{
                    let hour = minute/60
                    if hour >= 1,hour < 24{
                        return "\(hour)小时前"
                    }else{
                        let date = Date(timeIntervalSince1970: self.doubleValue / 1000)
                        if isThisYear(date:date){
                            return getFormatterDate(date, dateFormat: "M月d日 HH:mm")
                        }else{
                            return getFormatterDate(date, dateFormat: "yyyy年M月d日 HH:mm")
                        }
                    }
                }
            }
        }
        return ""
    }
    
    // MARK: - 通过秒的字符串获取日期时间
    func getDateTimeBySecondsStr() -> String {
        
        let currentTimeStamp = Date().toTimeStamp_second_int()
        
        if let lastTimeStamp = Int(self){
            let diff = currentTimeStamp - lastTimeStamp
            
            if diff < 60{
                return "刚刚"
            }else {
                let minute = diff/60
                if minute >= 1 , minute < 60{
                    return "\(minute)分钟前"
                }else{
                    let hour = minute/60
                    if hour >= 1,hour < 24{
                        return "\(hour)小时前"
                    }else{
                        let date = Date(timeIntervalSince1970: self.doubleValue)
                        if isThisYear(date:date){
                            return getFormatterDate(date, dateFormat: "M月d日 HH:mm")
                        }else{
                            return getFormatterDate(date, dateFormat: "yyyy年M月d日 HH:mm")
                        }
                    }
                }
            }
        }
        return ""
    }
    
    
    // MARK: - 获取日期字符串，当是今天的时候，返回：今天+日期
    func getSpecialDateString(_ date: Date, dateFormat:String) -> String {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = dateFormat
        if XHTimeManager.shared.isGpsInChina{
            dateFormater.timeZone = TimeZone.init(identifier: "Asia/Shanghai")
            dateFormater.locale = Locale(identifier: "zh_CN")
        }else{
            dateFormater.timeZone = TimeZone.current
            dateFormater.locale = Locale.current
        }
        var resultStr = dateFormater.string(from: date)
        let istoday = NSCalendar.current.isDateInToday(date)
        if  istoday {
            resultStr = "今天 " + resultStr
        }
        return resultStr
    }

    //通过字符串获取日期
    func getDateFromString(dateString:String,formatterString:String) -> Date? {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = formatterString
        if XHTimeManager.shared.isGpsInChina{
            dateFormater.timeZone = TimeZone.init(identifier: "Asia/Shanghai")
            dateFormater.locale = Locale(identifier: "zh_CN")
        }else{
            dateFormater.timeZone = TimeZone.current
            dateFormater.locale = Locale.current
        }
        let date = dateFormater.date(from: dateString)
        return date
    }

    //获取日期字符串
    func getFormatterDate(_ date: Date,dateFormat:String) -> String {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = dateFormat
        if XHTimeManager.shared.isGpsInChina{
            dateFormater.timeZone = TimeZone.init(identifier: "Asia/Shanghai")
            dateFormater.locale = Locale(identifier: "zh_CN")
        }else{
            dateFormater.timeZone = TimeZone.current
            dateFormater.locale = Locale.current
        }
        return dateFormater.string(from: date)
    }

}


