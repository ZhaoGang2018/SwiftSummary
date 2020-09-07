//
//  SpeedyClass.swift
//  XCamera
//
//  Created by jing_mac on 2020/3/21.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit

class SpeedyClass: NSObject {
    
    // MARK: - 获取类名
    class func getClassName(object: AnyObject) -> String {
        let name =  type(of: object).description()
        if(name.contains(".")){
            return name.components(separatedBy: ".")[1];
        }else{
            return name;
        }
    }
}

   
