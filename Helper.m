

#import "Helper.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <CoreImage/CoreImage.h>
#import <netdb.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>


#define USER_APP_PATH                 @"/User/Applications/"
#define YScreenHeight [[UIScreen mainScreen] bounds].size.height

#define YScreenWidth [[UIScreen mainScreen] bounds].size.width

@implementation Helper
////  网络类型
typedef enum {
    NETWORK_TYPE_NONE = 0,
    NETWORK_TYPE_2G = 1,
    NETWORK_TYPE_3G = 2,
    NETWORK_TYPE_4G = 3,
    NETWORK_TYPE_5G = 4,//  5G目前为猜测结果
    NETWORK_TYPE_WIFI = 5,
}NETWORK_TYPE;


+(BOOL)isShowIndexGuide
{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"welcome_index_guide"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"welcome_index_guide"];
        return YES;
    }
    return NO;
}

+(NSString *)getNetTypeByGetNetworkTypeFromStatusBar
{
    
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]])     {
            dataNetworkItemView = subview;
            break;
        }
    }
    NETWORK_TYPE nettype = NETWORK_TYPE_NONE;
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    nettype = [num intValue];
    
    NSString *retureStr;
    switch (nettype) {
        case 0:
        {
            retureStr = @"无网络";
        }
            break;
        case 1:
        {
            retureStr = @"2G网络";
        }
            break;
            
        case 2:
        {
            retureStr = @"3G网络";
        }
            break;
            
        case 3:
        {
            retureStr = @"4G网络";
        }
            break;
            
        case 4:
        {
            retureStr = @"5G网络";
        }
            break;
            
        case 5:
        {
            retureStr = @"WiFi网络";
        }
            break;
    }
    
    NSLog(@"retureStr = %@",retureStr);
    return retureStr;
}


+(UIImage *)compressImageWith:(UIImage *)image
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = 320;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
    
}



+(NSArray *)sotrArray:(NSMutableArray *)array AndAscending:(BOOL)ascending WithKey:(NSString *)key
{
    NSArray *sortDescriptors = [ NSArray arrayWithObject :[ NSSortDescriptor sortDescriptorWithKey : key ascending : ascending ]];
    
    [array sortUsingDescriptors :sortDescriptors];
    return array;
//    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
//
//    
//    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
//    
//    NSArray *sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
 //   return sortedArray;
}
+(UIButton *)createButton:(CGRect)frame title:(NSString *)title image:(UIImage *)image target:(id)target selector:(SEL)selector
{
    
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    if (image !=nil) {
        [button setImage:image forState:UIControlStateNormal];
    }
    
    button.frame=frame;
    CGRect newFrame=frame;
    newFrame.origin.y=frame.size.height/2.0;
    newFrame.size.height=frame.size.height/2.0;
    newFrame.origin.x=0;
    UILabel * label=[[UILabel alloc]initWithFrame:newFrame];
    label.text=title;
    label.textAlignment = NSTextAlignmentCenter;
    [button addSubview:label];
    label.font=[UIFont systemFontOfSize:12];
    label.backgroundColor=[UIColor clearColor];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
     button.imageEdgeInsets = UIEdgeInsetsMake(5,0,frame.size.height/2.0-5,0);
    return button;
}

