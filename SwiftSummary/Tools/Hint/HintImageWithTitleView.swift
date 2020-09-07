//
//  HintImageWithTitleView.swift
//  XCamera
//
//  Created by Quinn_F on 2018/1/13.
//  Copyright © 2018年 xhey. All rights reserved.
//

import UIKit

class HintImageWithTitleView: UIView {
    var image: String? {
        didSet {
            imageView?.image = UIImage(named: image ?? "")
        }
    }
    
    private var imageView: UIImageView?
    private var shadowView: UIView?
    
    var textLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updataUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func updataUI() {
        
        shadowView = UIView()
        shadowView?.backgroundColor = UIColor.white
        shadowView?.frame = CGRect(x: 0, y: 0, width: 175, height: 100)
        shadowView?.layer.masksToBounds = true
        shadowView?.layer.cornerRadius = 10
        addSubview(shadowView!)
        
        let imageSize: CGFloat = 34
        imageView = UIImageView(frame: CGRect(x: (width-imageSize)*0.5,
                                              y: 18,
                                              width: imageSize,
                                              height: imageSize))
        imageView?.image = UIImage(named: image ?? "")
        addSubview(imageView!)
        
        textLabel = UILabel()
        let textX = (width-imageSize)*0.5
        let textY = imageView!.bottom+12
        textLabel?.frame = CGRect(x: textX, y: textY, width: 10, height: 16)
        addSubview(textLabel!)
    }
}
extension HintImageWithTitleView: HintTextView{
    var text: String? {
        get {
            return textLabel?.text
        }
        set {
            textLabel?.text = newValue
        }
    }
    override func sizeToFit() {
        super.sizeToFit()
        let originalCenter = center
        var imageSize = CGSize()
        if let image = imageView?.image {
            imageSize = image.size
            imageView?.frame.size = imageSize
        }
        width = imageSize.width + 140
        imageView?.centerX = centerX
        textLabel?.width = width - 50
        textLabel?.sizeToFit()
        textLabel?.centerX = centerX
        if let bottom = imageView?.bottom{
            textLabel?.frame.origin.y = bottom + 12
        }
        height = imageSize.height + textLabel!.height + 18 + 12 + 20
        center = originalCenter
        shadowView?.frame = bounds

    }
    func view() -> UIView {
        return self
    }
}

