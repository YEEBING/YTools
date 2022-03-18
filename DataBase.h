
#import <Foundation/Foundation.h>
@interface DataBase : NSObject
+ (instancetype)sharedDataBase;
- (void)deleteTable:(NSString*)tableName;
- (void)getAllInfoWithTableName:(NSString *)table_name fromView:(UIView *)view block:(void(^)(id))block;
-(void)creatTableWithTableName:(NSString*)tableName;
-(void)insertToDataBase:(NSArray *)array view:(UIView *)view toTableName:(NSString*)tableName;

//采集关键字
-(void)creatKeyWordTable;
-(void)getKeyWordFromTableUser_id:(NSString *)user_id block:(void(^)(id))block;
- (NSDictionary *)getAllInfoWithTableName:(NSString *)table_name;
-(void)insertKeyWordToDataBase:(NSString *)key user_id:(NSString *)user_id;
- (void)deleFormKeyWord:(NSString *)key_word user_id:(NSString *)user_id;
- (void)deleUserAllKeyWorduser_id:(NSString *)user_id;


/// 批量删除
/// @param key_word 关键字
/// @param keysArray 关键字数组
/// @param user_id 用户id
- (void)deteleBatchKeyWord:(NSString *)key_word keywordArray:(NSArray *)keysArray user_id:(NSString *)user_id;

+ (void)removeDataBase;
@end
