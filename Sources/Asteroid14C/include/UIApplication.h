#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FBBundleInfo : NSObject
@property (nonatomic, copy, readonly) NSString *bundleIdentifier;
@end

@interface FBApplicationInfo : FBBundleInfo
@property (nonatomic, retain, readonly) NSURL *executableURL;
@end

@interface SBApplicationInfo : FBApplicationInfo
@property (nonatomic, retain) Class iconClass;
@end

@interface SBApplication
@property (nonatomic, readonly) NSString *bundleIdentifier;
@property (nonatomic, readonly) SBApplicationInfo *info;

- (BOOL)isClassic;
@end

@interface SpringBoard : UIApplication
- (void)applicationDidFinishLaunching:(id)application;
- (SBApplication *)_accessibilityFrontMostApplication;
- (long long)activeInterfaceOrientation;
@end

#define isSpringBoardAtFront (![(SpringBoard *)[UIApplication sharedApplication] _accessibilityFrontMostApplication].bundleIdentifier)