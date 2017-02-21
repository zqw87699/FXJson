//
//  FXJsonUtiles.m
//  TTTT
//
//  Created by 张大宗 on 2017/2/17.
//  Copyright © 2017年 张大宗. All rights reserved.
//

#import "FXJsonUtiles.h"
#import <objc/runtime.h>

@implementation NSObject (FXJson)

- (instancetype) initWithFXJsonDictionary:(NSDictionary *)dictionary{
    if ([self init]) {
        NSArray *allPropertys = [FXJsonUtiles getPropertys:[self class]];
        for (FXJsonObject *object in allPropertys) {
            if ([object nonJson]) {
                continue;
            }
            id value = dictionary[object.jsonName];
            if (value && value != [NSNull null]) {
                id returnValue = [FXJsonUtiles fromObject:value propertyDesc:object];
                if (returnValue && (returnValue != [NSNull null])) {
                    [self setValue:returnValue forKey:object.name];
                }
            }
        }
    }
    return self;
}

/**
 *  属性到JSON属性名称映射
 */
+(NSDictionary*) fxPropertyToJsonPropertyDictionary {
    return nil;
}

/**
 *  非JSON属性列表
 */
+(NSSet*) fxNonJsonPropertys {
    return nil;
}

/**
 *  容器属性类型
 *  key：属性名称
 *  value：类型（Class）支持NSDictionary，NSSet，NSArray
 */
+(NSDictionary*) fxContainerPropertysGenericClass {
    return nil;
}

+(NSString *)fxPropertyDateFormatString:(NSString *)property {
    return @"YYYY-MM-dd'T'HH:mm:ssZ";//Default ISO8601
}

@end

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

//忽略属性名称列表
static NSSet *ignorePropertyNames = nil;
//数字类型名称列表
static NSSet *numberTypeNames = nil;

@implementation FXJsonUtiles

+(void)load {
    ignorePropertyNames = [[NSSet alloc] initWithObjects:@"superclass",@"hash",@"debugDescription",@"description", nil];
    numberTypeNames = [[NSSet alloc] initWithObjects:@"B",@"i",@"I",@"d",@"D",@"c",@"C",@"f",@"l",@"L",@"s",@"S",@"q",@"Q", nil];
}

+(id) fromObject:(id) value propertyDesc:(FXJsonObject*) desc {
    FXObjectType t = desc.type;
    id returnValue = nil;
    switch (t) {
        case FXObjectTypeArray:
        {
            Class genericClazz = [desc genericClass];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (id o in value) {
                if (genericClazz) {
                    id v = [[genericClazz alloc] initWithFXJsonDictionary:o];
                    if (v) {
                        [array addObject:v];
                    }
                } else {
                    id v = [self fromObject:o propertyDesc:nil];
                    if (v) {
                        [array addObject:v];
                    }
                }
            }
            returnValue = array;
        }
            break;
        case FXObjectTypeSet:
        {
            Class genericClazz = [desc genericClass];
            NSMutableSet *set = [[NSMutableSet alloc] init];
            for (id o in value) {
                if (genericClazz) {
                    id v = [[genericClazz alloc] initWithFXJsonDictionary:o];
                    if (v) {
                        [set addObject:v];
                    }
                } else {
                    id v = [self fromObject:o propertyDesc:nil];
                    if (v) {
                        [set addObject:v];
                    }
                }
            }
            returnValue = set;
        }
            break;
        case FXObjectTypeDate:
        {
            NSString *dfs = [desc dateFormat];
            if (dfs) {
                NSDateFormatter*fxDateFormat = [[NSDateFormatter alloc] init];
                [fxDateFormat setDateFormat:dfs];
                returnValue = [fxDateFormat stringFromDate:value];
            }
        }
            break;
        case FXObjectTypeNumber:
        {
            returnValue = value;
        }
            break;
        case FXObjectTypeString:
        {
            returnValue = value;
        }
            break;
        case FXObjectTypeDictionary:
        {
            NSDictionary *genericClazzDict = [desc genericClassDict];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            NSArray *allKeys = [value allKeys];
            for (NSString *key in allKeys) {
                id o = value[key];
                Class genericClazz = genericClazzDict[key];
                id v = nil;
                if (genericClazz && [o isKindOfClass:[NSDictionary class]]) {
                    v = [[genericClazz alloc] initWithFXJsonDictionary:o];
                } else {
                    v = [self fromObject:o propertyDesc:nil];
                }
                if (v) {
                    [dict setObject:v forKey:key];
                }
            }
            returnValue = dict;
        }
            break;
        case FXObjectTypeCustom:
        {
            Class clazz = NSClassFromString(desc.typeName);
            returnValue = [[clazz alloc] initWithFXJsonDictionary:value];
        }
            break;
        default:
        {
            returnValue = value; //FXObjectTypeObject
        }
            break;
    }
    return returnValue;
}

