//
//  ViewController.m
//  简单的风格相册
//
//  Created by 王奥东 on 16/11/17.
//  Copyright © 2016年 王奥东. All rights reserved.


#import "ViewController.h"
#import "StyleViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
     StyleViewController *_styleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i <= 10; i++) {
        NSString *fileName = [NSString stringWithFormat:@"%i",i];
        [images addObject:[UIImage imageNamed:fileName]];
    }
    
    for (int i = 0; i <= 10; i++) {
        //打断图片顺序
        [images exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform(10)];
    }
    _styleView=[[StyleViewController alloc]initWithImages:images];
    [self.view addSubview:_styleView.view];
    
    
    
}

@end
