//
//  FlagModel.h
//  rn
//
//  Created by fanchuan on 17/1/10.
//  Copyright © 2017年 fanchuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FlagModel : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) CGFloat height;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
