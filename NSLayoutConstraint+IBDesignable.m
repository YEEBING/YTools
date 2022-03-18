

#import "NSLayoutConstraint+IBDesignable.h"
#import <objc/runtime.h>

// 基准屏幕宽度
#define kRefereWidth 375.0
// 以屏幕宽度为固定比例关系，来计算对应的值。假设：基准屏幕宽度375，floatV=10；当前屏幕宽度为750时，那么返回的值为20
#define AdaptW(floatValue) (floatValue*[[UIScreen mainScreen] bounds].size.width/kRefereWidth)

#define AdaptH(r) [[UIScreen mainScreen]bounds].size.width*r/kRefereWidth


@implementation NSLayoutConstraint (IBDesignable)
//定义常量 必须是C语言字符串
static char *AdapterScreenKey = "AdapterScreenKey";

- (void)setAdapterScreen:(BOOL)adapterScreen{
    NSNumber *number = @(adapterScreen);
    objc_setAssociatedObject(self, AdapterScreenKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (adapterScreen){
        self.constant = AdaptW(self.constant);
    }
}

- (BOOL)adapterScreen{
    NSNumber *number = objc_getAssociatedObject(self, AdapterScreenKey);
    return number.boolValue;
}
- (void)setAdjustScreen:(BOOL)adjustScreen{
    
    if (adjustScreen){
        self.constant = AdaptH(self.constant);
    }
}

- (BOOL)adjustScreen{
    return self.adjustHeight;
}
- (void)setAdjustHeight:(BOOL)adjustHeight{
    
    if (adjustHeight){
        self.constant = AdaptH(self.constant);
    }
}

- (BOOL)adjustHeight{
    return self.adjustHeight;
}

@end
