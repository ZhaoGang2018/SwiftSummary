//
//  ZGStoryboardFirstViewController.swift
//  SwiftSummary
//
//  Created by jing_mac on 2020/6/22.
//  Copyright © 2020 jing_mac. All rights reserved.
//

import UIKit
import ImageIO

class ZGStoryboardFirstViewController: XHBaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "storyboard-1"
//        test()
        test2()
    }
    
    
    private func test() {
        
        DispatchQueue.global().async {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 414.0, height: 60000.0), false, 0.0)
            
            for i in 0..<50 {
                let path = SpeedySandbox.shared.documentDirectory + "/" + "06.JPG"
                if let data = FileManager.default.contents(atPath: path), let image = UIImage(data: data) {
                    image.draw(in: CGRect(x: 0, y: 400*i, width: 414, height: 400))
                }
                XHLogInfo("[拼接图片] - [第\(i)张]")
            }
            
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
        }
    }
    
}

extension ZGStoryboardFirstViewController{
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
    }
    
    
   
    
}


extension ZGStoryboardFirstViewController{
    
    private func test2() {
        
        let b = BClass()
        
        let result1 = b.isKind(of: AClass.self) // true
        let result2 = b.isKind(of: BClass.self) // true
        
        let result3 = b.isMember(of: AClass.self) // false
        let result4 = b.isMember(of: BClass.self) // true
        
        print("\(result1) - \(result2) - \(result3) - \(result4)")
    }
}


class AClass: NSObject {
    
}

class BClass: AClass {
    
}
