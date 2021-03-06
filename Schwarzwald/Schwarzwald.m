#import "Schwarzwald.h"
#import "WeakReference.h"
#import "NSTimer+Schwarzwald.h"
#import "SWAssert.h"

#define ARCRetain(...) { void *retainedThing = (__bridge_retained void *)__VA_ARGS__; retainedThing = retainedThing; }
#define ARCRelease(...) { void *retainedThing = (__bridge void *) __VA_ARGS__; id unretainedThing = (__bridge_transfer id)retainedThing; unretainedThing = nil; }
#define ARCRetainCount(obj) CFGetRetainCount((__bridge CFTypeRef)NSApp)

@implementation Schwarzwald

+ (NSApplication *)createApplication {
  return [self createApplication:[NSApplication class]];
}

+ (NSApplication *)createApplication:(Class)principalClass {
  NSAssert([principalClass respondsToSelector:@selector(sharedApplication)], @"Principal class must implement sharedApplication.");

  NSApplication *application;

  // NSApp needs to be cleared because NSApplication has an internal check causing its init to throw if another NSApplication has previously been created (which it apparentlys checks by looking at NSApp.  However, there are memory-management problems (see below).
  NSApp = nil;

  application = [[principalClass alloc] init];

  // When we get to the point, there are two strong references to the application: local application, and global NSApp.  But somehow, the object's retain count is only 1.  The local reference is returned and used by the test and is generally disposed of first, meaning that the `NSApp = nil` line above will over-release the object.  We retain it an extra time to allow this to work.
  ARCRetain(NSApp);
  ARCRetain(NSApp);  // TODO: this is incorrect and causes a memory leak, but without it there is race condition that causes the autorelease drain in Cedar to get a BAD_ACCESS sometimes

  SWAssert(application, @"[[%@ alloc] init] returned nil", NSStringFromClass(principalClass));
  SWAssert(application == NSApp, @"Internal error: [[%@ alloc] init] did not set NSApp", NSStringFromClass(principalClass));
  // TODO: probably should also validate that [applicationClass sharedApplication] == [NSApplication sharedApplication] == NSApp
  return application;
}

+ (NSBundle *)findTestBundle {
  if ([NSBundle allBundles].count > 2) {
    NSLog(@"WARNING: Schwarzwald: More than two bundles were found at runtime.  [Schwarzwald findTestBundle] may not work correctly.  Please file an issue at https://github.com/avh4/Schwarzwald/issues/new with the following details and whether or not it seems to be working:");
    for (NSBundle *bundle in [NSBundle allBundles]) {
      NSLog(@"WARNING: Schwarzwald: %@ bundleIdentifier=%@", bundle, [bundle bundleIdentifier]);
    }
    NSLog(@"WARNING: Schwarzwald: END OF DETAILS");
  }
  for (NSBundle *bundle in [NSBundle allBundles]) {
    if ([bundle bundleIdentifier] == nil) continue;
    if ([[bundle bundlePath] isEqualToString:@"/Applications/Xcode.app/Contents/Developer/Tools"]) continue;
    return bundle;
  }
  @throw [NSException exceptionWithName:@"SchwarzwaldInitializationException" reason:[NSString stringWithFormat:@"No appropriate test bundle found.  [Schwarzwald findTestBundle] may need to be updated."] userInfo:nil];
}

+ (NSApplication *)createApplication:(Class)principalClass mainNibName:(NSString *)mainNibName {
  NSApplication *application = [self createApplication:principalClass];
  [self loadMainNib:mainNibName application:application];

  // Set the key window
  // TODO: there's probably more logic to simulate
  [application.windows[0] makeKeyWindow];

  return application;
}

+ (NSApplication *)createApplicationWithMainPlist:(NSString *)appPlistFilename {
  NSBundle *specBundle = [self findTestBundle];
  NSString *plistPath = [specBundle pathForResource:appPlistFilename ofType:@"plist"];
  SWAssert(plistPath, @"%@.plist was not found in the test bundle.  Find your Info.plist file (typically MyApp/Supporting Files/MyApp-Info.plist), and make sure it is a member of your Tests/Specs target (check the box under 'Target Membership' in the Utilities (right) sidebar", appPlistFilename);
  NSDictionary *infoDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
  Class principalClass = NSClassFromString([infoDictionary objectForKey:@"NSPrincipalClass"]);
  NSString *mainNibName = [infoDictionary objectForKey:@"NSMainNibFile"];

  return [self createApplication:principalClass mainNibName:mainNibName];
}

+ (void)loadMainNib:(NSString *)mainNibName application:(NSApplication *)application {
  NSBundle *specBundle = [self findTestBundle];
  NSNib *mainNib = [[NSNib alloc] initWithNibNamed:mainNibName bundle:specBundle];
  [mainNib instantiateWithOwner:application topLevelObjects:nil];
}

+ (void)advanceTimeByMinutes:(NSInteger)minutes {
  [NSTimer fireTimers];
}

@end