+(id)fromJsonData:(NSData *)json class:(Class)clazz {
    if (json) {
        if ([clazz conformsToProtocol:@protocol(IFXJsonObject)]) {
            NSError *error;
            id o = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:&error];
            if (error) {
                @throw [NSException exceptionWithName:@"FXJSONException" reason:[error userInfo][NSLocalizedDescriptionKey] userInfo:[error userInfo]];
            } else {
                if (![o isKindOfClass:[NSDictionary class]]) {
                    NSString *reason = [NSString stringWithFormat:@"%@ 类型无法解析此json",NSStringFromClass(clazz)];
                    @throw [NSException exceptionWithName:@"FXJSONException" reason:reason userInfo:@{NSLocalizedDescriptionKey:reason}];
                } else {
                    return [[clazz alloc] initWithFXJsonDictionary:o];
                }
            }
        } else {
            NSString *reason = @"非IFXJsonObject对象";
            @throw [NSException exceptionWithName:@"FXJSONException" reason:reason userInfo:@{NSLocalizedDescriptionKey:reason}];
        }
    }
    return nil;
}

+ (NSMutableArray*) getPropertys:(Class)clazz{
    if (clazz == [NSObject class]) {
        return nil;
    }
    unsigned int count = 0;
    //获取属性的列表
    objc_property_t *propertyList =  class_copyPropertyList([clazz class], &count);
    
    NSDictionary*jsonMap=[clazz fxPropertyToJsonPropertyDictionary];
    NSSet *nonJsonSet = [clazz fxNonJsonPropertys];
    NSDictionary *genericClassNameDict = [clazz fxContainerPropertysGenericClass];
    NSMutableArray *propertyArray = [self getPropertys:[clazz superclass]];
    if (!propertyArray) {
        propertyArray = [[NSMutableArray alloc] init];
    }
    
    for(int i=0;i<count;i++)
    {
        //取出每一个属性
        objc_property_t property = propertyList[i];
        //获取每一个属性的变量名
        const char* propertyName = property_getName(property);
        NSString *proName = [NSString stringWithUTF8String:propertyName];
        if ([ignorePropertyNames containsObject:proName]) {
            continue;
        }
        
        NSString *typeName = [self getPropertyTypeName:property];
        NSString *jsonName = jsonMap[proName];
        if (!jsonName) {
            jsonName = proName;
        }
        
        BOOL isNonJson = NO;
        if ([nonJsonSet containsObject:proName]) {
            isNonJson = YES;
        }
        
        FXJsonObject *object = [[FXJsonObject alloc] initWithTypeName:typeName Name:proName JsonName:jsonName NonJson:isNonJson];
        switch (object.type) {
            case FXObjectTypeDate:
            {
                NSString *df = [clazz fxPropertyDateFormatString:proName];
                [object setDateFormat:df];
            }
                break;
            default:
                break;
        }
        
        switch (object.type) {
            case FXObjectTypeArray:
            {
                Class clazz = genericClassNameDict[proName];
                if ([clazz conformsToProtocol:@protocol(IFXJsonObject)]) {
                    [object setGenericClass:clazz];
                }
            }
                break;
            case FXObjectTypeSet:
            {
                Class clazz = genericClassNameDict[proName];
                if ([clazz conformsToProtocol:@protocol(IFXJsonObject)]) {
                    [object setGenericClass:clazz];
                }
            }
                break;
            case FXObjectTypeDictionary:
            {
                id value = genericClassNameDict[proName];
                if ([value isKindOfClass:[NSDictionary class]]) {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    NSArray *allKeys = [value allKeys];
                    for (NSString *key in allKeys) {
                        Class clazz = value[key];
                        if ([clazz conformsToProtocol:@protocol(IFXJsonObject)]) {
                            [dict setObject:clazz forKey:key];
                        }
                    }
                    if ([dict count] > 0) {
                        [object setGenericClassDict:dict];
                    }
                }
            }
                break;
            default:
                break;
        }
        
        [propertyArray addObject:object];
    }
    //c语言的函数，所以要去手动的去释放内存
    free(propertyList);
    
    return propertyArray;
    
}

+ (NSString*)getPropertyTypeNameByPropertyName:(NSString*)proName class:(Class)clazz{
    if (proName != nil && [proName isKindOfClass:[NSString class]]) {
        objc_property_t property = class_getProperty([clazz class], [proName cStringUsingEncoding:NSUTF8StringEncoding]);
        return [self getPropertyTypeName:property];
    }
    return nil;
}

+(NSString*) getPropertyTypeName:(objc_property_t) property {
    const char *attributes = property_getAttributes(property);
    NSString *attributeStr = [[NSString alloc] initWithBytes:attributes length:strlen(attributes) encoding:NSUTF8StringEncoding];
    NSString *a1 = [[[attributeStr componentsSeparatedByString:@","] objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString *typeName = nil;
    if ([a1 hasPrefix:@"T@"]) {
        typeName = [[NSString alloc] initWithString:[a1 substringWithRange:NSMakeRange(2, a1.length-2)]];
    } else {
        if (a1.length >= 2) {
            typeName = [a1 substringWithRange:NSMakeRange(1, a1.length-1)];
            if ([numberTypeNames containsObject:typeName]) {
                typeName = @"NSNumber";
            }
        }
    }
    return typeName;
}

@end
