#import "include/asteroidpreferences.h"
#import <Cephei/Cephei.h>
#import <Preferences/PSHeaderFooterView.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
@interface ASTBanner : PSTableCell <PSHeaderFooterView>
@end

@implementation ASTBanner {
    WUIWeatherConditionBackgroundView *_weatherView;
    UILabel *titleView;
    UILabel *subTitle;
    City *city;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                    specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier
                      specifier:specifier];

    if (self) {
        NSDictionary<NSString *, NSString *> *fields = getFieldsForPackage(@"me.midnightchips.asteroid14", @[ @"Name", @"Author", @"Maintainer", @"Version" ]);
        self.backgroundColor = [UIColor clearColor];

        _weatherView = [[WUIWeatherConditionBackgroundView alloc]
            initWithFrame:self.contentView.bounds];
        _weatherView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        [self changeWeather:nil];

        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(changeWeather:)];
        [_weatherView addGestureRecognizer:recognizer];
        recognizer.delegate = self;

        [self.contentView addSubview:_weatherView];

        titleView = [[UILabel alloc]
            initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 0)];
        [titleView setText:@"Asteroid"];
        //[titleView setShadowColor:[UIColor blackColor]];
        [titleView setFont:[UIFont systemFontOfSize:40 weight:UIFontWeightBold]];
        [titleView setNumberOfLines:0];
        [titleView setTextAlignment:NSTextAlignmentCenter];
        [titleView sizeToFit];
        [_weatherView addSubview:titleView];

        subTitle = [[UILabel alloc] initWithFrame:titleView.frame];

        
        [subTitle setText:[NSString stringWithFormat:@"Version %@", fields[@"Version"] ?: @"Pirated"]];
        [subTitle setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
        [subTitle setTextAlignment:NSTextAlignmentRight];
        [subTitle sizeToFit];
        [_weatherView addSubview:subTitle];

        self.imageView.hidden = YES;
        self.textLabel.hidden = YES;
        self.detailTextLabel.hidden = YES;
    }
    return self;
}

- (void)changeWeather:(UITapGestureRecognizer *)rec {
    city = [[WeatherPreferences sharedPreferences] loadSavedCities][0];
    city.conditionCode = 0 + arc4random_uniform((uint32_t)(47 - 1));
    [[_weatherView background] setCity:city];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [titleView setCenter:_weatherView.center];
    [subTitle setCenter:CGPointMake(titleView.center.x,
                            titleView.center.y + titleView.frame.size.height / 2)];
}

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
    self = [self initWithStyle:UITableViewCellStyleDefault
               reuseIdentifier:nil
                     specifier:specifier];
    return self;
}

#pragma mark - PSHeaderFooterView

- (CGFloat)preferredHeightForWidth:(CGFloat)width {
    return 250;
}

@end
