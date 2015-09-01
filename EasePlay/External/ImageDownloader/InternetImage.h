
#import <UIKit/UIKit.h>

@interface InternetImage : UIImageView {
	
}
-(void)startImageDownloadingWithUrl:(NSString*)urlToImage;
-(void)startImageDownloadingWithUrl:(NSString*)urlToImage placeHolder:(UIImage *)placeHolderimage;
@end

