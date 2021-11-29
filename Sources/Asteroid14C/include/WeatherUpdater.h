
#import "WeatherPreferences.h"
#import <Foundation/Foundation.h>

typedef void (^Completion)(NSArray<City *> *obj1, NSError *obj2);
@interface TWCLocationUpdater : NSObject
+ (instancetype)sharedLocationUpdater;
- (void)updateWeatherForCities:(NSArray<City *> *)arg1 withCompletionHandler:(Completion)arg2;
- (void)updateWeatherForLocation:(id)arg1 city:(City *)arg2 isFromFrameworkClient:(BOOL)arg3 withCompletionHandler:(Completion)arg4;
- (void)updateWeatherForCity:(City *)arg1;
- (void)setCurrentCity:(City *)arg1;
@end

@protocol CityUpdateObserver <NSObject>
@optional
- (void)cityDidFinishWeatherUpdate:(City *)arg1;
- (void)cityDidStartWeatherUpdate:(City *)arg1;
@end
