//
//  TwoViewModel.m
//  rn
//
//  Created by fanchuan on 17/1/16.
//  Copyright © 2017年 fanchuan. All rights reserved.
//

#import "TwoViewModel.h"
#import <AFNetworking.h>
#import "BookModel.h"

@implementation TwoViewModel

- (instancetype)init{
    
    if(self = [super init]){
        [self bind];
    }
    
    return self;
}

- (void)bind{
    
    _command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"接收到input");
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"q"] = @"基础";
            NSLog(@"开始网路请求");

            [[AFHTTPSessionManager manager] GET:@"https://api.douban.com/v2/book/search" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"网路请求成功");

                NSArray *array = responseObject[@"books"][0][@"tags"];
                [subscriber sendNext:array];
                [subscriber sendCompleted];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"网路请求失败");

                [subscriber sendError:error];
                [subscriber sendCompleted];
            }];
            
            
            return nil;
        }];
  
        NSLog(@"打酱油111111111111");
       return  [signal map:^id _Nullable(NSArray * _Nullable value) {
        NSLog(@"1.map 映射 signal 转dic -> model");
         return  [[value.rac_sequence map:^id _Nullable(id  _Nullable value) {
             NSLog(@"2.map 映射 signal 转dic -> model");
               BookModel *m = [[BookModel alloc] init];
               m.name = value[@"name"];
               return m;
           }] array];
        }];
 
    }];
}

@end
