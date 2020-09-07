//
//  FileManager+Extension.swift
//  XCamera
//
//  Created by Swaying on 2017/12/14.
//  Copyright © 2017年 xhey. All rights reserved.
//

import Foundation

extension FileManager {
    
    func removeURLs(_ urls: [URL]) {
        urls.forEach { (url) in
            do {
                try removeItem(at: url)
            } catch {
//               XHPrint("Edward FileManager+Extension removeURLs error:\(error)")
            }
        }
    }
}
