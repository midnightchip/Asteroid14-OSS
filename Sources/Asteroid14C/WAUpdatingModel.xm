#import "./include/Tweak.h"

@interface ObjcWeatherModel : NSObject
@property WATodayAutoupdatingLocationModel *todayModel;
@property WALockscreenWidgetViewController *widgetVC;
@end 

@implementation ObjcWeatherModel

+(instancetype)sharedInstance {
	static ObjcWeatherModel *_model = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_model = [[self alloc] init];
	});
	return _model;
}

-(instancetype)init {
    self = [super init];
    if (self != nil) {
        self.todayModel = nil;
        [self _setupWeatherModel];
    }
    return self;
}

-(void)_setupWeatherModel {
    self.widgetVC = [[%c(WALockscreenWidgetViewController) alloc] init];
    [self.widgetVC _setupWeatherModel];
    self.todayModel = (WATodayAutoupdatingLocationModel *)self.widgetVC.todayModel;
    [self requestModelUpdate];
}

-(void)requestModelUpdate {
    
    [self _updateLocationTracking];
    //[self.todayModel executeModelUpdateWithCompletion:^{}];
    [self.todayModel executeModelUpdateWithCompletion:^(BOOL arg1, NSError *error) {
        NSLog(@"Executing Updating! Response: %d, Error: %@ - %@ - %@", arg1, error.localizedDescription, error.localizedFailureReason, error.localizedRecoverySuggestion);
    }];
}


-(void)_updateLocationTracking {
    if ([self.todayModel isKindOfClass:[WATodayAutoupdatingLocationModel class]]) {
        WATodayAutoupdatingLocationModel *autoUpdatingTodayModel = (WATodayAutoupdatingLocationModel *)self.todayModel;
        if ([autoUpdatingTodayModel respondsToSelector:@selector(updateLocationTrackingStatus)]) {
            [autoUpdatingTodayModel updateLocationTrackingStatus];
        } else {
            autoUpdatingTodayModel.isLocationTrackingEnabled = [CLLocationManager locationServicesEnabled];
        }
    }
}

@end 
