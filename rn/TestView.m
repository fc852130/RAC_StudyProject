//
//  TestView.m
//  rn
//
//  Created by fanchuan on 17/1/12.
//  Copyright © 2017年 fanchuan. All rights reserved.
//

#import "TestView.h"
#import <ReactiveObjC.h>

NSString *const notificationTest = @"test";


@implementation TestView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        for (int i = 0; i < 2; i++) {
            CGFloat itemWidth = 100;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i * itemWidth, 0, itemWidth, CGRectGetHeight(self.frame));
            [self addSubview:btn];
            btn.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
            btn.tag = i;
            switch (i) {
                case 0:
                    [btn setTitle:@"delegate" forState:UIControlStateNormal];
                    break;
                case 1:
                    [btn setTitle:@"notification" forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            
            //OC
          //[btn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];

            //RAC
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                switch (x.tag) {
                    case 0:
                        if(_delegate && [_delegate respondsToSelector:@selector(tap:bbb:)]){
                            [_delegate tap:@"1231" bbb:@"bbb"];
                        }
                        break;
                    case 1:
                        [[NSNotificationCenter defaultCenter] postNotificationName:notificationTest object:nil userInfo:@{@"q":@"a"}];
                        break;
                        
                    default:
                        break;
                }
            }];
        }
    }
    return self;
}

- (void)tap:(UIButton *)button{
    
    switch (button.tag) {
        case 0:
            if(_delegate && [_delegate respondsToSelector:@selector(tap:bbb:)]){
                [_delegate tap:@"1231" bbb:@"bbb"];
            }
            break;
            
        default:
            break;
    }
}

@end
