#import "../Sources/Asteroid14C/include/WeatherPreferences.h"

@interface NSObject (asteroid)
- (BOOL)isKindOfClass:(Class)aClass;
+ (id)cplAllPropertyNames;
@end

%hook City 
%new 
- (City *)cityCopy {
  City *city = [[City alloc] init];
  NSArray *prpArray = [[City cplAllPropertyNames] allObjects];
  for (NSString *prpString in prpArray) {
    objc_property_t property =
        class_getProperty([City class], [prpString UTF8String]);
    if (property) {
      const char *propertyAttributes = property_getAttributes(property);
      NSArray *attributes = [[NSString stringWithUTF8String:propertyAttributes]
          componentsSeparatedByString:@","];
      if (![attributes containsObject:@"R"]) { // Not readonly
        [city setValue:[self valueForKey:prpString] forKey:prpString];
      }
    }
  }
  return city;
}

%new
- (City *)fastCopy {
    return [self copy];
}
%end