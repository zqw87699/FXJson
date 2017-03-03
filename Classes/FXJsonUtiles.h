//
//  FXJsonUtiles.h
//  TTTT
//
//  Created by 张大宗 on 2017/2/17.
//  Copyright © 2017年 张大宗. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFXJsonObject.h"
#import "FXJsonObject.h"

@interface NSObject (FXJson)<IFXJsonObject>

-(instancetype) initWithFXJsonDictionary:(NSDictionary*) dictionary;

@end

@interface FXJsonUtiles : NSObject

/*
 *  获取指定类的所有属性
 */
+(NSMutableArray*) getPropertys:(Class) clazz ;

/*
 *  获取指定类指定属性的class
 */
+ (NSString*)getPropertyTypeNameByPropertyName:(NSString*)proName class:(Class)clazz;

/*
 *  将Json数据转换为指定类型(遵守IFXJsonObject协议)
 */
+(id)fromJsonData:(NSData *)json class:(Class)clazz;

/*
 *  转换FXJsonObject类型的数据
 */
+(id)fromObject:(id) value propertyDesc:(FXJsonObject*) desc;
/**
 *  返回NSDictionary 或者 NSArray
 */
+(id) fromJsonString:(NSString*) json;

/**
 *  返回NSDictionary 或者 NSArray
 */
+(id) fromJsonData:(NSData*)jsonData;

@end
