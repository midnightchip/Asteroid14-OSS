#import "WeatherPreferences.h"

@interface WUIWeatherCondition : NSObject
@property (assign, nonatomic) long long condition;
@property (nonatomic, retain) NSString *loadedFileName;
@property (nonatomic) BOOL hidesConditionBackground;
@property (assign, nonatomic) long long forcesNight;
@property (assign, nonatomic) BOOL forcesCondition;
@property (assign,nonatomic) double timeOffset; 
- (void)pause;
- (void)resume;
- (City *)city;
- (void)setPlaying:(BOOL)arg1;
- (BOOL)playing;
- (double)alpha;
- (void)setAlpha:(double)arg1;
-(City *)city;
-(id)init;
-(void)setTimeOffset:(double)arg1 ;
-(void)setCAMLLayerStateForInterfaceOrientation:(long long)arg1 animated:(BOOL)arg2 ;
-(double)speed;
-(void)setTime:(float)arg1 ;
-(void)setCorrectStateForCurrentOrientationAndMode;
-(void)setForcesCondition:(BOOL)arg1 ;
-(NSMutableArray *)gyroLayers;
-(void)setCondition:(long long)arg1 ;
-(id)actionForLayer:(id)arg1 forKey:(id)arg2 ;
-(void)setSpeed:(double)arg1 ;
-(void)setCity:(City *)arg1 ;
-(double)timeOffset;
-(void)layoutSublayersOfLayer:(id)arg1 ;
-(long long)condition;
-(void)setCity:(id)arg1 animationDuration:(double)arg2 ;
-(BOOL)shouldRasterize;
-(void)setLoadedFileName:(NSString *)arg1 ;
-(CALayer *)layer;
-(unsigned long long)CAMLState;
-(BOOL)_interfaceConsideredPortraitForCAMLLayerWithSize:(CGSize)arg1 ;
-(BOOL)multiCityMode;
-(void)transitionToSize:(CGSize)arg1 animated:(BOOL)arg2 ;
-(void)setForcesNight:(long long)arg1 ;
-(void)setShouldRasterize:(BOOL)arg1 ;
-(void)setHidden:(BOOL)arg1 ;
-(void)setMultiCityMode:(BOOL)arg1 ;
-(void)setCondition:(long long)arg1 animationDuration:(double)arg2 ;
-(void)setIsRotating:(BOOL)arg1 ;
-(void)setGyroLayers:(NSMutableArray *)arg1 ;
-(NSString *)loadedFileName;
-(void)dealloc;
-(BOOL)hidden;
-(long long)forcesNight;
-(void)setCAMLState:(unsigned long long)arg1 ;
-(BOOL)_interfaceConsideredPortraitForCAMLLayer;
-(void)setAlpha:(double)arg1 animationDuration:(double)arg2 ;
-(BOOL)forcesCondition;
-(BOOL)isRotating;
@end

@interface WUIGradientLayer : CAGradientLayer
@property CGPoint position;
@end

@interface WUIDynamicWeatherBackground : UIView
- (void)setCity:(id)arg1;
- (void)setCondition:(WUIWeatherCondition *)condition;
- (WUIWeatherCondition *)condition;
- (void)setCity:(City *)city animate:(BOOL)animated;
- (id)updateFromCity:(City *)origCity toCity:(City *)newCity;
+ (void)handleMemoryWarning;
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


@class WATodayAutoupdatingLocationModel, UILabel, UIImageView, NSMutableArray, UIColor, NSString;

@interface WAGreetingView : UIView
@property (nonatomic,retain) WATodayAutoupdatingLocationModel * todayModel;              //@synthesize todayModel=_todayModel - In the implementation block
@property (nonatomic,retain) UILabel * natualLanguageDescriptionLabel;                   //@synthesize natualLanguageDescriptionLabel=_natualLanguageDescriptionLabel - In the implementation block
@property (nonatomic,retain) UIImageView * conditionImageView;                           //@synthesize conditionImageView=_conditionImageView - In the implementation block
@property (nonatomic,retain) UILabel * temperatureLabel;                                 //@synthesize temperatureLabel=_temperatureLabel - In the implementation block
@property (nonatomic,retain) NSMutableArray * constraints;                               //@synthesize constraints=_constraints - In the implementation block
@property (assign,nonatomic) BOOL isViewCreated;                                         //@synthesize isViewCreated=_isViewCreated - In the implementation block
@property (nonatomic,retain) UIColor * labelColor;                                       //@synthesize labelColor=_labelColor - In the implementation block
@property (readonly) unsigned long long hash; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
-(NSMutableArray *)constraints;
-(void)updateView;
-(void)setConstraints:(NSMutableArray *)arg1 ;
-(id)init;
-(void)updateConstraints;
-(void)setLabelColor:(UIColor *)arg1 ;
-(void)setTemperatureLabel:(UILabel *)arg1 ;
-(UIColor *)labelColor;
-(void)createViews;
-(UILabel *)temperatureLabel;
-(void)dealloc;
-(void)startService;
-(id)_temperature;
-(id)initWithFrame:(CGRect)arg1 ;
-(void)setupConstraints;
-(id)initWithColor:(id)arg1 ;
-(void)todayModelWantsUpdate:(id)arg1 ;
-(void)todayModel:(id)arg1 forecastWasUpdated:(id)arg2 ;
-(void)_teardownWeatherModel;
-(WATodayAutoupdatingLocationModel *)todayModel;
-(void)_setupWeatherModel;
-(id)_conditionsImage;
-(void)setTodayModel:(WATodayAutoupdatingLocationModel *)arg1 ;
-(void)setIsViewCreated:(BOOL)arg1 ;
-(void)updateLabelColors;
-(UILabel *)natualLanguageDescriptionLabel;
-(UIImageView *)conditionImageView;
-(void)setNatualLanguageDescriptionLabel:(UILabel *)arg1 ;
-(void)setConditionImageView:(UIImageView *)arg1 ;
-(BOOL)isViewCreated;
@end