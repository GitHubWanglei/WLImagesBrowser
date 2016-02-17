//
//  WLImagesBrowserView.m
//
//  Created by wanglei on 16/2/6.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "WLImagesBrowserView.h"

@interface WLImagesBrowserView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *imageURLs;
@property (nonatomic, strong) NSMutableArray *placeholderImages;
@property (nonatomic, strong) NSMutableArray *failureImages;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat seperatorWidth;//垂直分隔条宽度

@property (nonatomic, assign) NSInteger pageCount;//总页数
@property (nonatomic, assign) BOOL showPageNum;//是否显示页码
@property (nonatomic, assign) NSInteger currentPageNum;//当前页码

@property (nonatomic, strong) NSMutableArray *cacheData;//缓存数据

@property (nonatomic, strong) WLSingleImageBrowserView *lastView;//上一次查看的页面

@property (nonatomic, assign) scrollBlock scrollBlockHandle;
@property (nonatomic, assign) scrollEndBlock scrollEndBlockHandle;

@end

@implementation WLImagesBrowserView

#pragma mark - 初始化方法 1 - 加载本地图片
-(instancetype)initWithFrame:(CGRect)frame
                      images:(NSMutableArray *)images
      verticalSeperatorWidth:(NSInteger)seperatorWidth
                 currentPage:(NSInteger)currentPage
                 showPageNum:(BOOL)showPageNum{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        
        if (images.count > 0) {
            self.images = [NSMutableArray arrayWithArray:images];
            self.showPageNum = showPageNum;
            if (currentPage > 0 && currentPage <= self.images.count) {
                self.currentPageNum = currentPage - 1;
            }else{
                self.currentPageNum = 0;
            }
            if (seperatorWidth >= 0 && seperatorWidth <= 100) {
                self.seperatorWidth = seperatorWidth;
            }else{
                self.seperatorWidth = 20;
            }
            [self initView];
        }
        
    }
    return self;
}
#pragma mark - 初始化方法 2 - 加载网络图片
-(instancetype)initWithFrame:(CGRect)frame
                   imageURLs:(NSMutableArray *)imageURLs
           placeholderImages:(NSMutableArray *)placeholderImages
               failureImages:(NSMutableArray *)failureImages
      verticalSeperatorWidth:(NSInteger)seperatorWidth
                 currentPage:(NSInteger)currentPage
                 showPageNum:(BOOL)showPageNum{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        
        if (imageURLs.count > 0) {
            self.imageURLs = [NSMutableArray arrayWithArray:imageURLs];
            self.placeholderImages = [NSMutableArray arrayWithArray:placeholderImages];
            self.failureImages = [NSMutableArray arrayWithArray:failureImages];
            self.showPageNum = showPageNum;
            if (currentPage > 0 && currentPage <= self.imageURLs.count) {
                self.currentPageNum = currentPage - 1;
            }else{
                self.currentPageNum = 0;
            }
            if (seperatorWidth >= 0 && seperatorWidth <= 100) {
                self.seperatorWidth = seperatorWidth;
            }else{
                self.seperatorWidth = 20;
            }
            [self initView];
        }
        
    }
    return self;
}

#pragma mark - 加载页面
-(void)initView{
    
    self.cacheData = [NSMutableArray array];
    
    
    NSInteger pageCount = (self.images.count > 0) ? self.images.count : self.imageURLs.count;
    self.pageCount = pageCount;
    
    //flowLayout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0.0f;
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.itemSize = CGSizeMake(self.bounds.size.width + self.seperatorWidth, self.bounds.size.height);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = flowLayout.itemSize;
    
    //同时开始加载图片
    for (int i = 0; i < self.imageURLs.count; i++) {
        
        NSString *urlStr = self.imageURLs[i];
        
        CGRect subView_frame = CGRectMake(0,
                                          0,
                                          self.itemSize.width-self.seperatorWidth,
                                          self.itemSize.height);
        
        UIImage *placeholderImage;
        UIImage *failureImage;
        if (self.placeholderImages.count > 0 && i < self.placeholderImages.count) {
            placeholderImage = self.placeholderImages[i];
        }
        if (self.failureImages.count > 0 && i < self.failureImages.count) {
            failureImage = self.failureImages[i];
        }
        
        WLSingleImageBrowserView *subView = [[WLSingleImageBrowserView alloc] initWithFrame:subView_frame
                                                                                  URLString:urlStr
                                                                           placeholderImage:placeholderImage
                                                                               failureImage:failureImage];
        subView.tag = i;
        [self.cacheData addObject:subView];
        
        if (i == self.currentPageNum) {
            self.lastView = subView;
        }else{
            if (i == 0) {
                self.lastView = subView;
            }
        }
        
    }
    
    //collectionView
    CGRect cv_frame = CGRectMake(0, 0, self.bounds.size.width + self.seperatorWidth, self.bounds.size.height);
    UICollectionView *cv = [[UICollectionView alloc] initWithFrame:cv_frame collectionViewLayout:flowLayout];
    cv.delegate = self;
    cv.dataSource = self;
    cv.pagingEnabled = YES;
    cv.showsVerticalScrollIndicator = NO;
    cv.showsHorizontalScrollIndicator = NO;
    [cv registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView = cv;
    [self addSubview:cv];
    
    //添加页码 label
    if (self.showPageNum == YES) {
        CGFloat label_width = 50;
        CGFloat label_height = 25;
        CGFloat label_bottomMargin = 30;
        CGRect label_frame = CGRectMake((self.bounds.size.width - label_width) / 2.0,
                                        self.bounds.size.height - label_height - label_bottomMargin,
                                        label_width,
                                        label_height);
        UILabel *label = [[UILabel alloc] initWithFrame:label_frame];
        label.backgroundColor = [UIColor redColor];
        label.textColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"%ld/%ld", self.currentPageNum + 1, self.pageCount];
        label.textAlignment = NSTextAlignmentCenter;
        
        self.pageNumLabel = label;
        [self addSubview:self.pageNumLabel];
    }
    
    //设置初始显示第几页
    if (self.currentPageNum > 0) {
        CGPoint contentOffset = CGPointMake(self.itemSize.width * self.currentPageNum, 0);
        [self.collectionView setContentOffset:contentOffset];
    }
    
}

