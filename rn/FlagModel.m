//
//  FlagModel.m
//  rn
//
//  Created by fanchuan on 17/1/10.
//  Copyright © 2017年 fanchuan. All rights reserved.
//

#import "FlagModel.h"

@implementation FlagModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if(self){
        _name = dic[@"name"];
        _age = [dic[@"age"] integerValue];
        _height = [dic[@"height"] floatValue];
    }
    return self;
}

@end
