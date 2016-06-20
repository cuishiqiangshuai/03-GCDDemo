//
//  ViewController.m
//  03-GCDDemo
//
//  Created by qingyun on 16/6/12.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "ViewController.h"

#define  Queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSString *)downFirst{
    [NSThread sleepForTimeInterval:3];
    return @"first Down";
}

-(NSString *)secondDown{
    [NSThread sleepForTimeInterval:2];
  return @"second down";
}

-(NSString *)thirdDown{
    [NSThread sleepForTimeInterval:3];
 return @"third down";
}

-(NSString *)lastDown{
    [NSThread sleepForTimeInterval:1];
    return @"last down";
}


-(void)getDispath{
    __weak ViewController *vc=self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //任务1
        NSString *firstStr=[vc downFirst];
        NSLog(@"-========%@",firstStr);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //任务2
            NSString *secondStr=[vc secondDown];
            NSLog(@"=====%@",secondStr);
        });
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //任务3
            NSString *thirdStr=[vc thirdDown];
            NSLog(@"=====%@",thirdStr);
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *fourstr=[vc lastDown];
            NSLog(@"=========%@",fourstr);
        });
        
    });
    //更新主线程操作
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"======主线程操作");
    });
}

-(void)GetGroupDispath{
    __weak ViewController *vc=self;
    dispatch_async(Queue , ^{
     //1.创建一个组
      dispatch_group_t group=dispatch_group_create();
     //2.fisrt
       NSString *str=[vc downFirst];
        NSLog(@"=====%@",str);
     //3.group和队列建立起关系,队列里的任务完成后,方便回调
       dispatch_group_async(group, Queue, ^{
           NSString *sec=[vc secondDown];
           NSLog(@"=======%@",sec);
        });
    
     //4.group和队列建立关系,队列里任务完成后,方便回调
        dispatch_group_async(group, Queue, ^{
            NSString *third=[vc thirdDown];
            NSLog(@"=====%@",third);
        });
 
     //5.group和队列建立起关系,队列里任务完成后,方便回调
        dispatch_group_async(group, Queue, ^{
            NSString *last=[vc lastDown];
            NSLog(@"======%@",last);
        });
        
      //6.当指定队列里,关联组的任务都执行完成,回调该函数
        dispatch_group_notify(group, Queue, ^{
            //刷新主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"=======刷新主线程");
            });
        });
    });


}




- (IBAction)touchAction:(id)sender {
    //[self getDispath];
    [self GetGroupDispath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
