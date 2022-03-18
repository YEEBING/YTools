

#import "UIView+Rounded.h"

@implementation UIView (Rounded)

#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii {
    [self layoutIfNeeded];//这句代码很重要，不能忘了
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect {
    [self layoutIfNeeded];//这句代码很重要，不能忘了
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

/**
 添加周边阴影
 
 @param color 颜色
 @param shadowOpacity 透明度
 @param width 阴影宽
 */
- (void)addShadowWithColor:(UIColor *)color shadowOpacity:(CGFloat)shadowOpacity width:(CGFloat)width cornerRadius:(CGFloat)cornerRadius{
    [self layoutIfNeeded];//这句代码很重要，不能忘了
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOpacity = shadowOpacity;
    // 设置阴影的路径 此处效果为在view周边添加宽度为4的阴影效果
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-width, -width, self.frame.size.width + 2*width, self.frame.size.height + 2*width) cornerRadius:cornerRadius];
    self.layer.shadowPath = path.CGPath;
}


//添加四边阴影效果
-(void)addFourSidesShadowWithColor:(UIColor*)theColor shadowOpacity:(CGFloat)shadowOpacity cornerRadius:(CGFloat)cornerRadius{
    //阴影颜色
    self.layer.shadowColor = theColor.CGColor;
    //阴影偏移
    self.layer.shadowOffset = CGSizeZero;
    //阴影透明度，默认0
    self.layer.shadowOpacity = shadowOpacity;
    //阴影半径，默认3
    self.layer.shadowRadius = cornerRadius;
    
    self.layer.masksToBounds = NO;
}
//在顶部添加阴影
-(void)addSingleSidesShadowToView:(UIView *)theView withColor:(UIColor*)theColor{
    theView.layer.masksToBounds = NO;
    //阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    //阴影偏移
    theView.layer.shadowOffset = CGSizeMake(0, 0 );
    //阴影透明度，默认0
    theView.layer.shadowOpacity = 0.3;
    //阴影半径，默认3
    theView.layer.shadowRadius = 8;
    //单边阴影
    CGFloat shadowPathWidth = theView.layer.shadowRadius;
    CGRect shadowRect = CGRectMake(0, 0-shadowPathWidth/2, theView.bounds.size.width, shadowPathWidth);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
    theView.layer.shadowPath = path.CGPath;
}

@end