+(CGFloat)widthOfString:(NSString *)string font:(UIFont *)font height:(CGFloat)height
{
    NSDictionary * dict=[NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
    CGRect rect=[string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width;
}

+(CGFloat)heightOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width
{
    CGRect bounds;
    NSDictionary * parameterDict=[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    bounds=[string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:parameterDict context:nil];
    return bounds.size.height;
}
+ (CGFloat)heightOfString:(NSString *)string font:(UIFont*)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options context:nil];
    CGFloat textH = rect.size.height;
    return textH;

}
#pragma  mark - 获取当天的日期：年月日
+ (NSDictionary *)getTodayDate
{
    
    //获取今天的日期
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay;
    
    NSDateComponents *components = [calendar components:unit fromDate:today];
    NSString *year = [NSString stringWithFormat:@"%ld", (long)[components year]];
    NSString *month = [NSString stringWithFormat:@"%02ld", (long)[components month]];
    NSString *day = [NSString stringWithFormat:@"%02ld", (long)[components day]];
    
    NSMutableDictionary *todayDic = [[NSMutableDictionary alloc] init];
    [todayDic setObject:year forKey:@"year"];
    [todayDic setObject:month forKey:@"month"];
    [todayDic setObject:day forKey:@"day"];
    
    return todayDic;
    
}

/**
 是否为空字符串
 
 @param string 对象
 @return 是否为空 NULL nil @"" (null) @" "
 */
+ (BOOL) isEmptyString: (NSString *)string{

    if (string == nil || [string isKindOfClass:[NSNull class]] ||[string isEqualToString:@"null"]|| [string isEqualToString:@"(null)"] || [string isEqualToString:@""] || [string isEqualToString:@" "] ||[string isEqualToString:@"<null>"]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
+ (NSString *) EmptyString: (NSString *)string{

    if (string == nil || [string isKindOfClass:[NSNull class]] ||[string isEqualToString:@"null"]|| [string isEqualToString:@"(null)"] || [string isEqualToString:@""] || [string isEqualToString:@" "] ||[string isEqualToString:@"<null>"]) {
        return @"";
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return @"";
    }
    return string;
}
+ (BOOL) isNullClass:(id)object
{
    
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return NO;
    
}

+ (NSString *)noNullToStrong:(NSString *)string
{
    if (string == nil || [string isKindOfClass:[NSNull class]] ||[string isEqualToString:@"null"]|| [string isEqualToString:@"(null)"] ||[string isEqualToString:@"<null>"]) {
        return @"";
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return @"";
    }
    return string;
}

+ (BOOL)hasEmoji:(NSString*)str{
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

+ (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

//邮箱
+ (BOOL) justEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    NSString *str = [mobileNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:str];
}

+ (BOOL) isInternationalMobileNumber:(NSString *)mobileNumbel
{
    
    NSString *aaa = @"^\\s*\\+?\\s*(\\(\\s*\\d+\\s*\\)|\\d+)(\\s*-?\\s*(\\(\\s*\\d+\\s*\\)|\\s*\\d+\\s*))*\\s*$";
    
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", aaa];
    if (([regextestct evaluateWithObject:mobileNumbel]
         )) {
        return YES;
    }
    return NO;
}


//车牌号验证
+ (BOOL) justCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}


//车型
+ (BOOL) justCarType:(NSString *)CarType
{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:CarType];
}


//用户名
+ (BOOL) justUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
//    NSString *userNameRegex = @"^[a-zA-Z0-9_\u4e00-\u9fa5]+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}


//密码
+ (BOOL) justPassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}


//昵称
+ (BOOL) justNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[a-zA-Z0-9_➊➋➌➍➎➏➐➑➒\u4e00-\u9fa5]+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    BOOL b = [passWordPredicate evaluateWithObject:nickname];
    return  b;
}


//身份证号
+ (BOOL) justIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//高斯模糊处理
+ (UIImage*) blur:(UIImage*)theImage
{
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur (could use one of many filters offered by Core Image)
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setValue:inputImage forKey:kCIInputImageKey];
    [blurFilter setValue:[NSNumber numberWithFloat:5.0f] forKey:@"inputRadius"];
    CIImage *result = [blurFilter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    //create a UIImage for this function to "return" so that ARC can manage the memory of the blur...
    //ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    
    return returnImage;
}

+ (void)speak:(NSString*)string
{
    //初始化语音播报
    AVSpeechSynthesizer * av = [[AVSpeechSynthesizer alloc]init];
    //设置播报的内容
    AVSpeechUtterance * utterance = [[AVSpeechUtterance alloc]initWithString:string];
    //设置语言类别
    AVSpeechSynthesisVoice * voiceType = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utterance.voice = voiceType;
    //设置播报语速
    utterance.rate = 0.5;
    [av speakUtterance:utterance];
}

