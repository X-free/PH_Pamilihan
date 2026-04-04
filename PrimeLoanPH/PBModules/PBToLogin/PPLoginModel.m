//
//Created by ESJsonFormatForMac on 23/10/30.
//

#import "PPLoginModel.h"

/** 用于模型存储 */
#define TempModelPath(x) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:x]

@implementation PPLoginModel

#pragma mark - 重写一下几个方法
- (void)encodeWithCoder:(NSCoder*)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}


#pragma mark - 解归档

//归档
+ (void)archiverWithModel:(PPLoginModel *)model {
    NSString *file = TempModelPath(@"PeraBoost_xinxi.data");
    NSDictionary *dic = [model yy_modelToJSONObject];
    BOOL isSuccess = [NSKeyedArchiver archiveRootObject:dic toFile:file];
    NSLog(@"LoginModel归档成功与否：%d", isSuccess);
}

//解当
+ (PPLoginModel *)unArchiver {
    //获取文件路径
    NSString *file = TempModelPath(@"PeraBoost_xinxi.data");
    //读取文件的内容
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    
    PPLoginModel *model = [PPLoginModel yy_modelWithDictionary:dic];
    //
    NSLog(@"解当----%@",dic);
    return model;
}

//删除
+(BOOL)removeRootObject{
    NSString *file = TempModelPath(@"PeraBoost_xinxi.data");
    return [self archiveRootObject:nil toFile:file];
}

+(BOOL)archiveRootObject:(id)obj toFile:(NSString *)path{
   return [NSKeyedArchiver archiveRootObject:obj toFile:path];
}

@end

@implementation PPLoginTheoreticalModel


@end


