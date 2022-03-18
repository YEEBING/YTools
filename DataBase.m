

#import "DataBase.h"

#import "FMDB.h"

static DataBase *_DBCtl = nil;

@interface DataBase()<NSCopying,NSMutableCopying>{
    FMDatabase  *_db;
    FMDatabase  *_db2;
    FMDatabaseQueue* queue;
}




@end

@implementation DataBase

+(instancetype)sharedDataBase{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [[DataBase alloc] init];
        
        [_DBCtl initDataBase];
        
    }
    
    return _DBCtl;
    
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [super allocWithZone:zone];
        
    }
    
    return _DBCtl;
    
}

-(id)copy{
    
    return self;
    
}

-(id)mutableCopy{
    
    return self;
    
}

-(id)copyWithZone:(NSZone *)zone{
    
    return self;
    
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    return self;
    
}


-(void)initDataBase{
    // 获得Documents目录路径
    
//    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    
//    // 文件路径
//    
//    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"model.sqlite"];
    NSString *filePath = [NSString stringWithFormat:@"%@juke.sqlite",[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"]];
    NSLog(@"%@",filePath);
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:filePath];
    if (bRet==YES)
    {
        NSLog(@"文件存在");
    }
    else
    {
        NSLog(@"文件不存在");
        
    }
    
    queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    _db = [FMDatabase databaseWithPath:filePath];
    // 实例化FMDataBase对象


}
#pragma mark - 接口


/**
 创建数据库表
 */
-(void)creatKeyWordTable
{
    //表命名为user_id-key
    //user_id 区分登录用户
    
    [queue inDatabase:^(FMDatabase *db) {
        [db open];
        NSString *sql =[NSString stringWithFormat:@"create table if not exists '%@' (id integer primary key autoincrement,key text,user_id text);",@"KeyWord"];
           BOOL success = [db executeUpdate:sql];

           if (success) {
               NSLog(@"创建KeyWord表成功");
           } else {
               NSLog(@"创建KeyWord表失败");
           }
        [db close];
       }];
}

-(void)getKeyWordFromTableUser_id:(NSString *)user_id block:(void(^)(id))block{
    [queue inDatabase:^(FMDatabase *db) {
        [db open];
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        
        
        NSString *sql = [NSString stringWithFormat:@"select * from '%@' where user_id='%@'",@"KeyWord",user_id];
        
        FMResultSet *res = [db executeQuery:sql];
        
        while ([res next]) {
            NSDictionary *dic = @{
                                  @"key":[res stringForColumn:@"key"],
                                  @"user_id":[res stringForColumn:@"user_id"]
                                  };
            
            [dataArray addObject:dic];
            
        }
        if (block) {
            block(dataArray);
        }
        [db close];
    }];
}

-(void)insertKeyWordToDataBase:(NSString *)key user_id:(NSString *)user_id
{
    NSString *tableName = @"KeyWord";
    
    
    [queue inDatabase:^(FMDatabase *db) {
        [db open];
        NSString *sql =[NSString stringWithFormat:@"create table if not exists '%@' (id integer primary key autoincrement,key text,user_id text);",tableName];
           BOOL success = [db executeUpdate:sql];

           if (success) {
               NSLog(@"创建KeyWord表成功");
               
               NSString *searchString = [NSString stringWithFormat:@"select * from '%@' where user_id='%@' and key='%@'",tableName,user_id,key];
               
               FMResultSet * searchResult = [db executeQuery:searchString];
               
               //判断是否有数据
               
               
               if (searchResult.next) {

               }else{
                   
                   NSString *insertsql =[NSString stringWithFormat:@"insert into '%@' (key,user_id) values ('%@','%@')",tableName,key,user_id];
                   
                   BOOL returnResult = [db executeUpdate:insertsql];
                   if (returnResult) {
                       NSLog(@"%@插入数据成功",tableName);
                   }else{
                       NSLog(@"%@插入数据失败",tableName);
                   }
               }
               
               
               
               
               
           } else {
               NSLog(@"创建KeyWord表失败");
           }
        [db close];
       }];
}
- (void)deleUserAllKeyWorduser_id:(NSString *)user_id{
    
    NSString *tableName = @"KeyWord";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [self->queue inDatabase:^(FMDatabase *db) {
            [db open];
            
            
            NSString *sql = [NSString stringWithFormat:@"delete from '%@' where user_id='%@'",tableName,user_id];
            
            [db executeUpdate:sql];
            
            [db close];
        }];
    });

}
- (void)deleFormKeyWord:(NSString *)key_word user_id:(NSString *)user_id{
    
    NSString *tableName = @"KeyWord";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [self->queue inDatabase:^(FMDatabase *db) {
            [db open];
            
            
            NSString *sql = [NSString stringWithFormat:@"delete from '%@' where user_id='%@' and key='%@'",tableName,user_id,key_word];
            
            [db executeUpdate:sql];
            
            [db close];
        }];
    });

}
/**
 创建数据库表
 */