+(NSString *)getTimeWithInt:(int)time
{
//    int intTime = [[DicData objectForKey:@"uTime"] intValue];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];

    return [dateFormatter stringFromDate:confromTimesp];
}

+(BOOL)isContainsEmoji:(NSString *)string {
    
    
    
    __block BOOL isEomji = NO;
    
    
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:
     
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         
         
         const unichar hs = [substring characterAtIndex:0];
         
         // surrogate pair
         
         if (0xd800 <= hs && hs <= 0xdbff) {
             
             if (substring.length > 1) {
                 
                 const unichar ls = [substring characterAtIndex:1];
                 
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     
                     isEomji = YES;
                     
                 }
                 
             }
             
         } else if (substring.length > 1) {
             
             const unichar ls = [substring characterAtIndex:1];
             
             if (ls == 0x20e3) {
                 
                 isEomji = YES;
                 
             }
             
             
             
         } else {
             
             // non surrogate
             
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 
                 isEomji = YES;
                 
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 
                 isEomji = YES;
                 
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 
                 isEomji = YES;
                 
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 
                 isEomji = YES;
                 
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 
                 isEomji = YES;
                 
             }
             
         }
         
     }];
    
    
    
    return isEomji;
    
}


//是否含有表情
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}
//过滤表情
+ (NSString *)filterEmoji:(NSString *)string {
    NSUInteger len = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    const char *utf8 = [string UTF8String];
    char *newUTF8 = malloc( sizeof(char) * len );
    int j = 0;
    
    //0xF0(4) 0xE2(3) 0xE3(3) 0xC2(2) 0x30---0x39(4)
    for ( int i = 0; i < len; i++ ) {
        unsigned int c = (unsigned int)utf8;
        BOOL isControlChar = NO;
        if ( c == 4294967280 ||
            c == 4294967089 ||
            c == 4294967090 ||
            c == 4294967091 ||
            c == 4294967092 ||
            c == 4294967093 ||
            c == 4294967094 ||
            c == 4294967095 ||
            c == 4294967096 ||
            c == 4294967097 ||
            c == 4294967088 ) {
            i = i + 3;
            isControlChar = YES;
        }
        if ( c == 4294967266 || c == 4294967267 ) {
            i = i + 2;
            isControlChar = YES;
        }
        if ( c == 4294967234 ) {
            i = i + 1;
            isControlChar = YES;
        }
        if ( !isControlChar ) {
            newUTF8[j] = (unsigned int)utf8;
            j++;
        }
    }
    newUTF8[j] = '\0';
    NSString *encrypted = [NSString stringWithCString:(const char*)newUTF8
                                             encoding:NSUTF8StringEncoding];
    free( newUTF8 );
    return encrypted;
}

