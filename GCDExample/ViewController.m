//
//  ViewController.m
//  GCDExample
//
//  Created by yuyuan on 15/7/30.
//  Copyright (c) 2015年 yuyuan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 200)];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:@"http://h.hiphotos.baidu.com/zhidao/wh%3D600%2C800/sign=d8d47aee8435e5dd9079add946f68bd7/f31fbe096b63f624fc76a3bf8644ebf81a4ca367.jpg"];
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.imageView.image = img;
            });
        }
    });
    
//    [self dispatchGroup];
//    [self dispatchBarrier];
    
    [self.view addSubview:_imageView];
}

-(void)dispatchBarrier{
    dispatch_queue_t queue = dispatch_queue_create("gcdtest.rongfzh.yc", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"dispatch_async1");
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"dispatch_async2");
    });
    dispatch_barrier_async(queue, ^{
        NSLog(@"dispatch_barrier_async");
        [NSThread sleepForTimeInterval:4];
        
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"dispatch_async3");   
    });
}

-(void)dispatchGroup{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"group1");
    });
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"group2");
    });
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"group3");
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"updateUi");
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
