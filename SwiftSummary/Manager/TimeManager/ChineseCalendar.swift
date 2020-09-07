//
//  ChineseCalendar.swift
//  XCamera
//
//  Created by Swaying on 2018/2/8.
//  Copyright © 2018年 xhey. All rights reserved.
//

import Foundation

class ChineseCalendar {
    
    let calendar: Calendar = Calendar(identifier: .chinese)
    
    private let zodiacs: [String] = ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"]
    private let heavenlyStems: [String] = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
    private let earthlyBranches: [String] = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
    private let months: [String] = ["正月","贰月","叁月","肆月","伍月","陆月","柒月","捌月","玖月","拾月","拾壹月","腊月"]
    private let days: [String] = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十","十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十","廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十", "三十一"]
    
    //获取阳历对应农历 - 如：1223
    func monthDayString(date: Date) -> String {
        
        let day = calendar.component(.day, from: date)
        let dayIndex = (day - 1) % days.count
        var dayString = ""
        if dayIndex < 10 {
            dayString = "0\(dayIndex+1)"
        }else{
            dayString = "\(dayIndex+1)"
        }
        
        let month = calendar.component(.month, from: date)
        let monthIndex = (month - 1) % months.count
        var monthString = ""
        if monthIndex < 10 {
            monthString = "0\(monthIndex+1)"
        }else{
            monthString = "\(monthIndex+1)"
            
        }
        return monthString + dayString
    }
    
    func dayString(date: Date) -> String {
        let day = calendar.component(.day, from: date)
        return dayString(day: day)
    }
    
    func monthString(date: Date) -> String {
        let month = calendar.component(.month, from: date)
        return monthString(monthNum: month)
    }
    
    func zodiac(date: Date) -> String {
        let year = calendar.component(.year, from: date)
        return zodiac(withYear: year)
    }
    
    func zodiacIndex(date: Date) -> Int {
        let year = calendar.component(.year, from: date)
        return zodiacIndex(withYear: year)
    }
    
    func era(withDate date: Date) -> String {
        let year = calendar.component(.year, from: date)
        return era(withYear: year)
    }
    
    private func dayString(day: Int) -> String {
        let dayIndex = (day - 1) % days.count
        return days[dayIndex]
    }
    
    private func monthString(monthNum: Int) -> String {
        let monthIndex = (monthNum - 1) % months.count
        return months[monthIndex]
    }
    
    private func zodiac(withYear year: Int) -> String {
        let zodiacIndex: Int = (year - 1) % zodiacs.count
        return zodiacs[zodiacIndex]
    }
    private func zodiacIndex(withYear year: Int) -> Int {
        let zodiacIndex: Int = (year - 1) % zodiacs.count
        return zodiacIndex
    }
    
    private func era(withYear year: Int) -> String {
        let heavenlyStemIndex: Int = (year - 1) % heavenlyStems.count
        let heavenlyStem: String = heavenlyStems[heavenlyStemIndex]
        let earthlyBrancheIndex: Int = (year - 1) % earthlyBranches.count
        let earthlyBranche: String = earthlyBranches[earthlyBrancheIndex]
        return heavenlyStem + earthlyBranche
    }
}