#pragma mark - IP
// http://zachwaugh.me/posts/programmatically-retrieving-ip-address-of-iphone/
+ (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

+(void)getLAN_IPWithCompletion:(void (^)(void))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        NSString *URLTmp1 = @"http://1212.ip138.com/ic.asp";http://api.wipmania.com/
//        NSString *URLTmp1 = @"http://api.wipmania.com/";
        NSString *URLTmp1 = @"http://freegeoip.net/json/";
//        NSString *URLTmp1 = @"http://ip.taobao.com/service/getIpInfo.php?ip=myip";
        NSString *URLTmp = [URLTmp1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData * resData = [NSData dataWithContentsOfURL:[NSURL URLWithString:URLTmp]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resData) {
                //系统自带JSON解析
                NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                //您的IP是：[122.222.122.22] 来自：上海市某某区 某某运营商
                NSString *str3 = [[NSString alloc] initWithData:resData encoding:gbkEncoding];
                if (str3 == nil || str3.length < 1){
                    return;
                }
                NSDictionary *receiveDic =[Helper parseJSONStringToNSDictionary:str3];
                NSLog(@"get LAN IP =====%@",receiveDic);
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
                [userDefaults synchronize];
                completion();
            }
        });
    });
}
///根据域名获取ip地址 - 可以用于控制APP的开关某一个入口，比接口方式速度快的多
+ (NSString*_Nullable)getIPWithHostName:(const NSString*_Nonnull)hostName;
{
    const char *hostN= [hostName UTF8String];
    struct hostent* phot;
    @try {
        phot = gethostbyname(hostN);
    } @catch (NSException *exception) {
        return nil;
    }
    struct in_addr ip_addr;
    if (phot == NULL) {
        NSLog(@"获取失败");
        return nil;
    }
    memcpy(&ip_addr, phot->h_addr_list[0], 4);
    char ip[20] = {0}; inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
    
    NSString* strIPAddress = [NSString stringWithUTF8String:ip];
    NSLog(@"ip=====%@",strIPAddress);
    return strIPAddress;
}
+ (void)getLANIPAddressWithCompletion:(void (^)(NSString *IPAddress))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *IP = [self getIPAddress];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(IP);
            }
        });
    });
}

+ (void)getWANIPAddressWithCompletion:(void(^)(NSString *IPAddress))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *IP = @"0.0.0.0";
        NSURL *url = [NSURL URLWithString:@"http://ifconfig.me/ip"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:8.0];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (error) {
            NSLog(@"Failed to get WAN IP Address!\n%@", error);
            [[[UIAlertView alloc] initWithTitle:@"获取外网 IP 地址失败" message:[error localizedFailureReason] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            IP = responseStr;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(IP);
        });
    });
}



+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}
////针对ipv6网络环境下适配，ipv4环境直接使用原来的地址
//+ (NSString *)getProperIPWithAddress:(NSString *)ipAddr port:(UInt32)port
//{
//    NSError *addresseError = nil;
//    NSArray *addresseArray = [GCDAsyncSocket lookupHost:ipAddr
//                                                   port:port
//                                                  error:&addresseError];
//    if (addresseError) {
//        NSLog(@"");
//    }
//
//    NSString *ipv6Addr = @"";
//    for (NSData *addrData in addresseArray) {
//        if ([GCDAsyncSocket isIPv6Address:addrData]) {
//            ipv6Addr = [GCDAsyncSocket hostFromAddress:addrData];
//        }
//    }
//
//    if (ipv6Addr.length == 0) {
//        ipv6Addr = ipAddr;
//    }
//
//    return ipv6Addr;
//}





+ (UIImage*)screenView:(UIView *)view{
    CGRect rect = view.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//获得某个范围内的屏幕图像
+ (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];
}


/**
 排序
 
 @param string 需要排序的字符串
 
 @return 排序好的字符串
 */
+(NSString *)sortWithString:(NSString *)string
{
    
    NSArray *arr = [string componentsSeparatedByString:@","];
    NSArray *sortedArray = [arr sortedArrayUsingComparator:^(NSString *number1,NSString *number2) {
        
        int val1 = [number1 intValue];
        
        int val2 = [number2 intValue];
        
        if (val1 > val2) {
            
            return NSOrderedDescending;
            
        } else {
            
            return NSOrderedAscending;
            
        }
        
    }];
    return  [sortedArray componentsJoinedByString:@","];
}

/**
 <#Description#>
 
 @param arraySelect 排序的数组
 @param str1 排序的key
 @param des YES 降序 NO 升序
 @return <#return value description#>
 */
