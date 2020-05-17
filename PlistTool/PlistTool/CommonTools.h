//
//  CommonTools.h
//  PlistTool
//
//  Created by dayan on 2020/4/28.
//  Copyright © 2020 dayan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//enum CodeType {
//    CodeTypeEncode,
//    CodeTypeDencode,
//};
//
//typedef enum CodeType codeType;
typedef NS_ENUM(NSInteger, CodeType){
    CodeTypeEncode  = 0,
    CodeTypeDencode,
};

@interface CommonTools : NSObject

@property (nonatomic,assign) CodeType codeType;

-(NSString *)getFileString;

+ (instancetype)sharedInstance;

//选择加密方式
- (NSString *)selectCodeType:(CodeType)codeType code:(NSString *)code;

//加密
- (NSString *)encode:(NSString *)string;

//解密
- (NSString *)dencode:(NSString *)base64String;

//选择方式
-(void)scanfCodeType;
    
@end

NS_ASSUME_NONNULL_END
