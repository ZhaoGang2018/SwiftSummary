//
//  RealmModel.swift
//  XCamera
//
//  Created by Quinn on 2018/12/12.
//  Copyright © 2018 xhey. All rights reserved.
//

import Foundation
import RealmSwift

class WaterBabyInfo: Object {
    @objc dynamic var id : Int = -1
    @objc dynamic var name : String = ""
    @objc dynamic var birth : String = ""
    @objc dynamic var height : String = ""
    @objc dynamic var weight : String = ""
    @objc dynamic var horoscope : String = ""
    @objc dynamic var zodiac : String = ""
    @objc dynamic var introduce : String = ""
    @objc dynamic var title : String = ""
    @objc dynamic var waterControlModel : BabyInfoWaterControlModel? = nil

    override static func primaryKey() -> String? {
        return "id"
    }
}

class BabyInfoWaterControlModel: Object {
    @objc dynamic var openHeight : Bool = false
    @objc dynamic var openweight : Bool = false
    @objc dynamic var openHoroscope : Bool = true   // 星座
    @objc dynamic var openZodiac : Bool = false     //生肖
    @objc dynamic var openIntroduce : Bool = true
    @objc dynamic var openLocation : Bool = true
}


class UploaStatue: Object,Codable {
    @objc dynamic var close_all : Bool = false
    @objc dynamic var user_open : Bool = false
}

class LatitudeAndLongitudeWatermarkModel:Object,Codable{
    @objc dynamic var isFirst : Bool = true
    @objc dynamic var openPhoneNumber : Bool = false
    @objc dynamic var phoneNumber : String = ""
    @objc dynamic var openLatLng : Bool = true
    @objc dynamic var openLocation : Bool = true
    @objc dynamic var openTime : Bool = true
    @objc dynamic var openOther : Bool = false
    @objc dynamic var other : String = ""
}

