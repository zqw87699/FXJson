//
//  IFXJsonObject.h
//  TTTT
//
//  Created by 张大宗 on 2017/2/17.
//  Copyright © 2017年 张大宗. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Json对象协议，所有需要解析的对象必须实现此协议
 */
@protocol IFXJsonObject <NSObject>

/**
 *  属性到Json属性的映射
 */
+(NSDictionary*) fxPropertyToJsonPropertyDictionary;

/**
 *  非Json属性列表
 */
+(NSSet*) fxNonJsonPropertys;

/**
 *  容器属性类型
 *  key：属性名称
 *  value：类型（Class）支持NSDictionary，NSSet，NSArray
 *  {
 *      @"users" : [UserDTO class],
 *      @"dict" : {
 *                   @"key1" : [DTOClass1 class],
 *                   @"key2" : [DTOClass2 class]
 *                }
 *  }
 */
+(NSDictionary*) fxContainerPropertysGenericClass;


/**
 *  日期属性Format字符串
 */
+(NSString*) fxPropertyDateFormatString:(NSString*) property;

@end
