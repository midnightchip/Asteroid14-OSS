#import "DeviceView.h"
@import Cephei;

@implementation DeviceView {
    WUIWeatherConditionBackgroundView *_weatherView;
    SBFLockScreenDateView *clockView;
    SBUICallToActionLabel *forecastLabel;
    UIImageView *wallPaper;
    City *city;
    City *cleanCity;
    HBPreferences *prefs;
    long cityIndex;
    long customCondition;
    BOOL enableAnimation;
    BOOL isNight;
    BOOL customConditionEnabled;
    BOOL customLocationIndexEnabled;
    BOOL enableBackground;
    BOOL enableLockscreenIcon;
    BOOL enableForecastText;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpWallpaper];
        [self configView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame enableHomeScreen:(BOOL)enableHome {
    self = [super initWithFrame:frame];
    if (self) {
        [self setHomeScreen:enableHome];
        [self configView];
    }
    return self;
}

- (void)configView {
    self.backgroundColor = [UIColor clearColor];

    prefs = [[HBPreferences alloc]
        initWithIdentifier:@"me.midnightchips.asteroidpreferences"];
    [prefs registerInteger:&cityIndex
                   default:0
                    forKey:self.homeScreen ? @"HomeScreenLocationIndex"
                                           : @"LockScreenLocationIndex"];
    [prefs registerInteger:&customCondition
                   default:0
                    forKey:self.homeScreen ? @"HomeScreenCustomConditionIndex"
                                           : @"LockScreenCustomConditionIndex"];
    [prefs registerBool:&enableAnimation
                default:false
                 forKey:self.homeScreen ? @"EnableHomeScreenAnimation"
                                        : @"EnableLockScreenAnimation"];
    [prefs registerBool:&isNight
                default:false
                 forKey:self.homeScreen ? @"HomeCustomLocationNight"
                                        : @"LockCustomLocationNight"];
    [prefs registerBool:&customConditionEnabled
                default:false
                 forKey:self.homeScreen ? @"EnableCustomHomeCondition"
                                        : @"EnableCustomLockScreenCondition"];
    [prefs registerBool:&customLocationIndexEnabled
                default:false
                 forKey:self.homeScreen ? @"EnableCustomLocationHome"
                                        : @"EnableCustomLocationLockScreen"];
    [prefs registerBool:&enableBackground
                default:false
                 forKey:self.homeScreen ? @"EnableAnimationBackgroundHome"
                                        : @"EnableAnimationBackgroundLockScreen"];

    [prefs registerBool:&enableLockscreenIcon
                default:false
                 forKey:@"EnableLockScreenIcon"];

    [prefs registerBool:&enableForecastText default:false forKey:@"EnableLockScreenText"];

    [prefs registerPreferenceChangeBlock:^{
        [self changeWeather];
    }];

    [self changeWeather];
}

- (void)changeWeather {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_weatherView) {
            [_weatherView removeFromSuperview];
            _weatherView = nil;
            city = nil;
        }
        if (!wallPaper) {
            [self setUpWallpaper];
        }

        [self configCity];
        if (!self.homeScreen) {
            [self setUpClockView];
            if (enableForecastText) {
                [self setupForecastLabel];
            } else if (forecastLabel) {
                [forecastLabel removeFromSuperview];
                forecastLabel = nil;
            }
        }

        if (!enableAnimation) {
            return;
        }

        _weatherView =
            [[WUIWeatherConditionBackgroundView alloc] initWithFrame:self.bounds];
        _weatherView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        [[_weatherView background] setCity:city];
        [[_weatherView background] gradientLayer].hidden = !enableBackground;
        [self addSubview:_weatherView];

        if (clockView) {
            [self bringSubviewToFront:clockView];
        }
    });
}

- (void)configCity {
    if (customLocationIndexEnabled) {
        cleanCity =
            [[WeatherPreferences sharedPreferences] loadSavedCities][cityIndex];
        city = cleanCity;
    } else if (customConditionEnabled) {
        cleanCity = [[WeatherPreferences sharedPreferences] loadSavedCities][0];
        city = [cleanCity cityCopy];
        city.conditionCode = customCondition;
        long timezoneOffset = [[city timeZone] secondsFromGMT];
        if (city.isDay && isNight) {
            long differential = city.sunsetTime - city.observationTime;
            if (differential > 0) {
                city.observationTime = city.sunsetTime + 30;
                city.timeZone = [NSTimeZone
                    timeZoneForSecondsFromGMT:timezoneOffset +
                    [self formatTime:differential]];
            }
        } else if (!city.isDay && !isNight) {
            long differential = city.sunriseTime + city.observationTime;
            if (differential >= city.sunsetTime) {
                [city setObservationTime:(city.sunriseTime + 30)];
                city.timeZone = [NSTimeZone
                    timeZoneForSecondsFromGMT:timezoneOffset +
                    [self formatTime:differential]];
            }
        }

    } else {
        cleanCity = [[WeatherPreferences sharedPreferences] loadSavedCities][0];
        city = cleanCity;
    }
}

