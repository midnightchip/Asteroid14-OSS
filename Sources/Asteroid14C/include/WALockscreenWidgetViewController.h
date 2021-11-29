#import "WeatherPreferences.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WALockscreenWidgetViewController : UIViewController
@property (nonatomic, retain) WATodayModel *todayModel;
+ (WALockscreenWidgetViewController *)sharedInstanceIfExists;
- (void)_setupWeatherModel;
@end