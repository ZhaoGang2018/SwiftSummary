//
//  URL+Extension.swift
//  XCamera
//
//  Created by EdwardD on 2017/10/20.
//  Copyright © 2017年 xhey. All rights reserved.
//

import Foundation

extension URL {
    func checkCreateFolder() {
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(at: self, withIntermediateDirectories: true, attributes: nil)
        }
    }
}
