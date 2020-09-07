//
//  XHTimeManager+Festival.swift
//  XCamera
//
//  Created by jing_mac on 2020/2/24.
//  Copyright © 2020 xhey. All rights reserved.
//

import Foundation

private let zodiacs: [String] = ["mouse", "cow", "tiger", "rabbit", "dragon", "snake", "horse", "sheep", "monkey", "chicken", "dog", "pig"]
private let zodiacs_chi: [String] = ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"]

// MARK: - 节日和属相
extension XHTimeManager {
    
    func getZodiacByDate(_ date:Date,chinese:Bool = true)->String{
        let index = ChineseCalendar().zodiacIndex(date: date)
        if chinese{
            return zodiacs_chi[index]
            
        }
        return zodiacs[index]
    }
    
    func getChineseFormatterDate(_ date: Date,dateFormat:String) -> String {
        let lunarCalendar = Calendar.init(identifier:.chinese)
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "zh_CN")
        dateFormater.dateStyle = .medium
        dateFormater.calendar = lunarCalendar
        dateFormater.dateFormat = dateFormat
        
        return dateFormater.string(from: date)
    }
    
    func festivalDate(date:String)->String{
        var str = date
        if (str == "七月初七") {
            str = "七夕节"
        } else if (str == "腊月三十") {
            str = "除 夕"
        } else if (str == "正月初一") {
            str = "春 节"
        } else if (str == "正月十五") {
            str = "元宵节"
        }else if (str == "五月初五") {
            str = "端午节"
        } else if (str == "七月十五") {
            str = "中元节"
        } else if (str == "八月十五") {
            str = "中秋节"
        } else if (str == "九月初九") {
            str = "重阳节"
        } else if (str == "腊月初八") {
            str = "腊八节"
        } else if (str == "腊月廿三") {
            str = "小 年"
        }
        
        return str
    }
    
}

