//
//  TestView.h
//  rn
//
//  Created by fanchuan on 17/1/12.
//  Copyright © 2017年 fanchuan. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const notificationTest;


@protocol TestViewDelegate <NSObject>

- (void)tap:(NSString *)aaa bbb:(NSString *)bbb;

@end

@interface TestView : UIView

@property (nonatomic, weak)id<TestViewDelegate> delegate;

@end