#pragma mark - UICollectionView delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return (self.images.count > 0) ? self.images.count : self.imageURLs.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    for (WLSingleImageBrowserView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }

    CGRect subView_frame = CGRectMake(0,
                                      0,
                                      cell.contentView.bounds.size.width-self.seperatorWidth,
                                      cell.contentView.bounds.size.height);
    WLSingleImageBrowserView *subView;
    
    if (self.images.count > 0) {//本地图片
        
        subView = [[WLSingleImageBrowserView alloc] initWithFrame:subView_frame image:self.images[indexPath.item]];
        subView.tag = indexPath.item;
        
        if (indexPath.item == self.currentPageNum) {
            self.lastView = subView;
        }else{
            if (indexPath.item == 0) {
                self.lastView = subView;
            }
        }
        
    }else{//网络图片
        
        if (indexPath.item > self.cacheData.count - 1 || self.cacheData.count == 0){//进行网络请求
            
            UIImage *placeholderImage;
            UIImage *failureImage;
            if (self.placeholderImages.count > 0 && indexPath.item < self.placeholderImages.count) {
                placeholderImage = self.placeholderImages[indexPath.item];
            }
            if (self.failureImages.count > 0 && indexPath.item < self.failureImages.count) {
                failureImage = self.failureImages[indexPath.item];
            }
            
            subView = [[WLSingleImageBrowserView alloc] initWithFrame:subView_frame
                                                            URLString:self.imageURLs[indexPath.item]
                                                     placeholderImage:placeholderImage
                                                         failureImage:failureImage];
            
            subView.tag = indexPath.item;
            [self.cacheData addObject:subView];
            
            if (indexPath.item == self.currentPageNum) {
                self.lastView = subView;
            }else{
                if (indexPath.item == 0) {
                    self.lastView = subView;
                }
            }
            
        }else{//从缓存中去取
            
            [cell.contentView addSubview:(WLSingleImageBrowserView *)self.cacheData[indexPath.item]];
        }
        
        
    }
    
    [cell.contentView addSubview:subView];
    cell.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat contentOffset_X = scrollView.contentOffset.x;
    
    if (contentOffset_X < 0 || contentOffset_X > self.itemSize.width * self.pageCount) {
        return;
    }
    
    self.currentPageNum  = (NSInteger)((contentOffset_X) / self.itemSize.width + 0.5);
    self.pageNumLabel.text = [NSString stringWithFormat:@"%ld/%ld", self.currentPageNum + 1, self.pageCount];
    
    //回调
    if (self.scrollBlockHandle != nil) {
        self.scrollBlockHandle(scrollView);
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
//    NSLog(@"currentPageNum: %ld", (long)self.currentPageNum);
    
    if (self.lastView != nil) {
        
        if (self.imageURLs.count > 0) {
            WLSingleImageBrowserView *tempView = [self.cacheData objectAtIndex:self.currentPageNum];
            
            if (self.lastView.tag != tempView.tag) {
                //上一次查看的图片如果是放大状态, 缩回正常大小
                [self.lastView recoveryImageViewSize];
            }
            
            self.lastView = tempView;
            
            //回调
            if (self.scrollEndBlockHandle != nil) {
                self.scrollEndBlockHandle(tempView.currentDisplayImage);
            }
            
        }else{
            
            if (self.lastView.tag != self.currentPageNum) {
                [self.lastView recoveryImageViewSize];
            }
            
            //回调
            UIImage *currentDisplayImage = self.images[self.currentPageNum];
            if (self.scrollEndBlockHandle != nil) {
                self.scrollEndBlockHandle(currentDisplayImage);
            }
            
        }
        
    }
    
}

#pragma mark - block回调
-(void)didScrollBlockHandle:(scrollBlock)scrollBlockHandle{
    if (scrollBlockHandle != nil) {
        self.scrollBlockHandle = scrollBlockHandle;
    }
}

-(void)didEndDecelerating:(scrollEndBlock)scrollEndBlockHandle{
    if (scrollEndBlockHandle != nil) {
        self.scrollEndBlockHandle = scrollEndBlockHandle;
    }
}

#pragma mark - other method
-(void)setLoadImageDataPolicy:(LoadImageDataPolicy)loadImageDataPolicy{
    switch (loadImageDataPolicy) {
        case LoadImageDataPolicyParalle:
        {
            //Do nothing here, default policy
            
        }
            break;
        case LoadImageDataPolicySerial:
        {
            self.cacheData = [NSMutableArray array];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }
            break;
            
        default:
            break;
    }
}

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    if (backgroundColor != nil && self.collectionView != nil) {
        [self.collectionView setBackgroundColor:backgroundColor];
    }
}

-(void)setProgressViewType:(WLProgressViewType)progressViewType{
    
    if (self.imageURLs.count > 0 && progressViewType != ProgressViewTypeSingleCircle) {
        for (WLSingleImageBrowserView *browser in self.cacheData) {
            browser.progressViewType = progressViewType;
        }
    }
    
}



@end





















