//
//  main.m
//  PlistTool
//
//  Created by dayan on 2020/4/27.
//  Copyright © 2020 dayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonTools.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //选择方式
        [[CommonTools sharedInstance] scanfCodeType];
        //获取文件路径
        NSString *fileString = [[CommonTools sharedInstance] getFileString];
        printf("\n");
        //获取plist文件
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:fileString];
        if (dict) {
//            NSLog(@"dict = %@",dict);
            //便利字典
            int i = 0;
            NSEnumerator *enumerator = [dict keyEnumerator];
            id key;
            NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
            while ((key = [enumerator nextObject]) != nil) {
                i = i + 1;
                printf("进度：%d/%ld\n",i,dict.allKeys.count);
//                NSLog(@"key:%@",key);
                id value = dict[key];
                NSLog(@"key:%@-------valueClass:%@",key,NSStringFromClass([value class]));
                if ([value isKindOfClass:NSClassFromString(@"__NSCFString")] || [value isKindOfClass:NSClassFromString(@"NSTaggedPointerString")] || [value isKindOfClass:NSClassFromString(@"__NSCFConstantString")]) {
                    //字符串
                    //直接对字符串进行解密
                    NSString *decodeValue = [[CommonTools sharedInstance] selectCodeType:[CommonTools sharedInstance].codeType code:value];
                    [mutableDict setValue:decodeValue forKey:key];
                }
                if ([value isKindOfClass:NSClassFromString(@"__NSCFNumber")]) {
                    //整形
                }
                if ([value isKindOfClass:NSClassFromString(@"__NSCFArray")]) {
                    //数组
                    //使用循环加密
                    NSMutableArray *array = [NSMutableArray array];
                    for (NSString *string in value) {
                        //加密/解密
                        NSString *decodeValue = [[CommonTools sharedInstance] selectCodeType:[CommonTools sharedInstance].codeType code:string];
                        [array addObject:decodeValue];
                    }
                    [mutableDict setValue:array forKey:key];
                }
                if ([value isKindOfClass:NSClassFromString(@"__NSCFDictionary")]) {
                    //字典
                    //再次遍历字典
                    for(NSString *valueKey in value){
                        //只判断字典
                        id dicValue = value[valueKey];
                        if([dicValue isKindOfClass:NSClassFromString(@"__NSCFArray")]){
                            for (NSString *string in dicValue) {
                                //加密解密
                                NSString *decodeValue = [[CommonTools sharedInstance] selectCodeType:[CommonTools sharedInstance].codeType code:string];
                                [mutableDict setValue:decodeValue forKey:valueKey];
                            }
                        }
                    }
                }
                if ([value isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
                    //布尔
                }
            }
 
            NSString *deskFile = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)objectAtIndex:0];
            printf("准备保存到桌面...\n");
            printf("请输入文件名称\n");
            char *filetring = malloc(sizeof(char) * 100);
            scanf("%s",filetring);
            deskFile = [NSString stringWithFormat:@"%@/%s.plist",deskFile,filetring];
            BOOL success = [mutableDict writeToFile:deskFile atomically:YES];
            if(success){
                //完成
                printf("完成！！！！\n");
                printf("保存到桌面\n");
            }else{
                printf("操作失败\n");
            }
        }
        else{
            NSLog(@"dictionary 数据为空");
        }
    }
    return 0;
}


//  /Users/dayan/Desktop/AppStringInfo.plist
