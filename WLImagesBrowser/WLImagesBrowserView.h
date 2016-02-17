//
//  WLImagesBrowserView.h
//
//  Created by wanglei on 16/2/6.
//  Copyright © 2016年 wanglei. All rights reserved.
//  待完成滑动的回调

#import <UIKit/UIKit.h>
#import "WLSingleImageBrowserView.h"

typedef void(^scrollBlock)(UIScrollView *scrollView);
typedef void(^scrollEndBlock)(UIImage *currentDisplayImage);

//数据加载方式
typedef NS_ENUM(NSInteger, LoadImageDataPolicy) {
    LoadImageDataPolicyParalle = 0,    //所有页面同时开始加载, 默认方式
    LoadImageDataPolicySerial          //滑动到哪一页, 才加载哪一页, 还没有滑动过的页面暂时不加载
};

@interface WLImagesBrowserView : UIView

@property (nonatomic, assign) LoadImageDataPolicy loadImageDataPolicy;
@property (nonatomic, strong) UILabel *pageNumLabel;//页码 label
@property (nonatomic, assign) WLProgressViewType progressViewType;

//加载本地图片
-(instancetype)initWithFrame:(CGRect)frame
                      images:(NSMutableArray *)images
      verticalSeperatorWidth:(NSInteger)seperatorWidth
                 currentPage:(NSInteger)currentPage
                 showPageNum:(BOOL)showPageNum;

//加载网络图片
-(instancetype)initWithFrame:(CGRect)frame
                   imageURLs:(NSMutableArray *)imageURLs
           placeholderImages:(NSMutableArray *)placeholderImages
               failureImages:(NSMutableArray *)failureImages
      verticalSeperatorWidth:(NSInteger)seperatorWidth
                 currentPage:(NSInteger)currentPage
                 showPageNum:(BOOL)showPageNum;

//滑动图片时的回调
-(void)didScrollBlockHandle:(scrollBlock)scrollBlockHandle;

//滑动停止的回调,回调参数是当前显示的图片
-(void)didEndDecelerating:(scrollEndBlock)scrollEndBlockHandle;

@end
