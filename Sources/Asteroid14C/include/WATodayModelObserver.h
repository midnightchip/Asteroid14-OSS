#import "WeatherPreferences.h"
#import <Foundation/Foundation.h>

@protocol WATodayModelObserver <NSObject>

@required
- (void)todayModelWantsUpdate:(WATodayModel *)model;
- (void)todayModel:(WATodayModel *)model forecastWasUpdated:(WAForecastModel *)forecast;
@end