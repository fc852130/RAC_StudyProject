//
//  TwoViewController.m
//  rn
//
//  Created by fanchuan on 17/1/16.
//  Copyright © 2017年 fanchuan. All rights reserved.
//

#import "TwoViewController.h"
#import "TwoViewModel.h"
#import "BookModel.h"

@interface TwoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)TwoViewModel *viewModel;


@end

@implementation TwoViewController

- (void)dealloc{
    NSLog(@"refresh");
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor redColor];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    UIBarButtonItem *t = [[UIBarButtonItem alloc] initWithTitle:@"request" style:UIBarButtonItemStylePlain target:self action:@selector(rrrrr)];
    self.navigationItem.rightBarButtonItem = t;
}


- (void)rrrrr{
    
    NSLog(@"执行command操作");
    
    @weakify(self);
    [[self.viewModel.command execute:nil] subscribeNext:^(id  _Nullable x) {
        
        
        @strongify(self);
        self.viewModel.dataArray = (NSArray *)x;
        [self.tableView reloadData];
        
    } error:^(NSError * _Nullable error) {
        @strongify(self);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"waring" message:error.domain preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:^{
           
            [NSThread sleepForTimeInterval:2];
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    BookModel *m = _viewModel.dataArray[indexPath.row];
    cell.textLabel.text = m.name;
    
    return cell;
}

#pragma mark ---- lazy

- (TwoViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [[TwoViewModel alloc] init];
    }
    return _viewModel;
}


@end
