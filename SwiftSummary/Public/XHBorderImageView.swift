//
//  XHBorderImageView.swift
//  XCamera
//
//  Created by 赵刚 on 2020/3/10.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit
import Kingfisher

class XHBorderImageView: UIView {
    
    var imageView: UIImageView?
    var borderWidth: CGFloat = 2
    
    var image: UIImage? {
        didSet {
            imageView?.image = self.image
        }
    }
    
    var urlStr: String? {
        didSet {
            if let urlString = urlStr,
                let url = URL(string: urlString) {
                KingfisherManager.shared.retrieveImage(with: url, options: [KingfisherOptionsInfoItem.cacheOriginalImage], progressBlock: nil){ (result) in
                    switch result {
                    case .success(let value):
                        self.imageView?.image = value.image
                    default: break
                    }
                }
            }
        }
    }
    
    var imageData: Data? {
        didSet {
            if let data = imageData, let aImage = UIImage(data: data) {
                imageView?.image = aImage
            }
        }
    }
    
    init(borderWidth: CGFloat = 2) {
        self.borderWidth = borderWidth
        super.init(frame: CGRect.zero)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.borderWidth = 2
        buildUI()
    }
    
    private func buildUI() {
        self.backgroundColor = UIColor.white
        
        imageView = UIImageView()
        imageView?.contentMode = .scaleAspectFit
        imageView?.backgroundColor = UIColor.white
        self.addSubview(imageView!)
        
        imageView?.snp.makeConstraints({ (make) in
            make.top.left.equalTo(self.borderWidth)
            make.right.bottom.equalTo(-self.borderWidth)
        })
    }
}
