//
//  UIColor+Hex.h
//  hotel
//
//  Created by dim on 16/10/11.
//  Copyright © 2016年 lihui. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]
@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorBlack;
+ (UIColor *)lineColor;
//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