+(NSArray *)sortArrayWithSelectArray:(NSMutableArray *)arraySelect withString:(NSString *)str1 withDescending:(BOOL)des
{
    //排序
    
    if (des) {
        NSArray *tArray = [arraySelect sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                           {
                               NSNumber *tNumber1 = (NSNumber *)[obj1 objectForKey:str1];
                               NSNumber *tNumber2 = (NSNumber *)[obj2 objectForKey:str1];
                               //因为不满足sortedArrayUsingComparator方法的默认排序顺序，则需要交换
                               if ([tNumber1 integerValue] < [tNumber2 integerValue])
                               {
                                   return NSOrderedDescending;
                               }
                               //因为满足sortedArrayUsingComparator方法的默认排序顺序，则不需要交换
                               if ([tNumber1 integerValue] > [tNumber2 integerValue])
                               {
                                   return NSOrderedAscending;
                               }
                               return NSOrderedSame;
                           }];
        return tArray;
    }else{
        NSArray *array = [arraySelect sortedArrayUsingComparator:
                          ^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                              NSComparisonResult result = [[obj1 objectForKey:str1] compare:[obj2 objectForKey:str1]];
                              return result;
                          }];
         return array;
    }
    
    
}

/**
 数组排序
 
 @param arraySelect 排序的数组
 @param des YES 降序 NO 升序
 @return 排序完的数组
 */
+(NSArray *)sortArrayWithSelectArray:(NSMutableArray *)arraySelect withDescending:(BOOL)des
{
    //排序
    
    if (des) {
        NSArray *tArray = [arraySelect sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                           {
                               NSNumber *tNumber1 = (NSNumber *)obj1;
                               NSNumber *tNumber2 = (NSNumber *)obj2;
                               //因为不满足sortedArrayUsingComparator方法的默认排序顺序，则需要交换
                               if ([tNumber1 integerValue] < [tNumber2 integerValue])
                               {
                                   return NSOrderedDescending;
                               }
                               //因为满足sortedArrayUsingComparator方法的默认排序顺序，则不需要交换
                               if ([tNumber1 integerValue] > [tNumber2 integerValue])
                               {
                                   return NSOrderedAscending;
                               }
                               return NSOrderedSame;
                           }];
        return tArray;
    }else{
        NSArray *array = [arraySelect sortedArrayUsingComparator:
                          ^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
                              NSComparisonResult result = [obj1 compare:obj2];
                              return result;
                          }];
        return array;
    }
    
    
}
//用货币计算类型计算钱避免误差 *
+(NSString *)getNumberByMultiplying:(NSString *)strA withStringB:(NSString *)strB
{
    NSDecimalNumber *numberA = [NSDecimalNumber decimalNumberWithString:strA];
    NSDecimalNumber *numberB = [NSDecimalNumber decimalNumberWithString:strB];
    
    /// 这里不仅包含Multiply还有加 减 除。
    NSDecimalNumber *numResult = [numberA decimalNumberByMultiplyingBy:numberB];
    
    NSString *strResult = [numResult stringValue];
    NSLog(@"NSDecimalNumber method  unrounding = %@",strResult);
    return strResult;
}
//用货币计算类型计算钱避免误差 -
+(NSString *)getNumberBySubtracting:(NSString *)strA withStringB:(NSString *)strB
{
    NSDecimalNumber *numberA = [NSDecimalNumber decimalNumberWithString:strA];
    NSDecimalNumber *numberB = [NSDecimalNumber decimalNumberWithString:strB];
    
    /// 这里不仅包含Multiply还有加 减 除。
    NSDecimalNumber *numResult = [numberA decimalNumberBySubtracting:numberB];
    NSString *strResult = [numResult stringValue];
    NSLog(@"NSDecimalNumber method  unrounding = %@",strResult);
    return strResult;
}


//获取Documents目录
+(NSString *)dirDoc{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"documentsDirectory -> %@",documentsDirectory);
    return documentsDirectory;
}


+(NSUInteger)textLength: (NSString *) text{
    
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        
        
        unichar uc = [text characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength;
    
    return unicodeLength;
    
}
/**
 判断除汉字,数字,字母 下划线
 
 @param content <#content description#>
 @return yes 有  no没有
 */
+ (BOOL)JudgeTheillegalCharacter:(NSString *)content
{
    //提示 标签不能输入特殊字符
//    NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
     NSString *str =@"^[a-zA-Z0-9_\\u4e00-\\u9fa5]+$";
    
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:content]) {
        return YES;
    }
    return NO;
}

