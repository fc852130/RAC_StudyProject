//
//  LoginModel.m
//  rn
//
//  Created by fanchuan on 17/1/17.
//  Copyright © 2017年 fanchuan. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel


- (instancetype)init{
    
    if(self = [super init]){
        [self bind];
    }
    
    return self;
}

- (void)bind{
    
    //监听账号的属性值改变，把他们聚合成一个信号。
    //combineLatest : 将多个信号合并,并且拿到各个信号的最新值,并且每个合并的signal必须有过一次 sendNext 才会触发合并过后的信号
    //reduce 用于信号发出的内容是元组，把信号发出元组的值聚合成一个值
    _enabledSignal = [RACSignal combineLatest:@[RACObserve(self, name),RACObserve(self, pwd)] reduce:^id(NSString *account,NSString *pwd){
        
        return @(account.length >= 6 && pwd.length >= 6);
        
    }];
    
    [_enabledSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"enabled=====:%@",x);
    }];
    
    
    _command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
       
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
           
            // 模仿网络延迟
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                int a = arc4random()%(1 - 0 + 1) + 0;
                if(a){
                    [subscriber sendNext:@"登录成功"];
                }else{
                    NSError *err = [[NSError alloc] initWithDomain:@"1@" code:100000 userInfo:nil];
                    [subscriber sendError:err];
                }
                
                //数据传送完毕，必须调用完成，否则命令永远处于执行状态
                [subscriber sendCompleted];
            });
            return nil;
        }];
    }];

    //这样是收不到错误信息的
//    [_command.executionSignals.switchToLatest subscribeError:^(NSError * _Nullable error) {
//        
//    }];
    //我们应该这样
    [_command.errors subscribeNext:^(NSError * _Nullable x) {
        NSLog(@"errrrrrror");
    }];
    
    
    
    [[_command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
       
        if([x boolValue] == YES){
            NSLog(@"正在执行");
        }else{
            NSLog(@"登录操作完成");
        }
        
    }];
    
}

@end
