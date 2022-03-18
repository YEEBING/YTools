#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CoreLocation.h>

//判断设备类型
#define iPhone4 ([UIScreen mainScreen].bounds.size.height == 480)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size)) : NO)
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kWidth(R) (R)*(kScreenWidth)/320 //这里的320我是针对5s为标准适配的,如果需要其他标准可以修改
#define kHeight(R) kWidth(R)  //这里的568我是针对5s为标准适配的,如果需要其他标准可以修改

//代码简单我就不介绍了,
//以此思想,我们可以对字体下手
#define font(R) (R)*(kScreenWidth)/320.0  //这里是5s屏幕字体
#define kFONT16                  [UIFont systemFontOfSize:font(16.0f)]
#define fontSize(R) [UIFont systemFontOfSize:R]

#define SETUserDefault(obj,key) [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];[[NSUserDefaults standardUserDefaults] synchronize];
#define GETUserDefault(key) [[NSUserDefaults standardUserDefaults]objectForKey:key]
#define IMAGE(imageName) [UIImage imageNamed:imageName]


@interface Helper : NSObject

+(BOOL)isShowIndexGuide;
/**
 获取当前的网络状态

 @return 网络状态
 */
NS_ASSUME_NONNULL_BEGIN
+(NSString *)getNetTypeByGetNetworkTypeFromStatusBar;
//图片等比缩小
+(UIImage *)compressImageWith:(UIImage *)image;

+(NSArray *)sotrArray:(NSMutableArray *)array AndAscending:(BOOL)ascending WithKey:(NSString *)key;

+(UIButton *)createButton:(CGRect)frame title:(NSString *)title image:(UIImage *)image target:(id)target selector:(SEL)selector;

//字符串文字的长度
+(CGFloat)widthOfString:(NSString *)string font:(UIFont*)font height:(CGFloat)height;

//字符串文字的高度
+(CGFloat)heightOfString:(NSString *)string font:(UIFont*)font width:(CGFloat)width;


+ (CGFloat)heightOfString:(NSString *)string font:(UIFont*)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;
//获取今天的日期：年月日
+(NSDictionary *)getTodayDate;



/**
 是否为空字符串

 @param string 对象
 @return 是否为空 NULL nil @"" (null)
 */
+ (BOOL) isEmptyString: (NSString *)string;

+ (NSString *) EmptyString: (NSString *)string;

+ (BOOL) isNullClass:(id)object;
/**
 判断是否为空 空择返回@""

 @param string 对象
 @return 返回的字段
 */
+ (NSString *)noNullToStrong:(NSString *)string;
/**
 *  过滤字符串中的emoji
 */
+ (BOOL)hasEmoji:(NSString*)str;

+ (NSString *)disable_emoji:(NSString *)text;


//邮箱
+ (BOOL) justEmail:(NSString *)email;

//验证国际手机号
+ (BOOL) isInternationalMobileNumber:(NSString *)mobileNumbel;
// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//车牌号验证
+ (BOOL) justCarNo:(NSString *)carNo;

//车型
+ (BOOL) justCarType:(NSString *)CarType;

//用户名
+ (BOOL) justUserName:(NSString *)name;

//密码
+ (BOOL) justPassword:(NSString *)passWord;

//昵称
+ (BOOL) justNickname:(NSString *)nickname;

//身份证号
+ (BOOL) justIdentityCard: (NSString *)identityCard;

//高斯模糊处理
+ (UIImage*) blur:(UIImage*)theImage;

//语音播报
+ (void)speak:(NSString*)string;



+(NSString *)getTimeWithInt:(int)time;

//是否含有表情
+ (BOOL)stringContainsEmoji:(NSString *)string;

+(BOOL)isContainsEmoji:(NSString *)string;
//过滤表情
+ (NSString *)filterEmoji:(NSString *)string;

//内网ip 异步
+ (void)getLANIPAddressWithCompletion:(void (^)(NSString *IPAddress))completion;
//外网ip 异步
+ (void)getWANIPAddressWithCompletion:(void(^)(NSString *IPAddress))completion;
//同步获取
+ (NSString *)getIPAddress;
+(void)getLAN_IPWithCompletion:(void (^)(void))completion;


/**
 域名解析

 @param hostName <#hostName description#>
 @return <#return value description#>
 */
+ (NSString*_Nullable)getIPWithHostName:(const NSString*_Nonnull)hostName;



/**
 排序
 
 @param string 需要排序的字符串
 
 @return 排序好的字符串
 */
+(NSString *)sortWithString:(NSString *)string;


