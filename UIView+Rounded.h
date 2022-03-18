

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Rounded)
#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;
/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;


/**
 添加周边阴影

 @param color 颜色
 @param shadowOpacity 透明度
 @param width 宽
 */
- (void)addShadowWithColor:(UIColor *)color shadowOpacity:(CGFloat)shadowOpacity width:(CGFloat)width cornerRadius:(CGFloat)cornerRadius;

//添加四边阴影效果
-(void)addFourSidesShadowWithColor:(UIColor*)theColor shadowOpacity:(CGFloat)shadowOpacity cornerRadius:(CGFloat)cornerRadius;
@end


NS_ASSUME_NONNULL_END
