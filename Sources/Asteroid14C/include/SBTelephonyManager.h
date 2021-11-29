#import <Foundation/Foundation.h>


@interface STTelephonySubscriptionContext : NSObject
@end

@interface STTelephonyStateProvider : NSObject
- (void)operatorNameChanged:(STTelephonySubscriptionContext *)context name:(id)carrier;
@end

@interface SBTelephonyManager : NSObject
+ (instancetype)sharedTelephonyManager;
@property (nonatomic, readonly) STTelephonyStateProvider *telephonyStateProvider;
@end