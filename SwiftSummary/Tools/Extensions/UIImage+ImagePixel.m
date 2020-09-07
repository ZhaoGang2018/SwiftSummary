//
//  UIImage+ImagePixel.m
//  XCamera
//
//  Created by lzw on 2020/8/24.
//  Copyright © 2020 xhey. All rights reserved.
//

#import "UIImage+ImagePixel.h"

@implementation UIImage (ImagePixel)

#pragma mark - 修正图片方向
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp) {
        return aImage;
    }
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


+(UIImage*)imageWithImage:(UIImage*)    aImage scale:(CGFloat) aScale
{
    
    CGSize aImageSize=aImage.size;
    
    CGSize aSize=CGSizeMake(aImageSize.width/aScale, aImageSize.height/aScale);
    
    UIGraphicsBeginImageContextWithOptions(aSize,NO,aScale);
    [aImage drawInRect:CGRectMake(0, 0, aSize.width, aSize.height)];
    UIImage* mOutputImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return mOutputImage;
    
}

- (NSString *)base64String {
    NSData *data = UIImageJPEGRepresentation(self, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

-  (BOOL)checkAlphaComponent:(CGFloat)percent {
    
    CGImageRef imgref = self.CGImage;
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imgref);
    CGImageAlphaInfo alphaInfo = bitmapInfo & kCGBitmapAlphaInfoMask;
//    CGBitmapInfo bitmapInfoOrder = bitmapInfo & kCGBitmapByteOrderMask;
    
//    int bytePerChannel = 4;
//    if (bitmapInfoOrder == kCGBitmapByteOrder16Little || bitmapInfoOrder == kCGBitmapByteOrder16Big) {
//        bytePerChannel = 8;
//    } else if (bitmapInfoOrder == kCGBitmapByteOrder32Little || bitmapInfoOrder == kCGBitmapByteOrder32Big) {
//       bytePerChannel = 8;
//    }
    // isRGBA
    BOOL islast = NO;
    if (alphaInfo == kCGImageAlphaPremultipliedLast || alphaInfo == kCGImageAlphaLast) {
        islast = YES;
    } else if (alphaInfo == kCGImageAlphaPremultipliedFirst || alphaInfo == kCGImageAlphaFirst) {
        islast = NO;
    } else if (alphaInfo == kCGImageAlphaOnly){
        return YES;
    } else {
        return NO;
    }
    
    size_t width = CGImageGetWidth(imgref);
    size_t height = CGImageGetHeight(imgref);
    size_t bytesPerRow = CGImageGetBytesPerRow(imgref);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imgref);
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imgref);
    if (dataProvider == NULL) return NO;
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    if (data == NULL) return NO;
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);// 图片数据的首地址
    if (buffer == NULL) return NO;
    
    int alphaPixelCount = 0;
    float finalNum = percent*width*height;
    BOOL flag = NO;
    
    for (int j = 0; j < height; j++) {
        if (flag) {
            break;
        }
        for (int i = 0; i < width; i++) {
            UInt8 *pt = buffer + j * bytesPerRow + i * (bitsPerPixel/8);
//            UInt8  alpha = *(pt+3);
            uint32_t alpha = 0;
            if (bitsPerPixel/8 == 4) {
                alpha = islast ? *(uint8_t*)(pt+3) : *(uint8_t*)(pt+0);
            } else if (bitsPerPixel/8 == 8) {
                alpha = islast ? *(uint16_t*)(pt+6) : *(uint16_t*)(pt+0);
            } else if (bitsPerPixel/8 == 16) {
                alpha = islast ? *(uint32_t*)(pt+12) : *(uint32_t*)(pt+0);
            }
            if (alpha == 0) {
                alphaPixelCount += 1;
            }
            if (alphaPixelCount > finalNum) {
                flag = YES;
                break;
            }
        }
    }
   

//    float a = (float)alphaPixelCount/(float)(width*height);
//    NSLog(@"alpha:%f",a);
    CFRelease(data);
    return flag;
}
    
@end