#pragma mark 日期格式化
+ (NSDate*) convertDateFromString:(NSString*)uiDate withFormatter:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:string];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}
+(NSString *) convertStringFormDate:(NSDate *)date withFormatter:(NSString *)string{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:string];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

//判断文件是否已经在沙盒中已经存在？
+(BOOL) isFileExist:(NSString *)fileName
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *filePath = [cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",fileName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    return result;
}

+ (BOOL)isJailBreak
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        NSLog(@"The device is jail broken!");
        return YES;
    }
    NSLog(@"The device is NOT jail broken!");
    return NO;
}


+ (BOOL)isPureInt:(NSString *_Nullable)string
{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
    
}


+ (NSMutableDictionary *_Nullable)dictionaryWithOutNull:(NSDictionary *_Nonnull)dictionary
{
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    NSArray *keysArr = [mutableDictionary allKeys];
    for (NSString *keyStr in keysArr)
    {
        id value = [mutableDictionary objectForKey:keyStr];
        if ([value isKindOfClass:[NSNull class]])
        {
            [mutableDictionary setValue:@"" forKey:keyStr];
        }
        else if ([value isKindOfClass:[NSArray class]])
        {
            NSMutableArray *valueArr = [NSMutableArray arrayWithArray:value];
            
            for (id arrElements in value)
            {
                if ([arrElements isKindOfClass:[NSDictionary class]])
                {
                    NSInteger index = [valueArr indexOfObject:arrElements];
                    NSDictionary *subDic = (NSDictionary *)[Helper dictionaryWithOutNull:arrElements];
                    [valueArr replaceObjectAtIndex:index withObject:subDic];                    
                }
            }
            [mutableDictionary setValue:valueArr forKey:keyStr];
        }
        else if ([value isKindOfClass:[NSDictionary class]])
        {
            [mutableDictionary setValue:[Helper dictionaryWithOutNull:value] forKey:keyStr];
        }
    }
    return mutableDictionary;
}


+ (void)startopacityForever_Animation:(UIView *_Nonnull)view
{
    [view.layer addAnimation:[Helper opacityForever_Animation:.5] forKey:nil];
}
#pragma mark === 永久闪烁的动画 ======
+ (CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}

//获取当前时间戳
+ (NSTimeInterval)currentTimeInterval
{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970];// *1000 是精确到毫秒，不乘就是精确到秒
//    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return time;
}

+ (NSString *)getTheTimeWithFormatter:(NSString *)formatter andDate:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

