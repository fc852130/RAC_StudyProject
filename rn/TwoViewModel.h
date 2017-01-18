//
//  TwoViewModel.h
//  rn
//
//  Created by fanchuan on 17/1/16.
//  Copyright © 2017年 fanchuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>

@interface TwoViewModel : NSObject

@property (nonatomic, strong)NSArray *dataArray;

@property (nonatomic, strong)RACCommand *command;

@end
