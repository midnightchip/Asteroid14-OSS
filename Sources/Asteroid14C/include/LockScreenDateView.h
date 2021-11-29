#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

@interface SBFLockScreenDateView : UIView
@property (assign, nonatomic) CGRect restingFrame;
- (double)maximumSubtitleWidth;
- (void)setDateToTimeStretch:(double)arg1;
- (void)setSubtitleHidden:(BOOL)arg1;
- (void)setTextColor:(UIColor *)arg1;
- (void)_setSubtitleAlpha:(double)arg1;
- (double)subtitleBaselineOffsetFromOrigin;
- (void)setDateToTimeStretch:(double)arg1;
- (UIColor *)textColor;
- (CGRect)restingFrame;
- (void)setRestingFrame:(CGRect)arg1;
- (id)initWithFrame:(CGRect)frame;
- (void)setDate:(NSDate *)date;
- (double)subtitleBaselineOffsetFromOrigin;
@end

@interface SBFTouchPassThroughView : UIView
@end

@interface _SBSUIOrientedImageView : SBFTouchPassThroughView {

    UIImageView *_imageView;
    UIImage *_portraitImage;
    UIImage *_landscapeImage;
}
@property (nonatomic, retain)
    UIImage *portraitImage; //@synthesize portraitImage=_portraitImage - In the
                            // implementation block
@property (nonatomic, retain)
    UIImage *landscapeImage; //@synthesize landscapeImage=_landscapeImage - In
                             // the implementation block
- (void)layoutSubviews;
- (UIImage *)portraitImage;
- (UIImage *)landscapeImage;
- (void)setPortraitImage:(UIImage *)arg1;
- (void)setLandscapeImage:(UIImage *)arg1;
- (id)initWithFrame:(CGRect)arg1;
@end

@interface SBSUIWallpaperPreviewViewController : UIViewController
- (id)initWithImage:(UIImage *)image;
@end

@interface SBSUIWallpaperPreviewView : UIView
@property (nonatomic, retain) SBFLockScreenDateView *dateView;
@end