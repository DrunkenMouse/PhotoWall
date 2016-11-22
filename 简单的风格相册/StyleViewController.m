//
//  StyleViewController.m
//  简单的风格相册
//
//  Created by 王奥东 on 16/11/17.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "StyleViewController.h"

@interface StyleViewController ()

@end

@implementation StyleViewController


//初始化
-(id)initWithImages:(NSArray *)images {
    if (self = [super init]) {
        self.images = images;
        self.view.backgroundColor = [UIColor blackColor];
    }
    return self;
}


-(void)loadView{
    [super loadView];
    
    self.contentView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    //与superView同等宽高
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:self.contentView];
    
    [self placeImages];
    
}

//放置图片
-(void)placeImages{
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray *imageViews = [NSMutableArray array];
    for (UIImage *image in self.images) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageViews addObject:imageView];
    }
    
    //根据图片数组算出scrollView所需的contentSize值
    CGSize newSize = [self setFramesToImageViews:imageViews toFitSize:self.contentView.frame.size];
    self.contentView.contentSize = newSize;
    
    for (UIImageView *imageView in imageViews) {
        [self.contentView addSubview:imageView];
    }
    
}

//算法有点难，不是很明白，直接拿去用吧。

//根据图片数组算出scrollView所需的contentSize值
-(CGSize)setFramesToImageViews:(NSArray <UIImageView *> *)imageViews toFitSize:(CGSize)frameSize {
    
    int imageCount = (int)imageViews.count;
    CGRect newFrames[imageCount];//将保存每张图片的frame
    float ideal_height = MAX(frameSize.height, frameSize.width) / 4;
    float seq[imageCount];//将保存每张图片的宽度
    float total_width = 0; //将保存图片的总宽度
    for (int i = 0; i < imageViews.count; i++) {
        
        UIImage *image = [[imageViews objectAtIndex:i] image];
        
        //图片高度固定下，对应比例的宽高
        CGSize newSize = CGSizeResizeToHeight(image.size, ideal_height);
        newFrames[i] = (CGRect){{0,0},newSize};
        seq[i] = newSize.width;
        total_width += seq[i];
    }
    
    int imageRow = (int)roundf(total_width / frameSize.width);//图片的总宽度与载体的宽度比，代表图片行数. roundf凑整
    //imageCount 图片的个数
    //imageRow 几行图片
    float M[imageCount][imageRow];
    float D[imageCount][imageRow];
    
    //D[imageCount][imageRow]初始化全部为0
    for (int i = 0; i < imageCount; i++) {
        for (int j = 0; j < imageRow; j++) {
            D[i][j] = 0;
        }
    }
    
    //M[imageCount][imageRow]0行i列的值都为第一张图片的宽度
    for (int i = 0; i < imageRow; i++) {
        M[0][i] = seq[0];
    }
    
    //M[imageCount][imageRow]每一行的第一列都为对应的第几张图片的宽度 + x
    //如果x = i ? M[i-1][0] : 0
    //如果i是M[i-1][0]则x = M[i-1][0]，否则x = 0
    for (int i = 0; i < imageCount; i++) {
        M[i][0] = seq[i] + (i ? M[i-1][0] : 0);
    }
    
    float cost;
 
    for (int i = 1; i < imageCount; i++) {
       
        for (int j = 1; j < imageRow; j++) {
            //初始化M[imageCount][imageRow]第二行往上(含)的第二列往上(含)每个数据为INT_MAX
            M[i][j] = INT_MAX;
            
            for (int k = 0; k < i; k++) {
                //获取最大值
                cost = MAX(M[k][j-1], M[i][0] - M[k][0]);
                if (M[i][j] > cost) {
                    M[i][j] = cost;
                    D[i][j] = k;
                }
            }
            
        }
        
    }
    
    int k1 = imageRow-1;
    int n1 = imageCount-1;
    int ranges[imageCount][2];
    
    while (k1 >= 0) {
        
        ranges[k1][0] = D[n1][k1] + 1;
        ranges[k1][1] = n1;
        
        n1 = D[n1][k1];
        k1--;
    }
    ranges[0][0] = 0;
    
    float cellDistance = 5;//图片间距
    float heightOffset = cellDistance; //载体的高度
    float widthOffset;
 
    float frameWidth;
    
    for (int i = 0; i < imageRow; i++) {
        float rowWidth = 0;
        frameWidth = frameSize.width - ((ranges[i][1] - ranges[i][0]) + 2)*cellDistance;
        
        for (int j = ranges[i][0]; j <= ranges[i][1]; j++) {
            rowWidth += newFrames[j].size.width;
        }
        
        float ratio = frameWidth / rowWidth;
        widthOffset = 0;
        
        for (int j = ranges[i][0]; j <= ranges[i][1]; j++) {
            newFrames[j].size.width *=  ratio;
            newFrames[j].size.height *= ratio;
            newFrames[j].origin.x = widthOffset + (j - (ranges[i][0]) +1 )*cellDistance;
            newFrames[j].origin.y = heightOffset;
            
            widthOffset += newFrames[j].size.width;
        }
        heightOffset += newFrames[ranges[i][0]].size.height + cellDistance;
    }
    
    for (int i = 0; i < imageCount; i++) {
        UIImageView *imgView = imageViews[i];
        imgView.frame = newFrames[i];
        [self.contentView addSubview:imgView];
    }
    
    return CGSizeMake(frameSize.width, heightOffset);
}

//高度不变，获取对应比例的宽度
static CGSize CGSizeResizeToHeight(CGSize size, CGFloat height) {
    size.width *= height / size.height;
    size.height = height;
    return size;
}


@end