+ (UIImage *)creatQRCodeImage:(NSString *)string
{
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成二维码
    CIImage *image = [filter outputImage];

    
//    UIImage *image = [UIImage imageWithCIImage:image];
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(200/CGRectGetWidth(extent), 200/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
+(NSString *)notRounding:(float)price afterPoint:(int)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

//CG_INLINE CGRect
+(CGRect)getRealCGRectWith:(CGFloat)x :(CGFloat)y :(CGFloat)width :(CGFloat)height
{
    float autoSizeScaleX;
    float autoSizeScaleY;
    
    if(YScreenHeight > 480){ // 这里以(iPhone4S)为准
        autoSizeScaleX = YScreenWidth/375;
        autoSizeScaleY = YScreenHeight/667;
    }else{
        autoSizeScaleX = 1.0;
        autoSizeScaleY = 1.0;
    }
    CGRect rect;
    rect.origin.x = x * autoSizeScaleX;
    rect.origin.y = y * autoSizeScaleY;
    rect.size.width = width * autoSizeScaleX;
    rect.size.height = height * autoSizeScaleY;
    return rect;
}

+ (NSString *)logGetUrl:(NSString *)url andParameters:(NSDictionary*)parameters{
    NSMutableString *allUrl = [NSMutableString stringWithString:url];
    NSArray *allKeyArray = parameters.allKeys;
    for (NSString *key in allKeyArray) {
        [allUrl appendString:@"&"];
        [allUrl appendString:[NSString stringWithFormat:@"%@=%@",key,[parameters objectForKey:key]]];
    }
    NSLog(@"拼接的完整URL: %@",allUrl);
    return allUrl;
}
+ (NSString*)base64:(UIImage *)image{
    //UIImage图片转Base64字符串：
    
    UIImage *originImage = image;
    
    NSData *imgData = UIImageJPEGRepresentation(originImage, 1.0f);
    
    NSString *encodedImageStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSLog(@"%@",encodedImageStr);
    
    return encodedImageStr;
}
+ (UIImage *)base64String:(NSString *)imageStr{
    NSData *decodedImageData = [[NSData alloc]initWithBase64EncodedString:imageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    return decodedImage;
}
/**
 *  URLEncode
 */
+ (NSString *)urlEncodeStr:(NSString *)input{
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *upSign = [input stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return upSign;
}

/**
 *  URLDecode
 */
+ (NSString *)URLDecodedStringWithEncodedStr:(NSString *)encodedString{
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,(__bridge CFStringRef)encodedString,CFSTR(""),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}
//获取当前时间戳
+ (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}
//字符串转时间戳 如：2017-4-10 17:15:10
+ (NSString *)getTimeStrWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //设定时间的格式
//    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}


+ (BOOL)is_iPad{
    NSString *deviceType = [UIDevice currentDevice].model;
    if ([deviceType isEqualToString:@"iPad"]) {
        return YES;
    }
    return NO;
}

/**
 *  获取本地视频的缩略图方法
 *
 *  @param filePath 视频的本地路径
 *
 *  @return 视频截图
 */
+ (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath{
    
    UIImage *shotImage;
    //视频路径URL
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    shotImage = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return shotImage;
    
}
+ (UIImage*) thumbnailImageForVideo:(NSString *)videoURLString atTime:(NSTimeInterval)time {
    
    NSURL *url = [NSURL URLWithString:videoURLString];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}
// 读取本地JSON文件
+ (NSDictionary *_Nullable)readLocalFileWithName:(NSString *_Nullable)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}
/**
 *  URLEncode
 */
+ (NSString *_Nullable)URLEncodedString:(NSString *_Nullable)unencodedString
{
    
    NSString *encodedString = (NSString *)
    
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    /*
     CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
     (CFStringRef)unencodedString,
     NULL,
     (CFStringRef)@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ",
     kCFStringEncodingUTF8));
     */
    return encodedString;
}
/**
 * 拨打电话，弹出提示，拨打完电话回到原来的应用
 * 注意这里是 telprompt://
 * @param phoneNumber 电话号码字符串
 */
+ (void)makePhoneCall:(NSString *)phoneNumber {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNumber]]];
}

//截图
+ (UIImage *_Nullable)snapsHotView:(UIView *_Nullable)view
{
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,NO,[UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



+ (void)getLocationWithAddress:(NSString *)address andBlock:(void(^)(CLLocationCoordinate2D coordinate))block{
    __block CLLocationCoordinate2D coordinate1;
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ([placemarks count] > 0 && error == nil) {
           NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
           CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            coordinate1 = firstPlacemark.location.coordinate;
               NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
               NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
            if (block) {
                block(coordinate1);
            }
           }
           else if ([placemarks count] == 0 && error == nil) {
               NSLog(@"Found no placemarks.");
           } else if (error != nil) {
               NSLog(@"An error occurred = %@", error);
           }
    }];

}

+ (NSString *)toJsonStrWithArray:(NSArray *)arr {
    if ([arr isKindOfClass:[NSString class]]) {
        return (NSString *)arr;
    }
    NSError *parseError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (parseError) {
        jsonStr = @"";
    }
    return jsonStr;
}
@end
