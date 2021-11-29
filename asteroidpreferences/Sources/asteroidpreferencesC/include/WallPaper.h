#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SBWallpaperImage : UIImage
@property (nonatomic, copy, readonly) NSURL *wallpaperFileURL;
@end

@interface SBFWallpaperOptions : NSObject
@end

@interface SBFGradient : NSObject
@end

@interface SBFWallpaperConfiguration : NSObject
@property (nonatomic, readonly) long long
    variant; //@synthesize variant=_variant - In the implementation block
@property (assign, nonatomic)
    BOOL needsWallpaperDimmingTreatment; //@synthesize
                                         // needsWallpaperDimmingTreatment=_needsWallpaperDimmingTreatment
                                         //- In the implementation block
@property (nonatomic, retain) SBWallpaperImage *wallpaperImage; //@synthesize wallpaperImage=_wallpaperImage - In the
                                                                // implementation block
@property (nonatomic, retain)
    UIImage *wallpaperOriginalImage; //@synthesize
                                     // wallpaperOriginalImage=_wallpaperOriginalImage
                                     //- In the implementation block
@property (nonatomic, retain)
    UIImage *wallpaperThumbnailImage; //@synthesize
                                      // wallpaperThumbnailImage=_wallpaperThumbnailImage
                                      //- In the implementation block
@property (nonatomic, copy)
    NSData *wallpaperThumbnailImageData; //@synthesize
                                         // wallpaperThumbnailImageData=_wallpaperThumbnailImageData
                                         //- In the implementation block
@property (nonatomic, copy)
    NSData *wallpaperImageHashData; //@synthesize
                                    // wallpaperImageHashData=_wallpaperImageHashData
                                    //- In the implementation block
@property (nonatomic, copy)
    NSDictionary *proceduralWallpaperInfo; //@synthesize
                                           // proceduralWallpaperInfo=_proceduralWallpaperInfo
                                           //- In the implementation block
@property (nonatomic, copy) NSURL *videoURL; //@synthesize videoURL=_videoURL - In the implementation block
@property (nonatomic, copy)
    NSURL *originalVideoURL; //@synthesize originalVideoURL=_originalVideoURL -
                             // In the implementation block
@property (nonatomic, copy) SBFWallpaperOptions *wallpaperOptions; //@synthesize wallpaperOptions=_wallpaperOptions - In the
                                                                   // implementation block
@property (nonatomic, copy)
    UIColor *wallpaperColor; //@synthesize wallpaperColor=_wallpaperColor - In
                             // the implementation block
@property (nonatomic, copy) NSString *wallpaperColorName; //@synthesize wallpaperColorName=_wallpaperColorName -
                                                          // In the implementation block
@property (nonatomic, copy) SBFGradient *wallpaperGradient; //@synthesize wallpaperGradient=_wallpaperGradient - In
                                                            // the implementation block
@property (nonatomic, readonly)
    long long wallpaperType; //@synthesize wallpaperType=_wallpaperType - In the
                             // implementation block
@property (nonatomic, copy, readonly) NSString *proceduralWallpaperIdentifier;
@property (nonatomic, copy, readonly) NSDictionary *proceduralWallpaperOptions;
@property (readonly) unsigned long long hash;
@property (readonly) Class superclass;
@property (copy, readonly) NSString *description;
@property (copy, readonly) NSString *debugDescription;
@end

@interface SBFWallpaperView : UIView
@end

@interface SBFStaticWallpaperView : SBFWallpaperView
- (id)initWithFrame:(CGRect)arg1
      configuration:(SBFWallpaperConfiguration *)arg2
            variant:(long long)arg3
         cacheGroup:(id)arg4
           delegate:(id)arg5
            options:(unsigned long long)arg6;
@end

@interface SBFWallpaperConfigurationManager : NSObject
@property (assign, nonatomic) BOOL
    cachedVariantsShareWallpaperConfiguration; //@synthesize
                                               // cachedVariantsShareWallpaperConfiguration=_cachedVariantsShareWallpaperConfiguration
                                               //- In the implementation block
@property (assign, getter=isCachedVariantsShareWallpaperConfigurationValid,
    nonatomic)
    BOOL cachedVariantsShareWallpaperConfigurationValid; //@synthesize
                                                         // cachedVariantsShareWallpaperConfigurationValid=_cachedVariantsShareWallpaperConfigurationValid
                                                         //- In the
                                                         // implementation block
@property (nonatomic, copy, readonly)
    NSArray *dataStores; //@synthesize dataStores=_dataStores - In the
                         // implementation block
//@property (assign,nonatomic,__weak)
// id<SBFWallpaperConfigurationManagerDelegate> delegate; //@synthesize
// delegate=_delegate - In the implementation block
@property (nonatomic, readonly)
    CGSize wallpaperSize; //@synthesize wallpaperSize=_wallpaperSize - In the
                          // implementation block
@property (nonatomic, readonly) CGSize wallpaperSizeIncludingParallaxOverhang;
@property (nonatomic, readonly)
    double wallpaperScale; //@synthesize wallpaperScale=_wallpaperScale - In the
                           // implementation block
@property (assign, nonatomic)
    long long wallpaperMode; //@synthesize wallpaperMode=_wallpaperMode - In the
                             // implementation block
@property (assign, nonatomic)
    BOOL enableWallpaperDimming; //@synthesize
                                 // enableWallpaperDimming=_enableWallpaperDimming
                                 //- In the implementation block
@property (nonatomic, readonly) long long
    wallpaperSizeType; //@synthesize wallpaperSizeType=_wallpaperSizeType - In
                       // the implementation block
@property (nonatomic, readonly) long long parallaxDeviceType;
@property (nonatomic, copy, readonly)
    SBFWallpaperConfiguration *lockScreenWallpaperConfiguration;
@property (nonatomic, copy, readonly)
    SBFWallpaperConfiguration *homeScreenWallpaperConfiguration;
@property (nonatomic, readonly) BOOL variantsShareWallpaperConfiguration;
@property (nonatomic, readonly) unsigned long long numberOfCachedStaticImages;
//@property (assign,nonatomic,__weak) id<SBFProceduralWallpaperProvider>
// proceduralWallpaperProvider; //@synthesize
// proceduralWallpaperProvider=_proceduralWallpaperProvider - In the
// implementation block
//@property (nonatomic,retain) SBFMagnifyMode * magnifyMode; //@synthesize
// magnifyMode=_magnifyMode - In the implementation block
@property (readonly) unsigned long long hash;
@property (readonly) Class superclass;
@property (copy, readonly) NSString *description;
@property (copy, readonly) NSString *debugDescription;
+ (void)initialize;
@end
