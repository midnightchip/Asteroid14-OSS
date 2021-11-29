#import "include/Tweak.h"

#pragma clang diagnostic ignored "-Wincomplete-implementation" // Silence that warning if you want
@implementation ClassGetter
+ (WALockscreenWidgetViewController *)waLockscreenWidgetViewController {
    if (UIScreen.mainScreen) {
        return [[%c(WALockscreenWidgetViewController) alloc] init];
    } 
    return nil;
}
+ (SBTelephonyManager *)telephonyManager {
    return [%c(SBTelephonyManager) sharedTelephonyManager];
}
@end