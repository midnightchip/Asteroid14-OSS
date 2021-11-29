#import "../../../asteroidpreferences/Sources/asteroidpreferencesC/UIImage+UIKitImage.h"
#import "../categories/UIImage+ScaledImage.h"
#import "./SBTelephonyManager.h"
#include "ConditionImageType.h"
#include "ConditionOption.h"
#include "ExceptionCatcher.h"
#import "LockScreenDateView.h"
#import "NCNotificationStructuredListViewController.h"
#import "SBUICallToActionLabel.h"
#import "SBUILegibilityLabel.h"
#import "StatusBarHeaders.h"
#include "UIApplication.h"
#import "WALockscreenWidgetViewController.h"
#import "WATodayModelObserver.h"
#include "WeatherPreferences.h"
#include "WeatherUpdater.h"
#include "WeatherViews.h"
#import <AltList/ATLApplicationListMultiSelectionController.h>
#import <MRYIPCCenter.h>
#import <MobileGestalt/MobileGestalt.h>
#import <UIKit/UIImage+Private.h>

CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void *, int,
    void *);

@interface _UIStatusBarDataStringEntry
@property (nonatomic, retain) NSString *stringValue;
@end

@interface _UIStatusBarData
@property (nonatomic, retain) _UIStatusBarDataStringEntry *timeEntry;
@end

@interface _UIStatusBar
@property (nonatomic, retain) _UIStatusBarData *currentData;
@end

@interface UIStatusBar_Modern
@property (nonatomic, retain) _UIStatusBar *statusBar;
@end
@interface UIApplication (asteroid)
- (UIStatusBar_Modern *)statusBar;
@end

@interface CLLocationManager (Private)
+ (void)setAuthorizationStatus:(BOOL)arg1 forBundleIdentifier:(NSString *)arg2;
+ (int)_authorizationStatusForBundleIdentifier:(NSString *)id bundle:(NSString *)bundle;
+ (BOOL)convertAuthStatusToBool:(int)status;
+ (void)setAuthorizationStatusByType:(int)arg1 forBundleIdentifier:(id)arg2;
- (void)requestWhenInUseAuthorizationWithPrompt;
@end

@interface ClassGetter : NSObject
+ (WALockscreenWidgetViewController *)waLockscreenWidgetViewController;
+ (SBTelephonyManager *)telephonyManager;
@end

@interface UIImage (Internal)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleID
                                               format:(int)format
                                                scale:(CGFloat)scale;
@end

@interface SBCoverSheetPrimarySlidingViewController : UIViewController
@end

@interface UIWindow (SETUP)
- (void)_setSecure:(BOOL)arg1;
@end
@interface SBIcon : NSObject
- (NSString *)leafIdentifier;
@end

@interface SBIconView : UIView
- (void)setIcon:(SBIcon *)arg1 animated:(BOOL)arg2;
@end

@interface SBIconImageView : UIView
@property (assign, nonatomic) SBIconView *iconView;
- (id)_currentOverlayImage;
- (UIImage *)_iconBasicOverlayImage;
- (CGRect)visibleBounds;
- (__kindof UIView *)viewWithTag:(NSInteger)tag;
@end
@interface SBHomeScreenView : UIView
// It should just know this...
@property (nonatomic, readonly) CGRect frame;
@property (assign, nonatomic) BOOL addedObserver;
@property (assign, nonatomic) WUIWeatherConditionBackgroundView *referenceView;
- (id)initWithFrame:(CGRect)arg1;
- (void)didMoveToWindow;
- (void)determineAnimationStatus;
- (void)handleNotification:(NSNotification *)notification;
- (void)pauseAnimation;
- (void)resumeAnimation;
@end

@interface SBDashBoardMainPageView : UIView
@end

@interface SBHomeScreenViewController : UIViewController
- (SBHomeScreenView *)homeScreenView;
@end

@interface SBUIBackgroundView : UIView
@end

@interface CSCoverSheetView : UIView
@property SBUIBackgroundView *backgroundView;
@end

@interface CSCoverSheetViewController : UIViewController
@property (nonatomic, getter=isShowingMediaControls) BOOL showingMediaControls;
- (CSCoverSheetView *)view;
- (CSCoverSheetView *)coverSheetView;
@end

@interface SBLockScreenManager {
    BOOL _isScreenOn;
}
+ (instancetype)sharedInstance;
@property (readonly) BOOL isLockScreenActive;
@property (readonly) BOOL isLockScreenVisible;
@property (readonly) BOOL isUILocked;
- (BOOL)isUIUnlocking;
- (BOOL)hasUIEverBeenLocked;
- (CSCoverSheetViewController *)coverSheetViewController;
@end
