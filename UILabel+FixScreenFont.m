

#import "UILabel+FixScreenFont.h"


@implementation UILabel (FixScreenFont)

- (void)setFixWidthScreenFont:(float)fixWidthScreenFont{
    
    if (fixWidthScreenFont > 0 ) {
        self.font = [UIFont systemFontOfSize:fixWidthScreenFont*[UIScreen mainScreen].bounds.size.width];
    }else{
        self.font = self.font;
    }
}
 
- (float )fixWidthScreenFont{
    return self.fixWidthScreenFont;
}

@end