-(void)creatTableWithTableName:(NSString*)tableName
{
    //表命名为user_id-key
    //user_id 区分登录用户
    
    [queue inDatabase:^(FMDatabase *db) {
        [db open];
        NSString *sql =[NSString stringWithFormat:@"create table if not exists '%@' (id integer primary key autoincrement,name text,phone text);",tableName];

//        NSString *sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age TEXT;",tableName];
//        NSString *str = @"CREATE TABLE IF NOT EXISTS t_student (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age test;";

           BOOL success = [db executeUpdate:sql];

           if (success) {
               NSLog(@"创建%@表成功",tableName);
           } else {
               NSLog(@"创建%@表失败",tableName);
           }
        [db close];
       }];
    
//
//    if ([_db open]) {
//            NSString *sql =[NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement,name text,phone text);",tableName];
//
//        BOOL result = [_db executeUpdate:sql];
//    }
    

//    [_db close];
    
    
//    dispatch_group_async(dispatch_group_create(), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getDatabasePath]];
//        [queue inDatabase:^(FMDatabase *db) {
//            //打开数据库
//            if ([db open]) {
//
//
//                NSString *sql =[NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement,user_id text,card_num text);",tableName];
//
//                [db executeUpdate:sql];
//
//            }
//            else
//            {
//                NSLog(@"打开数据库失败！");
//            }
//
//        }];
//    });
//
    
    
}

- (void)getAllInfoWithTableName:(NSString *)table_name fromView:(UIView *)view block:(void(^)(id))block{
    
    
    
//    [HUD showHUDInView:view title:@"数据加载中"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{

       

        [self->queue inDatabase:^(FMDatabase *db) {
            [db open];
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            NSString *sql =[NSString stringWithFormat:@"SELECT * FROM '%@'",table_name];

            FMResultSet *res = [db executeQuery:sql];
            
            while ([res next]) {
                NSDictionary *dic = @{
                                      @"name":[res stringForColumn:@"name"],
                                      @"phone":[res stringForColumn:@"phone"],
                                      @"address":[res stringForColumn:@"address"],
                                      };
                
                [dataArray addObject:dic];
                
            }
            if (block) {
                NSDictionary *dic = @{
                    @"table_name":table_name,
                    @"array":dataArray
                };
                block(dic);
            }
            [db close];
        }];
    });
}

- (NSDictionary *)getAllInfoWithTableName:(NSString *)table_name{

//    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
//
//    NSString *sql =[NSString stringWithFormat:@"SELECT * FROM '%@'",table_name];
//
//
//    FMResultSet *res = [_db executeQuery:sql];
//
//    while ([res next]) {
//        NSDictionary *dic = @{
//                              @"name":[res stringForColumn:@"name"],
//                              @"phone":[res stringForColumn:@"phone"],
//                              @"address":[res stringForColumn:@"address"],
//                              };
//
//        [dataArray addObject:dic];
//
//    }
//    NSDictionary *dic = @{
//        @"table_name":table_name,
//        @"array":dataArray
//    };
//    return dic;
    
    [queue inDatabase:^(FMDatabase *db) {
        [db open];
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        NSString *sql =[NSString stringWithFormat:@"SELECT * FROM '%@'",table_name];

        FMResultSet *res = [db executeQuery:sql];
        
        while ([res next]) {
            NSDictionary *dic = @{
                                  @"name":[res stringForColumn:@"name"],
                                  @"phone":[res stringForColumn:@"phone"],
                                  @"address":[res stringForColumn:@"address"],
                                  };
            
            [dataArray addObject:dic];
            
        }
//        NSDictionary *dic = @{
//            @"table_name":table_name,
//            @"array":dataArray
//        };
//        return dic;
        [db close];
    }];
    return nil;;
}

/**
 插入数据
 
 */
