#import <Foundation/Foundation.h>

@interface Schwarzwald : NSObject

+ (NSApplication *)initWithTestBundle:(NSString *)specBundleIdentifier mainPlist:(NSString *)appPlistFilename;

+ (NSArray *)visibleWindows;

@end
