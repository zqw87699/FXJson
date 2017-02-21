//
//  FXJsonObject.m
//  TTTT
//
//  Created by 张大宗 on 2017/2/20.
//  Copyright © 2017年 张大宗. All rights reserved.
//

#import "FXJsonObject.h"

@implementation FXJsonObject

- (instancetype)initWithTypeName:(NSString *)typeName Name:(NSString *)name JsonName:(NSString *)jsonName NonJson:(BOOL)nonJson{
    self = [super init];
    if (self) {
        self.typeName=typeName;
        self.name=name;
        self.jsonName=jsonName;
        self.nonJson=nonJson;
    }
    return self;
}

- (void)setTypeName:(NSString *)typeName{
    _typeName = [typeName copy];
    if ([typeName isEqualToString:@"NSDate"]) {
        _type = FXObjectTypeDate;
    } else if ([typeName isEqualToString:@"NSString"]) {
        _type = FXObjectTypeString;
    } else if ([typeName isEqualToString:@"NSNumber"]) {
        _type = FXObjectTypeNumber;
    } else if ([typeName isEqualToString:@"NSSet"]) {
        _type = FXObjectTypeSet;
    } else if ([typeName isEqualToString:@"NSArray"]) {
        _type = FXObjectTypeArray;
    } else if ([typeName isEqualToString:@"NSDictionary"]) {
        _type = FXObjectTypeDictionary;
    } else {
        if ([NSClassFromString(typeName) conformsToProtocol:@protocol(IFXJsonObject)]) {
            _type = FXObjectTypeCustom;
        } else {
            _type = FXObjectTypeObject;
        }
    }
}

@end
