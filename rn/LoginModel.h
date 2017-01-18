//
//  LoginModel.h
//  rn
//
//  Created by fanchuan on 17/1/17.
//  Copyright © 2017年 fanchuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>

@interface LoginModel : NSObject

@property (nonatomic, strong)RACCommand *command;

@property (nonatomic, strong)RACSignal *enabledSignal;

@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *pwd;

@end
