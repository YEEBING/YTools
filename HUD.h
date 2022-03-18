

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface HUD : NSObject

+(void)showHUDInView:(UIView *)view title:(NSString *)title;

+(void)showHUDInViewNotDelayHidden:(UIView *)view title:(NSString *)title;


+ (void)showHUDInView:(UIView *)view title:(NSString *)title AndDelegate:(id)delegate;

+ (void)timeEndAction:(float)time completeBlock:(void (^)(void))completeBlock;

+(void)showHUDInView:(UIView *)view title:(NSString *)title time:(int)time completeBlock:(void (^)(void))completeBlock;

+(void)hideHUDInView:(UIView *)view;

+(void)showNetWorkErrorInView:(UIView *)view;

+(void)showMessageInView:(UIView *)view title:(NSString *)title;

+(void)showMessageInView:(UIView *)view title:(NSString *)title time:(int)time;

+ (void)showAlertWithTitle:(NSString*)title;

+ (void)showAlertWithTitle:(NSString*)title message:(NSString *)message viewController:(UIViewController*)viewController completeBlock:(void (^)(void))completeBlock;

+ (void)showTipMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer;

+(void)showHUDSucceedInView:(UIView *)view imageName:(NSString *)imageName;

+ (void)showProgressView:(NSString *)string;

+ (void)showProgressView;

+ (void)dismissProgressView;
@end
