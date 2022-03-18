

#import "NSString+DecimalNumber.h"

@implementation NSString (DecimalNumber)
+(NSString *)A:(NSString *)a jiaB:(NSString *)b;{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:b];
    NSDecimalNumber *resultNum = [num1 decimalNumberByAdding:num2];
    return [resultNum stringValue];
}
+(NSString *)A:(NSString *)a jianB:(NSString *)b;{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:b];
    NSDecimalNumber *resultNum = [num1 decimalNumberBySubtracting:num2];
    return [resultNum stringValue];
}
+(NSString *)A:(NSString *)a chengyiB:(NSString *)b;{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:b];
    NSDecimalNumber *resultNum = [num1 decimalNumberByMultiplyingBy:num2];
    return [resultNum stringValue];
}
+(NSString *)A:(NSString *)a chuyiB:(NSString *)b;{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:b];
    NSDecimalNumber *resultNum = [num1 decimalNumberByDividingBy:num2];
    return [resultNum stringValue];
}
+(BOOL)A:(NSString *)a dayuB:(NSString *)b;{
    NSDecimalNumber *discount1 = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *discount2 = [NSDecimalNumber decimalNumberWithString:b];
    NSComparisonResult result = [discount1 compare:discount2];
    if (result == NSOrderedAscending) {
        return NO;
    } else if (result == NSOrderedSame) {
        return NO;
    } else if (result == NSOrderedDescending) {
        return YES;
    }
    return NO;
    
}
+(BOOL)A:(NSString *)a dengyuB:(NSString *)b;{
    NSDecimalNumber *discount1 = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *discount2 = [NSDecimalNumber decimalNumberWithString:b];
    NSComparisonResult result = [discount1 compare:discount2];
    if (result == NSOrderedAscending) {
        return NO;
    } else if (result == NSOrderedSame) {
        return YES;
    } else if (result == NSOrderedDescending) {
        return NO;
    }
    return NO;
    
}
+(BOOL)A:(NSString *)a xiaoyuB:(NSString *)b;{
    NSDecimalNumber *discount1 = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *discount2 = [NSDecimalNumber decimalNumberWithString:b];
    NSComparisonResult result = [discount1 compare:discount2];
    if (result == NSOrderedAscending) {
        return YES;
    } else if (result == NSOrderedSame) {
        return NO;
    } else if (result == NSOrderedDescending) {
        return NO;
    }
    return NO;
    
}

@end
