
#import "InternetImage.h"
#import "UIImageView+WebCache.h"
@implementation InternetImage

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
    }
    return self;
}


-(void)startImageDownloadingWithUrl:(NSString*)urlToImage
{
    __block UIActivityIndicatorView *activityIndicator;
    __weak UIImageView *weakImageView = self;
   /* [self setImageWithURL:[NSURL URLWithString:urlToImage] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize)
     {
         if (!activityIndicator)
         {
             [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
             activityIndicator.center = weakImageView.center;
             //[activityIndicator startAnimating];
         }
     }
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
     {
         [activityIndicator removeFromSuperview];
         activityIndicator = nil;
     }];*/
}

-(void)startImageDownloadingWithUrl:(NSString*)urlToImage placeHolder:(UIImage *)placeHolderimage
{
    __block UIActivityIndicatorView *activityIndicator;
    __weak UIImageView *weakImageView = self;
    if(![urlToImage isKindOfClass:[NSNull class]]) {
   /* [self setImageWithURL:[NSURL URLWithString:urlToImage] placeholderImage:placeHolderimage options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize)
     {
         if (!activityIndicator)
         {
             [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
             activityIndicator.center = weakImageView.center;
            // [activityIndicator startAnimating];
         }
     }
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
     {
         [activityIndicator removeFromSuperview];
         activityIndicator = nil;
     }];*/
    }
}

@end
