#import <Foundation/Foundation.h>

@interface Schwarzwald : NSObject

+ (NSApplication *)createApplication;
+ (NSApplication *)createApplication:(Class)applicationClass;
+ (NSApplication *)createApplicationWithTestBundle:(NSString *)specBundleIdentifier mainPlist:(NSString *)appPlistFilename;

+ (void)advanceMinutes:(NSInteger)minutes;

@end