-(void)insertToDataBase:(NSArray *)array view:(UIView *)view toTableName:(NSString*)tableName
{
    
    [queue inDatabase:^(FMDatabase *db) {
        [db open];
        NSString *sql =[NSString stringWithFormat:@"create table if not exists '%@' (id integer primary key autoincrement,name text,phone text,address text);",tableName];

           BOOL success = [db executeUpdate:sql];

           if (success) {
               NSLog(@"创建%@表成功",tableName);
               
               [db beginTransaction];
               BOOL isRollBack = NO;
               @try {
                   for (NSDictionary *dic in array) {
                       NSString * name = StringFromObject([dic objectForKey:@"name"]);
                       NSString * phone = StringFromObject([dic objectForKey:@"phone"]);
                       NSString * address = StringFromObject([dic objectForKey:@"address"]);
                       NSString *searchString = [NSString stringWithFormat:@"select phone from '%@' where name='%@'",tableName,name];
                       
                       FMResultSet * searchResult = [db executeQuery:searchString];
                       
                       //判断是否有数据
                       
                       
                       if (searchResult.next) {

                       }else{
                           NSString *insertsql =[NSString stringWithFormat:@"insert into '%@' (name,phone,address) values ('%@','%@','%@')",tableName,name,phone,address];
                           
                           BOOL returnResult = [db executeUpdate:insertsql];
                           if (returnResult) {
                               NSLog(@"\n插入数据成功");
                           }else{
                               NSLog(@"\n插入数据失败");
                           }
                       }
                   }
               } @catch (NSException *exception) {
                   isRollBack = YES;
                   [db rollback];
                   [HUD hideHUDInView:view];
               } @finally {
                   if (!isRollBack) {
                       [db commit];
                   }
               }

           } else {
               NSLog(@"创建%@表失败",tableName);
           }
        [db close];
       }];
    
    
    
//    [queue inDatabase:^(FMDatabase *db) {
//
//
//
//        NSString *searchString = [NSString stringWithFormat:@"select phone from '%@' where name='%@'",tableName,name];
//
//        FMResultSet * searchResult = [db executeQuery:searchString];
//
//        //判断是否有数据
//
//
//        if (searchResult.next) {
//
////            NSString *updateString = [NSString stringWithFormat:@"update '%@' set phone='%@' where name = '%@'",tableName,phone,name];
//
//
//
//            //                    [db executeUpdate:updateString];
//        }else{
//            NSString *insertsql =[NSString stringWithFormat:@"insert into '%@' (name,phone) values ('%@','%@')",tableName,name,phone];
//
//            BOOL returnResult = [db executeUpdate:insertsql];
//            if (returnResult) {
//                NSLog(@"\n插入数据成功");
//            }else{
//                NSLog(@"\n插入数据失败");
//            }
//        }
//
//    }];

    
}


- (void)deleteTable:(NSString*)tableName{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [self->queue inDatabase:^(FMDatabase *db) {
            
            [db open];
            NSString *sql = [NSString stringWithFormat:@"DROP TABLE '%@'",tableName];
            
            [db executeUpdate:sql];
            [db close];
        }];
    });
}

- (void)deteleBatchKeyWord:(NSString *)key_word keywordArray:(NSArray *)keysArray user_id:(NSString *)user_id{
    
    [queue inDatabase:^(FMDatabase *db) {
        [db open];
        
        [db beginTransaction];
        BOOL isRollBack = NO;
        
        @try {
            for (NSDictionary *dic in keysArray) {
                NSString * key = StringFromObject([dic objectForKey:@"key"]);
                NSString * user_id = StringFromObject([dic objectForKey:@"user_id"]);
                NSString *table_name = [NSString stringWithFormat:@"%@-%@",user_id,key];
                
                NSLog(@"\n tablename %@",table_name);
                NSString *delete_sql = [NSString stringWithFormat:@"delete from '%@' where name like '%%%@%%'",table_name,key_word];
                
                BOOL res = [db executeUpdate:delete_sql];
                if (res) {
                    NSLog(@"\n删除数据成功");
                }else{
                    NSLog(@"\n删除数据失败");
                }
            }
        } @catch (NSException *exception) {
            isRollBack = YES;
            [db rollback];
        } @finally {
            if (!isRollBack) {
                [db commit];
            }
        }

        
        [db close];
       }];
    
    
}



+ (void)removeDataBase{
    NSString *filePath = [NSString stringWithFormat:@"%@juke.sqlite",[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"]];
    NSLog(@"%@",filePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];

    BOOL isDelete = [fileManager removeItemAtPath:filePath error:nil];
    if (isDelete) {
        NSLog(@"remove success");
    }else{
        NSLog(@"remove fail");
    }
}

@end
