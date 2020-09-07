//
//  String+XHEmojiAddtion.swift
//  XCamera
//
//  Created by 管理员 Cc on 2020/8/14.
//  Copyright © 2020 xhey. All rights reserved.
//

import UIKit

enum XHTextMatchType {
    ///电话
    case phone
    ///网址
    case url
}

class XHEmojiManagerd{
    
    static let shared = XHEmojiManagerd()
    
    private var _emojiModels:[XHEmojiModel]?
    var emojiModels:[XHEmojiModel]{
        
        if let emojiModels = _emojiModels {
            return emojiModels
        }
        
        let emojiModels = XHEmojiManagerd.langxiaohuaArr()
        _emojiModels = emojiModels
        return emojiModels
    }
    
    
    private class func langxiaohuaArr()->[XHEmojiModel]{
        
        let path = Bundle.main.path(forResource: "langxiaohua.plist", ofType: nil)
        
        let arr = NSArray.init(contentsOfFile: path ?? "") as? [[String:Any]]

        let emojiModels = [XHEmojiModel].deserialize(from: arr)?.compactMap{$0} ?? [XHEmojiModel]()
        
        return emojiModels
    }
    
    class func attributedString(with emoji:XHEmojiModel,font:UIFont)->NSAttributedString{
        
        let attachMent = XHTextAttachment()
        
        attachMent.image = UIImage.init(named: emoji.emojiIcon)
        attachMent.emojiModel = emoji;
        let lineHeight = font.lineHeight;
        attachMent.bounds = CGRect.init(x: 0, y: -4, width: lineHeight, height: lineHeight)
        
        return NSAttributedString.init(attachment: attachMent)
    }
}

import HandyJSON

struct XHEmojiModel:HandyJSON{
    
    ///emoji字符串
    var emojiStr:String = ""
    ///文本中的图片
    var emojiIcon:String = ""
    ///按钮中的图片
    var emojiImage:String = ""
    ///名字
    var emojiName:String = ""
    ///显示的标题
    var emojiTitle:String = ""
    ///名字 , 1表示是 1图片表情，0表示emoji表情
    var type:Int = -1
}


class XHTextAttachment:NSTextAttachment{
    var emojiModel:XHEmojiModel?
}

public extension String{
    
    /// 富文本转换成 字符串
    func emoticonText()->String{
        
        var contentStr = ""
        /*
         [self.attributedText enumerateAttributesInRange: NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
         
         NSLog(@"attrs = %@, range = %@", attrs, NSStringFromRange(range));
         
         if([attrs[@"NSAttachment"] isKindOfClass:[XHTextAttachment class]])
         {
         XHTextAttachment *attment = (XHTextAttachment *)attrs[@"NSAttachment"];
         [contentStr appendString:attment.emojiModel.emojiName];
         }
         else
         {
         [contentStr appendString: [self.attributedText attributedSubstringFromRange:range].string];
         }
         }];
         */
        return contentStr
    }
    
    ///富文本转换成 字符串
    static func emoticonText(with attributedText:NSAttributedString)->String{
        var contentStr = ""
        
        attributedText.enumerateAttributes(in: NSRange.init(location: 0, length: attributedText.length), options: .init(rawValue: 0)) { (attrs, range, stop) in
            
            if let attachment = attrs[.attachment] as? XHTextAttachment{
                contentStr.append(contentsOf: attachment.emojiModel?.emojiName ?? "")
            }else{
                contentStr.append(contentsOf: attributedText.attributedSubstring(from: range).string)
                
            }
        }
        
        return contentStr
    }
    
    static func handleAttributed(_ contentStr:String?,withYYtext:Bool,font:UIFont)->NSMutableAttributedString{
        
        guard let _contentStr = contentStr,_contentStr.count > 0 else {
            return NSMutableAttributedString.init()
        }
        
        let attributedStr = handleEmoticonAttributed(contentStr: contentStr, withYYtext: withYYtext, font: font)
        
        return attributedStr
        //匹配电话
        //    [self addHighlightedAttributedStr:attributedStr andPattern:SomeConfig.KPhoneNumRegularRule];
        
        //匹配电话和网址
        //    [self addHighlightedAttributedStr:attributedStr andType:CNMatchTypePhone];
        //    [self addHighlightedAttributedStr:attributedStr andType:CNMatchTypeUrl];
    }
    
    ///字符串转换成富文本,是否是YYText 并且不匹配url
    static func handleEmoticonAttributed(contentStr:String?,withYYtext:Bool,font:UIFont)->NSMutableAttributedString{
        
        guard let _contentStr = contentStr,_contentStr.count > 0 else {
            return NSMutableAttributedString.init()
        }
        
        let attributedStr = NSMutableAttributedString.init(string: _contentStr)
        
        let emotionPattern = "\\[{1}[\\u4e00-\\u9fa5]{2}\\]{1}"
        matchingEmotion(contentStr:_contentStr,pattern:emotionPattern, attributedStr: attributedStr,withYYtext:withYYtext,font:font)
        attributedStr.addAttributes([.font:font], range: NSRange.init(location: 0, length: attributedStr.length))
        
        //    CGFloat endTime = [NSDate date].timeIntervalSince1970 * 1000;
        //    NSLog(@"endTime富文本匹配 = %lf", endTime - beginTime);
//        attributedStr.yy_lineBreakMode = .byCharWrapping;
//        attributedStr.yy_lineSpacing = 0;
//        attributedStr.yy_alignment = .justified
        
        return attributedStr
    }
    
