#import <Foundation/Foundation.h>

@interface Schwarzwald : NSObject

+ (NSApplication *)createApplication;
+ (NSApplication *)createApplication:(Class)applicationClass;
+ (NSApplication *)createApplicationWithTestBundle:(NSString *)specBundleIdentifier mainPlist:(NSString *)appPlistFilename;

+ (NSArray *)visibleWindows;
+ (NSWindow *)visibleWindow;

+ (void)advanceMinutes:(NSInteger)minutes;

@end
