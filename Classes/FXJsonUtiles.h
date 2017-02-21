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

+(NSMutableArray*) getPropertys:(Class) clazz ;

+(id)fromJsonData:(NSData *)json class:(Class)clazz;

+(id)fromObject:(id) value propertyDesc:(FXJsonObject*) desc;

@end
