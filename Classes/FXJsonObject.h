//
//  FXJsonObject.h
//  TTTT
//
//  Created by 张大宗 on 2017/2/20.
//  Copyright © 2017年 张大宗. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFXJsonObject.h"
/**
 *  对象类型
 */
typedef NS_ENUM(NSInteger, FXObjectType) {
    FXObjectTypeObject,//任意类型自定义
    FXObjectTypeDictionary,//词典类型
    FXObjectTypeArray,//数组类型
    FXObjectTypeSet,//集合类型
    FXObjectTypeNumber,//数字类型
    FXObjectTypeString,//字符串类型
    FXObjectTypeDate,//日期类型
    FXObjectTypeCustom,//自定义类型
};

@interface FXJsonObject : NSObject

@property (nonatomic,assign) FXObjectType type;

@property (nonatomic,strong) NSString *name;//属性名称

@property (nonatomic,strong) NSString *jsonName;//属性对应的json名称

@property (nonatomic,strong) NSString *typeName;//类型名

@property (nonatomic, assign) BOOL nonJson;//是否为非序列化属性（Default NO）

@property (nonatomic, copy) NSString *dateFormat;//日期格式化字符串

@property (nonatomic) Class genericClass;//泛型（NSArray，NSSet）

@property (nonatomic, strong) NSDictionary *genericClassDict;//词典泛型（NSDictionary）

- (instancetype)initWithTypeName:(NSString*)typeName Name:(NSString*)name JsonName:(NSString*)jsonName NonJson:(BOOL)nonJson;

@end
