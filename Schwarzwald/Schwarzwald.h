#import <Foundation/Foundation.h>

@interface Schwarzwald : NSObject

+ (NSApplication *)createApplication;
+ (NSApplication *)createApplication:(Class)applicationClass;
+ (NSApplication *)createApplicationWithMainPlist:(NSString *)appPlistFilename;

+ (void)advanceTimeByMinutes:(NSInteger)minutes;

@end
