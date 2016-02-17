//
//  ViewController.m
//  imagesBrowser
//
//  Created by lihongfeng on 16/2/4.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "ViewController.h"
#import "WLSingleImageBrowserView.h"
#import "WLImagesBrowser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //------------------------------------------ 单页面加载网络图片 -------------------------------------------------
////    CGRect rect = CGRectMake(50, 50, 200, 300);
//    
//    WLSingleImageBrowserView *v = [[WLSingleImageBrowserView alloc] initWithFrame:self.view.bounds image:[UIImage imageNamed:@"placeholderImage.jpg"]];
//    v.progressViewType = ProgressViewTypeSingleCircle;
//    [self.view addSubview:v];
//    
////    NSString *urlString = @"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/12";
//    NSString *urlString = @"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1212/06/c1/16396010_1354784049722.jpg";
//    WLSingleImageBrowserView *v1 = [[WLSingleImageBrowserView alloc] initWithFrame:self.view.bounds
//                                                                         URLString:urlString
//                                                                  placeholderImage:[UIImage imageNamed:@"placeholderImage.jpg"]
//                                                                      failureImage:[UIImage imageNamed:@"failureImage"]];
//    
////    ProgressViewTypePlainCircle, ProgressViewTypeSystemIndicator, ProgressViewTypeNone
////    v1.progressViewType = ProgressViewTypePlainCircle;
//    [self.view addSubview:v1];
    
    
    //------------------------------------------ 多页面加载本地图片 -------------------------------------------------
//    NSMutableArray *images = [NSMutableArray array];;
//    for (int i = 0; i < 3; i++) {
//        [images addObject:[UIImage imageNamed:@"placeholderImage.jpg"]];
//    }
//    WLImagesBrowserView *imagesBrowserView = [[WLImagesBrowserView alloc] initWithFrame:self.view.bounds
//                                                                                 images:images
//                                                                 verticalSeperatorWidth:10
//                                                                            currentPage:2
//                                                                            showPageNum:YES];
//    imagesBrowserView.pageNumLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
//    imagesBrowserView.pageNumLabel.layer.cornerRadius = 12.5;
//    imagesBrowserView.pageNumLabel.layer.masksToBounds = YES;
//    [self.view addSubview:imagesBrowserView];
    
    //------------------------------------------ 多页面加载网络图片 -------------------------------------------------
    NSMutableArray *placeholderImages = [NSMutableArray array];;
    for (int i = 0; i < 3; i++) {
        [placeholderImages addObject:[UIImage imageNamed:@"placeholder"]];
    }
    NSMutableArray *imageURLs = [NSMutableArray array];;
//    for (int i = 0; i < 5; i++) {
//        [imageURLs addObject:@"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1212/06/c1/16396010_1354784049722.jpg"];
//    }
    [imageURLs addObject:@"http://img2.3lian.com/2014/f2/128/d/19.jpg"];
    [imageURLs addObject:@"http://up.qqjia.com/z/13/tu14804_6.jpg"];
    [imageURLs addObject:@"http://c.hiphotos.baidu.com/zhidao/pic/item/a686c9177f3e6709d391d3093bc79f3df9dc55b6.jpg"];
    [imageURLs addObject:@"http://img2.3lian.com/2014/f2/191/d/78.jpg"];
    [imageURLs addObject:@"http://img1.3lian.com/2015/w6/15/d/66.jpg"];
    
    WLImagesBrowserView *imagesBrowserView = [[WLImagesBrowserView alloc] initWithFrame:self.view.bounds
                                                                                 imageURLs:imageURLs
                                                                      placeholderImages:placeholderImages
                                                                          failureImages:nil
                                                                 verticalSeperatorWidth:20
                                                                            currentPage:1
                                                                            showPageNum:YES];
    imagesBrowserView.pageNumLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    imagesBrowserView.pageNumLabel.layer.cornerRadius = 12.5;
    imagesBrowserView.pageNumLabel.layer.masksToBounds = YES;
//    imagesBrowserView.backgroundColor = [UIColor cyanColor];
//    imagesBrowserView.progressViewType = ProgressViewTypePlainCircle;
//    imagesBrowserView.loadImageDataPolicy = LoadImageDataPolicySerial;
    
//    [imagesBrowserView didScrollBlockHandle:^(UIScrollView *scrollView) {
//        NSLog(@"contentOffset: %@", NSStringFromCGPoint(scrollView.contentOffset));
//    }];
//    [imagesBrowserView didEndDecelerating:^(UIImage *currentDisplayImage) {
//        NSLog(@"image: %@", currentDisplayImage);
//    }];
    
    [self.view addSubview:imagesBrowserView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
