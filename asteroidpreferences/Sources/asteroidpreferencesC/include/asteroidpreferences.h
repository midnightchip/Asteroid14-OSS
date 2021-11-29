
#import "../UIImage+UIKitImage.h"
#import "LockScreenPreview.h"
#import "WallPaper.h"
#import "WeatherViews.h"
#import <AltList/ATLApplicationListSubcontrollerController.h>
#import <Cephei/Cephei.h>
#import <Preferences/Preferences.h>
#import <MobileGestalt/MobileGestalt.h>

static inline NSString *shellEscape(NSArray<NSString *> *input) {
    NSMutableArray<NSString *> *result = [NSMutableArray array];
    for (NSString *string in input) {
        [result addObject:[NSString stringWithFormat:@"'%@'",
                                    [string stringByReplacingOccurrencesOfString:@"'"
                                                                      withString:@"\\'"
                                                                         options:NSRegularExpressionSearch
                                                                           range:NSMakeRange(0, string.length)]]];
    }
    return [result componentsJoinedByString:@" "];
}

static inline NSDictionary<NSString *, NSString *> *getFieldsForPackage(NSString *package, NSArray<NSString *> *fields) {
    NSMutableArray *escapedFields = [NSMutableArray array];
    for (NSString *field in fields) {
        [escapedFields addObject:[NSString stringWithFormat:@"${%@}", field]];
    }
    NSString *format = [escapedFields componentsJoinedByString:@"\n"];
    int status;
    NSString *output = HBOutputForShellCommandWithReturnCode(shellEscape(@[ @"/usr/bin/dpkg-query", @"-Wf", format, package ]), &status);
    if (status == 0) {
        NSArray<NSString *> *lines = [output componentsSeparatedByString:@"\n"];
        if (lines.count == fields.count) {
            NSMutableDictionary *result = [NSMutableDictionary dictionary];
            for (NSUInteger i = 0; i < lines.count; i++) {
                if (![lines[i] isEqualToString:@""]) {
                    result[fields[i]] = lines[i];
                }
            }
            return result;
        }
    }
    return nil;
}

static inline NSString *getFieldForPackage(NSString *package, NSString *field) {
    NSDictionary<NSString *, NSString *> *result = getFieldsForPackage(package, @[ field ]);
    return result[field];
}

CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void *, int,
    void *);

@interface UIImage (Internal)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleID
                                               format:(int)format
                                                scale:(CGFloat)scale;
@end

@interface PSListController (Private)
- (BOOL)containsSpecifier:(PSSpecifier *)arg1;
- (id)readPreferenceValue:(PSSpecifier *)arg1;
@end

@interface DeviceView : UIView
@property BOOL homeScreen;
- (void)changeWeather;
- (instancetype)initWithFrame:(CGRect)frame enableHomeScreen:(BOOL)enableHome;
@end
