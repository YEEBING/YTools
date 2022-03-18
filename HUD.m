

#import "HUD.h"


@implementation HUD

static UIAlertView *gProgressBackgroundView = nil;

+(void)showHUDInView:(UIView *)view title:(NSString *)title
{
    if (view == nil)
    {
        return;
    }
    if (title == nil) {
        title = @"数据加载中";
    }
    MBProgressHUD *HUDInView = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUDInView.removeFromSuperViewOnHide = YES;
    HUDInView.label.text = title;
    HUDInView.square = YES;
    [HUDInView hideAnimated:YES afterDelay:8];
    
    [HUD setHUDCustomView:HUDInView andTitle:title];
}
+(void)showHUDInViewNotDelayHidden:(UIView *)view title:(NSString *)title
{
    if (view == nil)
    {
        return;
    }
    MBProgressHUD *HUDInView = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUDInView.removeFromSuperViewOnHide = YES;
    HUDInView.label.text = title;
    HUDInView.square = YES;
    
    [HUD setHUDCustomView:HUDInView andTitle:title];
}


+(void)showHUDSucceedInView:(UIView *)view imageName:(NSString *)imageName
{
    if (view == nil)
    {
        return;
    }
    MBProgressHUD *HUDInView = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUDInView.removeFromSuperViewOnHide = YES;
    HUDInView.square = YES;
    [HUDInView hideAnimated:YES afterDelay:0.7];
    
    [HUD setHUDSucceedView:HUDInView andimageName:imageName];
}

+ (void)timeEndAction:(float)time completeBlock:(void (^)(void))completeBlock
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^(void) {
        sleep(time);
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            completeBlock();
        });
    });
}

+(void)showHUDInView:(UIView *)view title:(NSString *)title time:(int)time completeBlock:(void (^)(void))completeBlock
{
    if (view == nil)
    {
        return;
    }
    MBProgressHUD *HUDInView = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUDInView.removeFromSuperViewOnHide = YES;
    HUDInView.label.text = title;
    HUDInView.square = YES;
    
    [HUDInView showAnimated:YES whileExecutingBlock:^{
        sleep(time);
    } completionBlock:^{
        completeBlock();
    }];
}

+ (void)showHUDInView:(UIView *)view title:(NSString *)title AndDelegate:(id)delegate
{
    if (view == nil)
    {
        return;
    }
    MBProgressHUD *HUDInView = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUDInView.removeFromSuperViewOnHide = YES;
    HUDInView.label.text = title;
    HUDInView.square = YES;
    HUDInView.delegate = delegate;
    [HUDInView hideAnimated:YES afterDelay:8];
    
    [HUD setHUDCustomView:HUDInView andTitle:title];
}

+ (UIViewController*)viewController:(UIView *)view
{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;  
}  


+(void)hideHUDInView:(UIView *)view{
    [MBProgressHUD hideAllHUDsForView:view animated:NO];
    
//    NSString *str_From_buff = [NSString stringWithCString:(char*)writestart encoding:NSUTF8StringEncoding];
//    if (str_From_buff.length >= 2)
//    {
//        str_From_buff = [str_From_buff substringToIndex:1];
//    }
//    // 超过限制
//    if (bytesToWrite > 2048 || ![str_From_buff isEqualToString:@"|"])
//    {
//        //              [self recoverUnreadData];
//        NSLog(@"error time = %@,%s,%lu; result = %ld",theWriteStream,writestart,(unsigned long)bytesToWrite,result);
//        return;
//    }
}

+(void)showNetWorkErrorInView:(UIView *)view{
    if (view == nil)
    {
        return;
    }
    [MBProgressHUD hideAllHUDsForView:view animated:NO];
    MBProgressHUD *HUDInView = [MBProgressHUD showHUDAddedTo:view animated:NO];
    HUDInView.removeFromSuperViewOnHide = YES;
    HUDInView.mode = MBProgressHUDModeText;
    HUDInView.label.text = @"亲，网络异常";
    [HUDInView hideAnimated:YES afterDelay:1.5];
}

+(void)showMessageInView:(UIView *)view title:(NSString *)title{
    if (view == nil)
    {
        return;
    }
    [MBProgressHUD hideAllHUDsForView:view animated:NO];
    MBProgressHUD *HUDInView = [MBProgressHUD showHUDAddedTo:view animated:NO];
    HUDInView.removeFromSuperViewOnHide = YES;
    HUDInView.mode = MBProgressHUDModeText;
    HUDInView.userInteractionEnabled = NO;
    HUDInView.detailsLabel.text = title;

    [HUDInView hideAnimated:YES afterDelay:1.6];
    
    [HUD setHUDCustomView:HUDInView andTitle:title];
}

