#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WFLocation
@end

@interface WFTemperature : NSObject
@property (nonatomic) double celsius;
@property (nonatomic) double fahrenheit;
- (CGFloat)temperatureForUnit:(int)arg1;
@end

@interface City : NSObject
@property (nonatomic, copy) NSString *name;
@property (assign, nonatomic) BOOL isLocalWeatherCity;
@property (nonatomic, retain) NSTimeZone *timeZone;
@property (assign, nonatomic) unsigned long long observationTime;
@property (assign, nonatomic) unsigned long long sunsetTime;
@property (assign, nonatomic) unsigned long long sunriseTime;
@property (nonatomic, retain) WFLocation *wfLocation;
@property (assign, nonatomic) BOOL isDay;
@property (assign, nonatomic) long long conditionCode;
@property (assign, nonatomic) long long updateInterval;
@property (nonatomic, retain) NSHashTable *cityUpdateObservers;
@property (nonatomic, retain) NSTimer *autoUpdateTimer;
- (NSMutableArray *)hourlyForecasts;
- (NSMutableArray *)dayForecasts;
- (long long)conditionCode;
- (WFTemperature *)temperature;
- (unsigned long long)sunriseTime;
- (unsigned long long)sunsetTime;
- (NSString *)naturalLanguageDescription;
- (void)update;
- (NSDate *)updateTime;
- (void)setAutoUpdate:(BOOL)arg1;
- (void)setAutoUpdateTimer:(NSTimer *)arg1;
- (void)addUpdateObserver:(id)arg1;
- (City *)cityCopy;
@end

@interface WeatherLocationManager : NSObject
+ (id)sharedWeatherLocationManager;
- (BOOL)locationTrackingIsReady;
- (void)setLocationTrackingReady:(BOOL)arg1
                activelyTracking:(BOOL)arg2
               watchKitExtension:(id)arg3;
- (void)setLocationTrackingActive:(BOOL)arg1;
- (CLLocation *)location;
- (void)setDelegate:(id)arg1;
- (void)forceLocationUpdate;
@end

@interface WeatherUserDefaults : NSObject
@property (retain)
    NSUserDefaults *userDefaults; //@synthesize userDefaults=_userDefaults - In
                                  // the implementation block
@property (readonly) unsigned long long hash;
@property (readonly) Class superclass;
@property (copy, readonly) NSString *description;
@property (copy, readonly) NSString *debugDescription;
- (void)setUserDefaults:(NSUserDefaults *)arg1;
- (id)objectForKey:(id)arg1;
- (void)removeObjectForKey:(id)arg1;
- (id)arrayForKey:(id)arg1;
- (id)stringForKey:(id)arg1;
- (BOOL)synchronize;
- (id)initWithUserDefaults:(id)arg1;
- (void)setBool:(BOOL)arg1 forKey:(id)arg2;
- (void)synchronizeWithCompletionHandler:(/*^block*/ id)arg1;
- (BOOL)boolForKey:(id)arg1;
- (id)dictionaryForKey:(id)arg1;
- (NSUserDefaults *)userDefaults;
- (void)setObject:(id)arg1 forKey:(id)arg2;
@end

@interface WeatherPreferences
@property (nonatomic, readonly) City *localWeatherCity;
@property (assign, setter=setLocalWeatherEnabled:, getter=isLocalWeatherEnabled,
    nonatomic) BOOL isLocalWeatherEnabled;
+ (instancetype)sharedPreferences;
- (id)init;
- (id)localWeatherCity;
- (int)loadActiveCity;
- (NSArray<City *> *)loadSavedCities;
+ (WeatherUserDefaults *)userDefaultsPersistence;
- (NSDictionary *)userDefaults;
- (void)setLocalWeatherEnabled:(BOOL)arg1;
- (City *)cityFromPreferencesDictionary:(id)arg1;
- (BOOL)isCelsius;
- (BOOL)isLocalWeatherEnabled;
- (void)saveToDiskWithLocalWeatherCity:(City *)city;
@end

@interface WAForecastModel : NSObject
@property (nonatomic, retain) City *city;
- (BOOL)isPopulated;

@end

@interface WATodayModel : NSObject
// Returns WATodayAutoupdatingLocationModel
+ (id)autoupdatingLocationModelWithPreferences:(id)arg1
                     effectiveBundleIdentifier:(id)arg2;
- (void)_fireTodayModelWantsUpdate;
- (BOOL)executeModelUpdateWithCompletion:(/*^block*/ id)arg1;
@property (nonatomic, retain) NSDate *lastUpdateDate;
+ (id)modelWithLocation:(id)arg1;
@property (nonatomic, retain) WAForecastModel *forecastModel;
- (id)location;
- (void)addObserver:(id)arg1;
- (void)_executeForecastRetrievalForLocation:(id)arg1
                                  completion:(/*^block*/ id)arg2;

@end

@interface WFGeocodeRequest
@property (retain) WFLocation *geocodedResult;
@end

@interface WATodayAutoupdatingLocationModel : WATodayModel
- (BOOL)_reloadForecastData:(BOOL)arg1;
- (void)setPreferences:(WeatherPreferences *)arg1;
- (void)_kickstartLocationManager;
- (WAForecastModel *)forecastModel;
- (void)setIsLocationTrackingEnabled:(BOOL)arg1;
- (void)setLocationServicesActive:(BOOL)arg1;
@property (assign, nonatomic) unsigned long long citySource;
@property (nonatomic, retain) WeatherLocationManager *locationManager;
@property (assign, nonatomic) BOOL isLocationTrackingEnabled;
- (void)_executeLocationUpdateForLocalWeatherCityWithCompletion:
    (/*^block*/ id)arg1;
- (void)_executeLocationUpdateWithCompletion:(/*^block*/ id)arg1;
@property (nonatomic, retain) WFGeocodeRequest *geocodeRequest;
- (void)_willDeliverForecastModel:(id)arg1;
- (BOOL)isLocationTrackingEnabled;
@end

@interface WeatherImageLoader : NSObject
+ (instancetype)sharedImageLoader;
+ (NSBundle *)conditionImageBundle;
+ (UIImage *)conditionImageNamed:(NSString *)name;
+ (UIImage *)conditionImageWithConditionIndex:(NSInteger)conditionCode;
+ (NSString *)conditionImageNameWithConditionIndex:(NSInteger)conditionCode;
@end