//截取成图片
+ (UIImage*)screenView:(UIView *)view;
+ (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r;

/**
 数组里面存字典 按字典里的key排序

 @param arraySelect 排序的数组
 @param str1 排序的key
 @param des YES 降序 NO 升序
 @return 排序完的数组
 */
+(NSArray *)sortArrayWithSelectArray:(NSMutableArray *)arraySelect withString:(NSString *)str1 withDescending:(BOOL)des;

/**
 数组排序
 
 @param arraySelect 排序的数组
 @param des YES 降序 NO 升序
 @return 排序完的数组
 */
+(NSArray *)sortArrayWithSelectArray:(NSMutableArray *)arraySelect withDescending:(BOOL)des;
//用货币计算类型计算钱避免误差 *
+(NSString *)getNumberByMultiplying:(NSString *)strA withStringB:(NSString *)strB;

//用货币计算类型计算钱避免误差 -
+(NSString *)getNumberBySubtracting:(NSString *)strA withStringB:(NSString *)strB;





/**
 判断字符长度

 @param text 文本
 @return 长度
 */
+(NSUInteger)  : (NSString *) text;

/**
 判断除汉字,数字,字母 下划线

 @param content <#content description#>
 @return yes 有  no没有
 */
+ (BOOL)JudgeTheillegalCharacter:(NSString *)content;
/**
 去除小数后面多余的0

 @param inputString 输入
 @return 输出
 */
+(NSString *)CutTheZero:(NSString *)inputString;

/**
 移除需要删掉额数据
 */
+(void)removeUserDefaultData;

//写文件
+(void)saveTheRates:(NSArray *)array;
#pragma mark 日期格式化
+ (NSDate*) convertDateFromString:(NSString*)uiDate withFormatter:(NSString *)string;
+(NSString *) convertStringFormDate:(NSDate *)date withFormatter:(NSString *)string;


//判断文件是否已经在沙盒中已经存在？
+(BOOL) isFileExist:(NSString *)fileName;


//判断是否越狱
+(BOOL)isJailBreak;




/**
 判断是否都是数字组成

 @param string <#string description#>
 @return <#return value description#>
 */
+ (BOOL)isPureInt:(NSString *_Nullable)string;




/**
 json去空  解决获取网络数据的时候，经常会遇到NSNull的问题

 @param dictionary 获取的json字典
 @return 处理过的字典
 */
+ (NSMutableDictionary *_Nullable)dictionaryWithOutNull:(NSDictionary *_Nonnull)dictionary;


/**
 闪烁功能

 @param view 需要闪烁的viewretrunTheChineseOfTheTwelveAnimals
 */
+ (void)startopacityForever_Animation:(UIView *_Nonnull)view;
NS_ASSUME_NONNULL_END


//获取当前时间戳
+ (NSTimeInterval)currentTimeInterval;

/**
 获取时间

 @param formatter 时间格式
 @param date 日期
 @return 日期格式化字符串
 */
+ (NSString *_Nullable)getTheTimeWithFormatter:(NSString *_Nullable)formatter andDate:(NSDate*_Nullable)date;


/**
 生成二维码

 @param string 字符串
 @return 二维码图片
 */
+ (UIImage *_Nullable)creatQRCodeImage:(NSString *_Nullable)string;
+(NSString *_Nullable)notRounding:(float)price afterPoint:(int)position;
+(CGRect)getRealCGRectWith:(CGFloat)x :(CGFloat)y :(CGFloat)width :(CGFloat)height;

+ (NSString *_Nullable)logGetUrl:(NSString *_Nullable)url andParameters:(NSDictionary*_Nullable)parameters;

+ (NSString*_Nullable)base64:(UIImage *_Nullable)image;
+ (UIImage *_Nullable)base64String:(NSString *_Nullable)imageStr;
+ (NSString *_Nullable)urlEncodeStr:(NSString *_Nullable)input;
+ (NSString *_Nullable)URLDecodedStringWithEncodedStr:(NSString *_Nullable)encodedString;
+ (NSString *_Nullable)currentTimeStr;
+ (NSString *_Nullable)getTimeStrWithString:(NSString *_Nullable)str;
+ (BOOL)is_iPad;
/**
 *  获取本地视频的缩略图方法
 *
 *  @param filePath 视频的本地路径
 *
 *  @return 视频截图
 */
+ (UIImage *_Nullable)getScreenShotImageFromVideoPath:(NSString *_Nullable)filePath;

//获取网络视频预览图
+ (UIImage *_Nullable) thumbnailImageForVideo:(NSString *_Nullable)videoURLString atTime:(NSTimeInterval)time;
// 读取本地JSON文件
+ (NSDictionary *_Nullable)readLocalFileWithName:(NSString *_Nullable)name;
/**
 *  URLEncode
 */
+ (NSString *_Nullable)URLEncodedString:(NSString *_Nullable)unencodedString;
/**
 * 拨打电话，弹出提示，拨打完电话回到原来的应用
 * 注意这里是 telprompt://
 * @param phoneNumber 电话号码字符串
 */
+ (void)makePhoneCall:(NSString *_Nullable)phoneNumber;

//截图
+ (UIImage *_Nullable)snapsHotView:(UIView *_Nullable)view;


//获取经纬度
+ (void)getLocationWithAddress:(NSString *_Nullable)address andBlock:(void(^_Nonnull)(CLLocationCoordinate2D coordinate))block;

//替换空格和换行
+ (NSString *_Nullable)toJsonStrWithArray:(NSArray *_Nullable)arr;
@end


