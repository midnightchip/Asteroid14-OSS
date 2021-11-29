#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WFLocation
@end

@interface WFGeocodeRequest
@property (retain) WFLocation *geocodedResult;
@end

@interface WFTemperature : NSObject
@property (nonatomic) double celsius;
@property (nonatomic) double fahrenheit;
- (CGFloat)temperatureForUnit:(int)arg1;
@end

@interface WAHourlyForecast : NSObject <NSCopying> {

    unsigned long long _eventType;
    NSString *_time;
    long long _hourIndex;
    WFTemperature *_temperature;
    NSString *_forecastDetail;
    long long _conditionCode;
    double _percentPrecipitation;
}
@property (assign, nonatomic) unsigned long long eventType; //@synthesize eventType=_eventType - In the implementation block
@property (nonatomic, copy) NSString *time; //@synthesize time=_time - In the implementation block
@property (assign, nonatomic) long long hourIndex; //@synthesize hourIndex=_hourIndex - In the implementation block
@property (nonatomic, retain) WFTemperature *temperature; //@synthesize temperature=_temperature - In the implementation block
@property (nonatomic, copy) NSString *forecastDetail; //@synthesize forecastDetail=_forecastDetail - In the implementation block
@property (assign, nonatomic) long long conditionCode; //@synthesize conditionCode=_conditionCode - In the implementation block
@property (assign, nonatomic) double percentPrecipitation; //@synthesize percentPrecipitation=_percentPrecipitation - In the implementation block
+ (id)hourlyForecastForLocation:(id)arg1 conditions:(id)arg2 sunriseDateComponents:(id)arg3 sunsetDateComponents:(id)arg4;
+ (long long)TimeValueFromString:(id)arg1;
- (void)setEventType:(unsigned long long)arg1;
- (void)setPercentPrecipitation:(double)arg1;
- (NSString *)time;
- (unsigned long long)eventType;
- (void)setTime:(NSString *)arg1;
- (unsigned long long)hash;
- (long long)conditionCode;
- (double)percentPrecipitation;
- (WFTemperature *)temperature;
- (void)setConditionCode:(long long)arg1;
- (void)setTemperature:(WFTemperature *)arg1;
- (long long)hourIndex;
- (void)setForecastDetail:(NSString *)arg1;
- (BOOL)isEqual:(id)arg1;
- (id)description;
- (void)setHourIndex:(long long)arg1;
- (NSString *)forecastDetail;
- (id)copyWithZone:(NSZone *)arg1;
@end

@interface City : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSTimeZone *timeZone;
@property (assign, nonatomic) unsigned long long observationTime; //@synthesize observationTime=_observationTime - In the implementation block
@property (assign, nonatomic) unsigned long long sunsetTime; //@synthesize sunsetTime=_sunsetTime - In the implementation block
@property (assign, nonatomic) unsigned long long sunriseTime;
@property (assign, nonatomic) BOOL isLocalWeatherCity;
@property (nonatomic, retain) WFLocation *wfLocation;
@property (assign, nonatomic) BOOL isDay;
@property (assign, nonatomic) long long conditionCode;
@property (assign, nonatomic) long long updateInterval;
@property (nonatomic, retain) NSHashTable *cityUpdateObservers;
@property (nonatomic, retain) NSTimer *autoUpdateTimer;
- (NSMutableArray<WAHourlyForecast *> *)hourlyForecasts;
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
- (City *)fastCopy;
@end

@interface WeatherLocationManager : NSObject
@property CLLocationManager *locationManager;
+ (instancetype)sharedWeatherLocationManager;
- (BOOL)isLocalStaleOrOutOfDate;
- (BOOL)localWeatherAuthorized;
- (BOOL)locationTrackingIsReady;
- (void)setLocationTrackingReady:(BOOL)arg1 activelyTracking:(BOOL)arg2 watchKitExtension:(id)arg3;
- (void)setLocationTrackingActive:(BOOL)arg1;
- (CLLocation *)location;
- (void)setDelegate:(id)arg1;
- (void)forceLocationUpdate;
@end

@interface WeatherUserDefaults : NSObject
@property (retain) NSUserDefaults *userDefaults; //@synthesize userDefaults=_userDefaults - In the implementation block
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

@interface WeatherPreferences : NSObject
@property (nonatomic, readonly) City *localWeatherCity;
@property (assign, setter=setLocalWeatherEnabled:, getter=isLocalWeatherEnabled, nonatomic) BOOL isLocalWeatherEnabled;
+ (instancetype)sharedPreferences;
- (id)localWeatherCity;
- (NSArray<City *> *)_defaultCities;
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

typedef void (^WeatherCompletion)(BOOL arg1, NSError *error);
@interface WATodayModel : NSObject
// Returns WATodayAutoupdatingLocationModel
+ (id)autoupdatingLocationModelWithPreferences:(id)arg1 effectiveBundleIdentifier:(id)arg2;
- (void)_fireTodayModelWantsUpdate;
@property (nonatomic, retain) NSDate *lastUpdateDate;
+ (id)modelWithLocation:(id)arg1;
@property (nonatomic, retain) WAForecastModel *forecastModel;
- (id)location;
- (void)addObserver:(id)arg1;
- (void)_executeForecastRetrievalForLocation:(id)arg1 completion:(/*^block*/ id)arg2;
- (BOOL)executeModelUpdateWithCompletion:(WeatherCompletion)arg1;

@end

@interface WATodayAutoupdatingLocationModel : WATodayModel <CLLocationManagerDelegate>
- (BOOL)_reloadForecastData:(BOOL)arg1;
- (void)setPreferences:(WeatherPreferences *)arg1;
- (BOOL)updateLocationTrackingStatus;
- (void)_kickstartLocationManager;
- (WAForecastModel *)forecastModel;
- (void)setIsLocationTrackingEnabled:(BOOL)arg1;
- (void)setLocationServicesActive:(BOOL)arg1;
@property (assign, nonatomic) unsigned long long citySource;
@property (nonatomic, retain) WeatherLocationManager *locationManager;
@property (assign, nonatomic) BOOL isLocationTrackingEnabled;
- (void)_executeLocationUpdateForLocalWeatherCityWithCompletion:(WeatherCompletion)arg1;
- (void)_executeLocationUpdateWithCompletion:(WeatherCompletion)arg1;
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
+ (UIImage *)conditionImageNamed:(NSString *)arg1 size:(CGSize)arg2 cloudAligned:(BOOL)arg3 stroke:(BOOL)arg4 strokeAlpha:(double)arg5 lighterColors:(BOOL)arg6;
+ (UIImage *)conditionImageNamed:(NSString *)arg1 style:(long long)arg2;
+ (UIImage *)conditionImageWithConditionIndex:(long long)arg1 style:(long long)arg2;
@end
