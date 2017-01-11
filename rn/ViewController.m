//
//  ViewController.m
//  rn
//
//  Created by fanchuan on 17/1/5.
//  Copyright © 2017年 fanchuan. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>
#import "FlagModel.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

/*
 RACSignal 信号类:一般表示将来有数据传递,只要有数据改变,信号内部收到数据,就会马上发送数据.
 RACSignal 只是表示当数据改变时,信号内部会发送数据,它本身并不具备发送信号的能力,发送信号由内部的订阅者去发送.
 一个信号默认时冷信号,就算数据发生改变也不会触发,只有订阅信号后才会变成热信号.值才会改变
 订阅信号:subscribeNext
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"loading success");
    
    _dataArray = @[@"RACSignal",
                   @"RACSubject",
                   @"RACReplaySubject",
                   @"RACTuple_RACSequence",
                   @"dicGetModel",
                   @"RACSequence_map",
                   @"RACCommand",
                   @"RACMulticastConnection"
                   ];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"cell" bundle:nil] forHeaderFooterViewReuseIdentifier:@"cell"];
    
}

#pragma mark - ReactiveCocoa
/*
 RACSignal
*/
- (void)RACSignal{
    //Simple user
    //1.创建信号源
   RACSignal *_signal =  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"发送信号");
        
        //block触发:每当有信号被订阅时,就会触发block
        
        //2.订阅者...发送信号
        [subscriber sendNext:@"123456"];
        
        //如果不在发送信号,最好在完成时,内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        
        
        return [RACDisposable disposableWithBlock:^{
            //block触发:当信号完成,或者发生错误时会调用该block取消订阅
            NSLog(@"信号被销毁");
        }];
    }];
    
    
    //3. 订阅信号
    [_signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"收到数据%@",x);
    }];
}


/*
 RACSubject : RACSignal
      信号提供者,自己可以充当信号,又能发送信号
      通常用来代替 delegate
 
 use: 和 signal 比较
     subscribeNext 只是把订阅者保存起来
     sendNext 发送信号,遍历刚刚保存的所有订阅者,一个一个调用订阅者的nextBlock
 */
- (void)RACSubject{
    //1.
    RACSubject *subject = [RACSubject subject];
    
    //2.
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"收到数据1==%@",x);

    }];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"收到数据2==%@",x);

    }];
    
    //3.
    [subject sendNext:@"1"];
}

/*
 RACReplaySubject : RACSubject
 重复信号提供类
 和 RACSubject 最大区别在于 他可以先发送信号,在订阅信号,RACSubject 不行
 
 use : 和 RACSubject 比较
       调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
       调用subscribeNext订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock
*/

- (void)RACReplaySubject{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"收到数据1==%@",x);
    }];
    
    [subject sendNext:@"1"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [subject subscribeNext:^(id  _Nullable x) {
            NSLog(@"收到数据2==%@",x);
        }];
    });
}

/**
 RACTuple  元组类,类似于 array 用来包装值
 RACSequence RAC中的集合类,用于替代 array , dictionary 可以使用它来快速遍历数组和字典。
 */
- (void)RACTuple_RACSequence{
    //1.遍历数组
    NSArray *array = @[@"1",@"2",@"3",@"4"];
    /**
    这里其实分为三步
    1.把数组转换成集合RACSequence numbers.rac_sequence
    2.把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    3.订阅信号，激活信号，会自动把集合中的所有值，遍历出来
     */
    [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"array:%@",x);
    }];
    
    
    //2.遍历dic
    //遍历出来的键值对会被包装成RACTuple对象
    NSDictionary *dic = @{@"name":@"seven",@"age":@17};
    [dic.rac_sequence.signal subscribeNext:^(RACTuple * _Nullable x) {
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
        // 相当于以下写法
        // NSString *key = x[0];
        //  NSString *value = x[1];
        
        NSLog(@"dic:%@ %@",key,value);
    }];
}


/**
 使用RACSequence & RACTuple
 */
