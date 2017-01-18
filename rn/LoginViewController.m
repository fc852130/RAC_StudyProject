//
//  LoginViewController.m
//  rn
//  人间最怕见天真
//  Created by fanchuan on 17/1/17.
//  Copyright © 2017年 fanchuan. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginModel.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic, strong) LoginModel *viewModel;

@property (nonatomic, strong) NSString *dynamicValue;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Login";
    
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self login];
    }];
    
    
    //该宏的作用是用于将某个对象的值和某个信号关联起来,动态改变
    RAC(self.viewModel,name) = _username.rac_textSignal;
    [_username.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
       
        NSLog(@"%@",self.viewModel.name);
    }];
    
    RAC(self.viewModel,pwd) = _password.rac_textSignal;
    
    //控制按钮是否可以点击
    RAC(self.loginBtn,enabled) = self.viewModel.enabledSignal;
    
}


- (void)login{
    
    
    [[self.viewModel.command execute:nil] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"登陆成功");
        [self.navigationController popViewControllerAnimated:YES];
        
    } error:^(NSError * _Nullable error) {
        NSLog(@"登录失败");
    }];
    
}


- (LoginModel *)viewModel{
    if(!_viewModel){
        _viewModel = [[LoginModel alloc] init];
    }
    return _viewModel;
}


@end