    static func matchingEmotion(contentStr:String,pattern:String,attributedStr:NSMutableAttributedString,withYYtext:Bool,font:UIFont){
        
        let regular = try? NSRegularExpression.init(pattern: pattern, options: .init(rawValue: 0))
        
        let _matchArray = regular?.matches(in: contentStr, options: .init(rawValue: 0), range: NSRange.init(location: 0, length: contentStr.count))
        
        guard let matchArray = _matchArray,matchArray.count > 0 else{return}
        
        for result in matchArray.reversed(){
            
            let emojiRange = result.range
            
            let emojiStr = (contentStr as NSString).substring(with: emojiRange)
            
            for emojiModel in XHEmojiManagerd.shared.emojiModels{
                
                if emojiModel.emojiName != emojiStr{
                    continue
                }
                
                var _emoticonAttributedStr:NSAttributedString?
                
                if withYYtext{
                    
//                    _emoticonAttributedStr = NSAttributedString.yy_attachmentString(withContent: UIImage.init(named: emojiModel.emojiIcon), contentMode: .scaleAspectFill, attachmentSize: CGSize.init(width: font.ascender + 5, height: font.ascender + 5), alignTo: font, alignment: .center)
//                }else{
                    _emoticonAttributedStr = XHEmojiManagerd.attributedString(with: emojiModel, font: font)
                }
                
                if let emoticonAttributedStr = _emoticonAttributedStr{
                    attributedStr.replaceCharacters(in: emojiRange, with: emoticonAttributedStr)
                }
                
                break
            }
        }
    }
}

/*
 
 +(void)addHighlightedAttributedStr:(NSMutableAttributedString *)attributedStr andType:(CNMatchType)matchType {
 //  获取富文本对应的字符串
 NSString *statusText = attributedStr.string;
 NSDataDetector *detector = nil;
 NSError *error = nil;
 if (matchType == CNMatchTypePhone) {
 statusText = [statusText stringByReplacingOccurrencesOfString:@"," withString:@"，"];
 detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
 }else {
 detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
 }
 
 NSArray<NSTextCheckingResult *> *matchResultArr = [detector matchesInString:statusText options:0 range:NSMakeRange(0, [statusText length])];
 
 for (NSTextCheckingResult *matchResult in matchResultArr)
 {
 NSRange highLightRange = matchResult.range;
 [self addHighLightWithAttri:attributedStr andHightLightRange:highLightRange];
 }
 }
 
 
 + (void)addHighLightWithAttri:(NSMutableAttributedString *)attributedStr andHightLightRange:(NSRange) highLightRange {
 
 //    [attributedStr addAttributes:@{NSForegroundColorAttributeName: [UIColor hexColor:@"#0000FF"]} range:highLightRange];
 //    [attributedStr addAttribute:NSUnderlineStyleAttributeName value:
 //     [NSNumber numberWithInteger:NSUnderlineStyleSingle] range:highLightRange];
 //    [attributedStr addAttribute:NSUnderlineColorAttributeName value:
 //     [UIColor hexColor:@"#0000FF"] range:highLightRange];
 //
 //    YYTextHighlight *highLight = [[YYTextHighlight alloc] init];
 //    //  点击高亮文字的背景色 abdb31
 //    YYTextBorder *textBorder = [YYTextBorder borderWithFillColor:[UIColor rgbColorWithR:98 g:162 b:248 alpha:0.6] cornerRadius:3];
 //    //  设置边框的内间距
 //    textBorder.insets = UIEdgeInsetsMake(1, 0, 0, 0);
 //    //  设置边框对象
 //    [highLight setBorder:textBorder];
 //    [attributedStr yy_setTextHighlight:highLight range:highLightRange];
 
 }
 
 
 
 /** 插入表情 */
 - (void)insertEmoji:(XHEmojiModel *)emoji {
 if (emoji.type == 1){
 NSMutableAttributedString *lastAttribtedString = [[NSMutableAttributedString alloc] initWithAttributedString: self.attributedText];
 
 NSAttributedString *attrbutedStr = [NSAttributedString attributedStringWithEmoticon:emoji andFont:self.font];
 NSRange selectedRange = self.selectedRange;
 
 [lastAttribtedString replaceCharactersInRange:selectedRange withAttributedString:attrbutedStr];
 
 [lastAttribtedString addAttributes:@{NSFontAttributeName: self.font} range:NSMakeRange(0, lastAttribtedString.length)];
 
 self.attributedText = lastAttribtedString;
 
 selectedRange.location += 1;
 
 selectedRange.length = 0;
 //        NSLog(@"selectedRange = %@", NSStringFromRange(selectedRange));
 self.selectedRange = selectedRange;
 }else {
 [self insertText:emoji.emojiStr];
 }
 [self  scrollRangeToVisible:self.selectedRange];
 }
 
 @end
 
 */
