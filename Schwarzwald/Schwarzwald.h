#import <Foundation/Foundation.h>

@interface Schwarzwald : NSObject

+ (NSApplication *)createApplication;
+ (NSApplication *)createApplication:(Class)applicationClass;
+ (NSApplication *)createApplicationWithMainPlist:(NSString *)appPlistFilename;

+ (void)advanceMinutes:(NSInteger)minutes;

@end
