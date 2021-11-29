#import "WeatherPreferences.h"

@interface WUIWeatherCondition : NSObject
@property (assign, nonatomic) long long condition;
@property (nonatomic, retain) NSString *loadedFileName;
@property (nonatomic) BOOL hidesConditionBackground;
@property (assign, nonatomic) long long forcesNight;
- (void)pause;
- (void)resume;
- (City *)city;
- (void)setPlaying:(BOOL)arg1;
- (BOOL)playing;
- (double)alpha;
- (void)setAlpha:(double)arg1;
- (void)setCondition:(long long)arg1;
@end
;

@interface WUIGradientLayer : CAGradientLayer
@property CGPoint position;
@end

@interface WUIDynamicWeatherBackground : UIView
- (void)setCity:(id)arg1;
- (void)setCondition:(long long)arg1;
- (WUIWeatherCondition *)condition;
@property (nonatomic) BOOL hidesBackground;
@property (nonatomic, retain) WUIGradientLayer *gradientLayer;
@end

@interface WUIWeatherConditionBackgroundView : UIView
@property (nonatomic) BOOL hidesConditions;
- (id)initWithFrame:(CGRect)arg1;
- (WUIDynamicWeatherBackground *)background;
- (void)prepareToSuspend;
- (void)prepareToResume;
@end
