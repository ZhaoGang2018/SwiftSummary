//
//  NSAttributedString+Extension.swift
//  XCamera
//
//  Created by Quinn Von on 2020/4/23.
//  Copyright © 2020 xhey. All rights reserved.
//

#if canImport(Foundation)
import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(Cocoa)
import Cocoa
#endif

// MARK: - Properties
public extension NSAttributedString {

    #if os(iOS)
    /// 加粗
    var bolded: NSAttributedString {
        return applying(attributes: [.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
    }
    #endif

    /// 下划线
    var underlined: NSAttributedString {
        return applying(attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }

    #if os(iOS)
    /// 斜体
    var italicized: NSAttributedString {
        return applying(attributes: [.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
    }
    #endif

    /// 删除线
    var struckthrough: NSAttributedString {
        return applying(attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)])
    }
    /// 富文本属性的字典
    var attributes: [NSAttributedString.Key: Any] {
        return attributes(at: 0, effectiveRange: nil)
    }

    
    
}

// MARK: - Methods
public extension NSAttributedString {

    /// 应用后的字符串
    ///
    /// - Parameter attributes: Dictionary of attributes
    /// - Returns: NSAttributedString with applied attributes
    fileprivate func applying(attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        let range = (string as NSString).range(of: string)
        copy.addAttributes(attributes, range: range)

        return copy
    }

    #if os(macOS)
    /// SwifterSwift: Add color to NSAttributedString.
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString colored with given color.
    public func colored(with color: NSColor) -> NSAttributedString {
        return applying(attributes: [.foregroundColor: color])
    }
    #else
    /// 文字颜色
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString colored with given color.
    func colored(with color: UIColor) -> NSAttributedString {
        return applying(attributes: [.foregroundColor: color])
    }
    /// 背景色
    func backgroundColored(with color: UIColor) -> NSAttributedString {
        return applying(attributes: [.backgroundColor: color])
    }
    /// 文字间距
    func spaceText(space:Double) -> NSAttributedString{
        return applying(attributes: [.kern: space])
    }
    /// 行间距
    func spaceLine(space:CGFloat,alignment:NSTextAlignment = .left) -> NSAttributedString{
        let style = NSMutableParagraphStyle()
        style.lineSpacing = space
        style.alignment = alignment
        return applying(attributes: [.paragraphStyle: style])
    }
    /// 文字大小
    func font(name:String,size:CGFloat) -> NSAttributedString{
        let font = UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
        return applying(attributes: [.font: font])
    }
    /// 描边
    /*
     *NSStrokeWidthAttributeName,该值改变笔画宽度（相对于字体 size 的百分比），负值填充效果，正值中空效果，默认为 0，即不改变。正数只改变描边宽度。负数同时改变文字的描边和填充宽度。例如，对于常见的空心字，这个值通常为 3.0。
              同时设置了空心描边和文字前景两个属性，并且NSStrokeWidthAttributeName 属性设置为整数，文字前景色就无效果了
     链接：https://www.jianshu.com/p/54d55a77cc3d
     */
    func stroke(width:CGFloat,color:UIColor,outside:Bool) -> NSAttributedString{
        if outside{
            return applying(attributes: [.strokeWidth: abs(width),.strokeColor:color])
        }else{
            return applying(attributes: [.strokeWidth: -abs(width),.strokeColor:color])
        }
    }
    #endif

    /// 将属性应用于匹配正则表达式的子字符串
    ///
    /// - Parameters:
    ///   - attributes: Dictionary of attributes
    ///   - pattern: a regular expression to target
    /// - Returns: An NSAttributedString with attributes applied to substrings matching the pattern
    func applying(attributes: [NSAttributedString.Key: Any], toRangesMatching pattern: String) -> NSAttributedString {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: []) else { return self }

        let matches = pattern.matches(in: string, options: [], range: NSRange(0..<length))
        let result = NSMutableAttributedString(attributedString: self)

        for match in matches {
            result.addAttributes(attributes, range: match.range)
        }

        return result
    }

    /// 对给定字符串的出现应用属性
    ///
    /// - Parameters:
    ///   - attributes: Dictionary of attributes
    ///   - target: a subsequence string for the attributes to be applied to
    /// - Returns: An NSAttributedString with attributes applied on the target string
    func applying<T: StringProtocol>(attributes: [NSAttributedString.Key: Any], toOccurrencesOf target: T) -> NSAttributedString {
        let pattern = "\\Q\(target)\\E"

        return applying(attributes: attributes, toRangesMatching: pattern)
    }

}

// MARK: - Operators
public extension NSAttributedString {

    /// 富文本拼接
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: NSAttributedString to add.
    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        lhs = string
    }

    /// 富文本拼接
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: NSAttributedString to add.
    /// - Returns: New instance with added NSAttributedString.
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        return NSAttributedString(attributedString: string)
    }

    /// 富文本拼接
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: String to add.
    static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }

    /// 富文本拼接
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: String to add.
    /// - Returns: New instance with added NSAttributedString.
    static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        return lhs + NSAttributedString(string: rhs)
    }

}
#endif