- (void)setUpClockView {
    if (clockView) {
        [clockView removeFromSuperview];
        clockView = nil;
    }
    clockView = [[SBFLockScreenDateView alloc] initWithFrame:self.bounds];
    [clockView setDate:[NSDate new]];

    if (enableLockscreenIcon) {
        UIImageView *weatherImage = [[UIImageView alloc]
            initWithImage:[WeatherImageLoader
                              conditionImageWithConditionIndex:cleanCity
                                                                   .conditionCode]];
        [weatherImage sizeToFit];

        [weatherImage
            setCenter:CGPointMake(clockView.center.x,
                          clockView.center.y - clockView.center.y / 4)];

        [clockView addSubview:weatherImage];
    }

    [self addSubview:clockView];
    clockView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    clockView.translatesAutoresizingMaskIntoConstraints = false;

    [clockView.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
    [clockView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = true;
    [clockView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = true;
    [clockView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = true;
}

- (void)setupForecastLabel {
    if (forecastLabel) {
        [forecastLabel removeFromSuperview];
        forecastLabel = nil;
    }
    forecastLabel = [[SBUICallToActionLabel alloc] initWithFrame:CGRectZero];
    [forecastLabel setText:city.naturalLanguageDescription ? city.naturalLanguageDescription : @"Weather Unavailable"];

    [self addSubview:forecastLabel];
    forecastLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    forecastLabel.translatesAutoresizingMaskIntoConstraints = false;
    [forecastLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:self.bounds.size.height / 1.5].active = true;
    [forecastLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = true;
    [forecastLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = true;
    [forecastLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = true;
}

- (void)setUpWallpaper {
    if (wallPaper) {
        [wallPaper removeFromSuperview];
        wallPaper = nil;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSData *imageData = [NSData new];
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        if ([fileManager fileExistsAtPath:@"/var/mobile/Library/SpringBoard/"
                                          @"HomeBackgrounddark.cpbitmap"]
            && self.homeScreen) {
            imageData = [NSData
                dataWithContentsOfFile:
                    @"/var/mobile/Library/SpringBoard/HomeBackgrounddark.cpbitmap"];
        } else {
            imageData = [NSData
                dataWithContentsOfFile:
                    @"/var/mobile/Library/SpringBoard/LockBackgrounddark.cpbitmap"];
        }

    } else {
        if ([fileManager
                fileExistsAtPath:
                    @"/var/mobile/Library/SpringBoard/HomeBackground.cpbitmap"]
            && self.homeScreen) {
            imageData = [NSData
                dataWithContentsOfFile:
                    @"/var/mobile/Library/SpringBoard/HomeBackground.cpbitmap"];
        } else {
            imageData = [NSData
                dataWithContentsOfFile:
                    @"/var/mobile/Library/SpringBoard/LockBackground.cpbitmap"];
        }
    }

    CFDataRef imageDataRef = (__bridge CFDataRef)imageData;
    NSArray *imageArray = (__bridge NSArray *)CPBitmapCreateImagesFromData(
        imageDataRef, NULL, 1, NULL);
    wallPaper = [[UIImageView alloc]
        initWithImage:[UIImage imageWithCGImage:(CGImageRef)imageArray[0]]];
    [wallPaper setFrame:self.bounds];
    wallPaper.translatesAutoresizingMaskIntoConstraints = false;

    [wallPaper setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:wallPaper];

    [wallPaper.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
    [wallPaper.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = true;
    [wallPaper.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = true;
    [wallPaper.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = true;
}
// #cursed
- (long)formatTime:(long)offset {
    if (offset < 0) {
        return 0;
    }
    NSString *digits = [NSString stringWithFormat:@"%ld", offset];
    if (digits.length <= 2) {
        return 3600; // 1 Hour
    } else if (digits.length == 3) {
        NSString *firstDigit = [digits substringToIndex:1];
        NSString *restOfDigits = [digits substringFromIndex:1];
        if ([firstDigit intValue] < 1) {
            return 3600 + [restOfDigits intValue] * 60;
        } else {
            return [firstDigit intValue] * 3600 + [restOfDigits intValue] * 60;
        }
    } else {
        NSString *first2Digits = [digits substringToIndex:2];
        NSString *restOfDigits = [digits substringFromIndex:2];
        if ([first2Digits intValue] < 1) {
            return 3600 + [restOfDigits intValue] * 60;
        } else {
            return [first2Digits intValue] * 3600 + [restOfDigits intValue] * 60;
        }
    }
}

@end
