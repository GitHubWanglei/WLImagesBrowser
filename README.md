# WLImagesBrowser
图片浏览器

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