+(void)showMessageInView:(UIView *)view title:(NSString *)title time:(int)time{
    if (view == nil)
    {
        return;
    }
    [MBProgressHUD hideAllHUDsForView:view animated:NO];
    MBProgressHUD *HUDInView = [MBProgressHUD showHUDAddedTo:view animated:NO];
    HUDInView.removeFromSuperViewOnHide = YES;
    HUDInView.mode = MBProgressHUDModeText;
    HUDInView.detailsLabel.text = title;
    [HUDInView hideAnimated:YES afterDelay:time];
    
    [HUD setHUDCustomView:HUDInView andTitle:title];
}

+ (void)showAlertWithTitle:(NSString*)title {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:title preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
      
    }];
    
    [alertC addAction:alertA];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
    
}
+ (void)showAlertWithTitle:(NSString*)title message:(NSString *)message viewController:(UIViewController*)viewController completeBlock:(void (^)(void))completeBlock{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertB = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
       
    }];
    
    [alertC addAction:alertB];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        if (completeBlock) {
            completeBlock();
        }
    }];
    
    [alertC addAction:alertA];
    [viewController presentViewController:alertC animated:YES completion:nil];
}
+ (void)setHUDCustomView:(MBProgressHUD *)hud andTitle:(NSString *)title
{
    if(nil == title)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(int i = 1;i<13;i++)
        {
            [array addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading%d.png", i]]];
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , 60, 60)];
        imageView.animationImages = array; //动画图片数组
        imageView.animationDuration = 1.6; //执行一次完整动画所需的时长
        [imageView startAnimating];
        
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = imageView;
    }
}

+ (void)setHUDSucceedView:(MBProgressHUD *)hud andimageName:(NSString *)imageName
{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(int i = 1;i<21;i++)
    {
        [array addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d.png",imageName, i]]];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , 60, 60)];
    imageView.animationImages = array; //动画图片数组
    imageView.animationDuration = 0.7; //执行一次完整动画所需的时长
    imageView.animationRepeatCount = 1;
    [imageView startAnimating];
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = imageView;
    
}


#pragma mark - 可显示在window上 xqh 2017/04/18

+ (void)showTipMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer
{
    MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:aTimer];
}

+ (MBProgressHUD*)createMBProgressHUDviewWithMessage:(NSString*)message isWindiw:(BOOL)isWindow
{
    UIView  *view = isWindow? (UIView*)[UIApplication sharedApplication].delegate.window:[self getCurrentUIVC].view;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text =message?message:@"加载中.....";
    hud.label.font=[UIFont systemFontOfSize:15];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = NO;
    return hud;
}

//获取当前屏幕显示的viewcontroller
+(UIViewController *)getCurrentWindowVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tempWindow in windows)
        {
            if (tempWindow.windowLevel == UIWindowLevelNormal)
            {
                window = tempWindow;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
    {
        result = nextResponder;
    }
    else
    {
        result = window.rootViewController;
    }
    return  result;
}

+(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [[self class]  getCurrentWindowVC ];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }
    return superVC;
}
+ (void)showProgressView:(NSString *)string{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:string message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [indicatorView setCenter:CGPointMake(alertView.bounds.size.width/2.0f, 60)];
    [indicatorView startAnimating];
    [alertView addSubview:indicatorView];
    
    if (gProgressBackgroundView == nil)
    {
        gProgressBackgroundView = alertView;
        [gProgressBackgroundView show];
    }
}
+ (void)showProgressView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请稍候..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [indicatorView setCenter:CGPointMake(alertView.bounds.size.width/2.0f, 60)];
    [indicatorView startAnimating];
    [alertView addSubview:indicatorView];
    
    if (gProgressBackgroundView == nil)
    {
        gProgressBackgroundView = alertView;
        [gProgressBackgroundView show];
    }
}

+ (void)dismissProgressView
{
    if (gProgressBackgroundView != nil)
    {
        [gProgressBackgroundView dismissWithClickedButtonIndex:0 animated:NO];
        gProgressBackgroundView = nil;
    }
}

@end
