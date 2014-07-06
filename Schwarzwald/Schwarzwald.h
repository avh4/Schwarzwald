#import <Foundation/Foundation.h>

@interface Schwarzwald : NSObject

+ (NSApplication *)initWithTestBundle:(NSString *)specBundleIdentifier mainPlist:(NSString *)appPlistFilename;

+ (NSArray *)visibleWindows;
+ (NSWindow *)visibleWindow;

+ (void)advanceMinutes:(NSInteger)minutes;

@end
