//
//  HintTextStyle.swift
//  ShowHint
//
//  Created by Swaying on 2017/12/14.
//  Copyright © 2017年 xhey. All rights reserved.
//

import UIKit

enum HintTextStyle {
    case white
    case custom(font: UIFont, textColor: UIColor)
    case textWithImage(font: UIFont, textColor: UIColor, image:String)
    case textWithImageTypeOne(image:String)

    func textView() -> HintTextView {
        switch self {
        case .white:
            let font = UIFont.boldSystemFont(ofSize: 18)
            return styleTextView(font: font, textColor: UIColor.white)
        case .custom(let font, let textColor):
            return styleTextView(font: font, textColor: textColor)
        case .textWithImage(let font, let textColor, let image):
            return styleTextView(font: font, textColor: textColor, image: image)
        case .textWithImageTypeOne(let image):
            return styleTextView(font: UIFont.boldSystemFont(ofSize: 16), textColor: UIColor.black, image: image)
        }
    }
    
    private func styleTextView(font: UIFont, textColor: UIColor) -> HintTextView {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = textColor
        label.font = font
        label.textAlignment = .center
        label.numberOfLines = 0
        label.layer.shadowColor = UIColor(white: 0.0, alpha: 0.4).cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 10
        label.layer.shadowOpacity = 1.0
        label.layer.opacity = 0
        return label
    }
    private func styleTextView(font: UIFont, textColor: UIColor, image:String) -> HintTextView {
        let view = HintImageWithTitleView(frame: CGRect(x: 0, y: 0, width: 175, height: 100))
        view.backgroundColor = UIColor.clear
        view.image = image
        view.textLabel?.textColor = textColor
        view.textLabel?.textAlignment = .center
        view.textLabel?.font = font
        view.textLabel?.numberOfLines = 0
        view.layer.shadowColor = UIColor.UIColorFromRGBA(0, g: 0, b: 0, a: 0.25).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 14)
        view.layer.shadowRadius = 30
        view.layer.shadowOpacity = 1.0
        
        return view
    }
}
