//
//  UIImage+ImagePixel.h
//  XCamera
//
//  Created by lzw on 2020/8/24.
//  Copyright © 2020 xhey. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ImagePixel)

- (BOOL)checkAlphaComponent:(CGFloat)percent;
+ (UIImage *)fixOrientation:(UIImage *)aImage;
@end

NS_ASSUME_NONNULL_END