- (void)dicGetModel{
    //3.dic -> model
    NSArray *people = @[@{
                            @"name":@"Lee",
                            @"age":@16,
                            @"height":@16.7f
                            },
                        @{
                            @"name":@"James",
                            @"age":@16,
                            @"height":@16
                            
                            }
                        ];
    
    NSMutableArray *flags = [NSMutableArray array];
    
    /**
     1.start 后 会先执行 success 方法 然后才会执行 loading ......
     */
    NSLog(@"dic -> model start");
    [people.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"dic -> model loading");
        FlagModel *model = [[FlagModel alloc] initWithDic:x];
        [flags addObject:model];
    }];
    NSLog(@"dic -> model success");
    [flags.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        FlagModel *model = (FlagModel *)x;
        NSLog(@"%@....%ld....%f",model.name,model.age,model.height);
    }];
}

- (void)RACSequence_map{
    //3.dic -> model
    NSArray *people = @[@{
                            @"name":@"Lee",
                            @"age":@16,
                            @"height":@16.7
                            },
                        @{
                            @"name":@"James",
                            @"age":@16,
                            @"height":@16
                            }
                        ];
   NSArray *modelArr = [[people.rac_sequence.signal map:^id _Nullable(id  _Nullable value) {
        return [[FlagModel alloc] initWithDic:value];
    }] toArray];
    NSLog(@"%@",modelArr);
}


/**
  RACCommand:RAC中用于处理事件的类，可以把事件如何处理,事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程。
  使用场景: buttonAction , InternetRequest
 */

/**
 use: 1.创建命令initWithSignalBlock:(RACSignal * (^)(id input))signalBlock
       2.在signalBlock中，创建RACSignal，并且作为signalBlock的返回值
       3.执行命令 - (RACSignal *)execute:(id)input
 warning: 1.signalBlock必须要返回一个信号，不能传nil.
          2.如果不想要传递信号，直接创建 空的信号 [RACSignal empty];
          3.RACCommand中信号如果数据传递完，必须调用 [subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
          4.RACCommand需要被强引用，否则接收不到RACCommand中的信号，因此RACCommand中的信号是延迟发送的。
 idea: 1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
       2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。
 // 四、如何拿到RACCommand中返回信号发出的数据。
 // 1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
 // 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。

   五、监听当前命令是否正在执行executing

 */
- (void)RACCommand{
    //1. 创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"2.执行命令");
        
        //空信号 RACCommand 必须返回信号
        //return [RACSignal empty];
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
           
            [subscriber sendNext:input];
          //  [subscriber sendError:[[NSError alloc] initWithDomain:@"Qaq" code:100000000 userInfo:@{@"1":@"2"}]];
          
            //warning : 数据传输完毕,最好调用该方法,这时候才执行完毕
            [subscriber sendCompleted];
            
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"8.信号被销毁");
            }];
        }];
    }];
    
    //command 的 executionSignals 订阅信号
    //1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
    [command.executionSignals subscribeNext:^(id  _Nullable x) {
        NSLog(@"4.收到信号");
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"6.%@",x);
        }];
    }];
    
    
    //switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"7.%@",x);
    }];
    
    
    //监听命令是否执行完毕,默认会来一次,可以直接跳过, skip表示跳过第一次信号
    [[command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"3.正在执行");
            
        }else{
            // 执行完成
            NSLog(@"9.执行完成");
        }
    }];
    
    
    //执行命令
    NSLog(@"1.start");
    [[command execute:@"12312312"] subscribeNext:^(id  _Nullable x) {
        NSLog(@"5.%@",x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"error boom !!!");
    }];
    
}


/**
 Demo
 用于当一个信号被多次订阅时,为了保证创建信号时,避免多次调用创建信号中的block,
 造成副作用,可以用该类处理
 
 alert :
 */

/**
 自己觉得可以用来多处使用同一段信息的场景
 */
- (void)RACMulticastConnection{
    
    //1. 创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"发送请求");
        [subscriber sendNext:@"QAQ"];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号销毁");
        }];
    }];
    
    //创建连接
    RACMulticastConnection *connect = [signal publish];
    
    //2. 订阅信号
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"收到信号1");
    }];
    
    //2. 订阅信号
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"收到信号2");
    }];
    
    [connect connect];

}


#pragma mark - tableview delegate & dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SEL method = NSSelectorFromString(_dataArray[indexPath.row]);
    [self performSelector:method withObject:nil];
}

@end
