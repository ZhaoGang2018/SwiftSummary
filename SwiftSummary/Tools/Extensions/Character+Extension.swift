//
//  Character+Extension.swift
//  TestForSpeech
//
//  Created by EdwardD on 2017/10/17.
//  Copyright © 2017年 Edward. All rights reserved.
//

import Foundation

extension Character {
    var isEnglishLetter: Bool {
        return (self >= "a" && self <= "z") || (self >= "A" && self <= "Z")
    }
    
    var isNumber: Bool {
        return self >= "0" && self <= "9"
    }
}
