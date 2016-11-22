//
//  StyleViewController.h
//  简单的风格相册
//
//  Created by 王奥东 on 16/11/17.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StyleViewController : UIViewController

@property(nonatomic, strong) NSArray *images;
@property(nonatomic, strong) UIScrollView *contentView;

-(id)initWithImages:(NSArray *)images;
-(void)placeImages;
-(CGSize)setFramesToImageViews:(NSArray *)imageViews toFitSize:(CGSize)frameSize;

@end
