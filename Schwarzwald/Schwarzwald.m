#import "Schwarzwald.h"
#import "WeakReference.h"
#import "NSTimer+Schwarzwald.h"

NSMutableArray *activeWindows;

#define AntiARCRetain(...) void *retainedThing = (__bridge_retained void *)__VA_ARGS__; retainedThing = retainedThing
#define AntiARCRelease(...) void *retainedThing = (__bridge void *) __VA_ARGS__; id unretainedThing = (__bridge_transfer id)retainedThing; unretainedThing = nil
#define AntiARCRetainCount(obj) CFGetRetainCount((__bridge CFTypeRef)NSApp)

@implementation Schwarzwald

+ (NSApplication *)createApplication {
  return [self createApplication:[NSApplication class]];
}

+ (NSApplication *)createApplication:(Class)applicationClass {
  NSApplication *application;

  // NSApp needs to be cleared because NSApplication has an internal check causing its init to throw if another NSApplication has previously been created (which it apparentlys checks by looking at NSApp.  However, there are memory-management problems (see below).
  NSApp = nil;

  application = [[applicationClass alloc] init];

  // When we get to the point, there are two strong references to the application: local application, and global NSApp.  But somehow, the object's retain count seems to only be 1.  The local reference is returned and used by the test and is generally disposed of first, meaning that the `NSApp = nil` line above will over-release the object.  We retain it an extra time to allow this to work.
  AntiARCRetain(NSApp);

  if (!application) [[NSException exceptionWithName:@"SchwarzwaldInitializationException" reason:[NSString stringWithFormat:@"[[%@ alloc] init] returned nil", NSStringFromClass(applicationClass)] userInfo:nil] raise];
  if (application != NSApp) [[NSException exceptionWithName:@"SchwarzwaldInternalError" reason:[NSString stringWithFormat:@"[[%@ alloc] init] did not set NSApp", NSStringFromClass(applicationClass)] userInfo:nil] raise];
  // TODO: probably should also validate that [applicationClass sharedApplication] == [NSApplication sharedApplication] == NSApp
  return application;
}

+ (NSApplication *)createApplicationWithTestBundle:(NSString *)specBundleIdentifier mainPlist:(NSString *)appPlistFilename {
  NSApp = nil;
  activeWindows = [NSMutableArray array];

  // Start the app
  NSBundle *specBundle = [NSBundle bundleWithIdentifier:specBundleIdentifier];
  NSString *plistPath =
  [specBundle pathForResource:appPlistFilename ofType:@"plist"];
  NSDictionary *infoDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
  Class principalClass = NSClassFromString([infoDictionary objectForKey:@"NSPrincipalClass"]);
  NSAssert([principalClass respondsToSelector:@selector(sharedApplication)], @"Principal class must implement sharedApplication.");
  NSApplication *application = [self createApplication:principalClass];
  if (!application) @throw [NSException exceptionWithName:@"SchwarzwaldInitializationException" reason:[NSString stringWithFormat:@"[%@ sharedApplication] returned nil", NSStringFromClass(principalClass)] userInfo:nil];

  // Load the nib file
  NSString *mainNibName = [infoDictionary objectForKey:@"NSMainNibFile"];
  NSNib *mainNib = [[NSNib alloc] initWithNibNamed:mainNibName bundle:specBundle];
  [mainNib instantiateWithOwner:application topLevelObjects:nil];

  // Set the key window
  [application.windows[0] makeKeyWindow];

  return application;
}

+ (NSArray *)visibleWindows {
  NSMutableArray *visibleWindows = [NSMutableArray array];
  for (WeakReference *ref in activeWindows) {
    NSWindow *window = ref.nonretainedObjectValue;
    if ([window isVisible]) {
      [visibleWindows addObject:window];
    }
  }
  return visibleWindows;
}

+ (NSWindow *)visibleWindow {
  NSArray *visibleWindows = [self visibleWindows];
  if (visibleWindows.count < 1) @throw [NSException exceptionWithName:@"SchwarzwaldFailure" reason:@"No visible windows" userInfo:nil];
  if (visibleWindows.count > 1) @throw [NSException exceptionWithName:@"SchwarzwaldFailure" reason:@"Expected one visible window, but found multiple visible windows" userInfo:nil];
  return visibleWindows[0];
}

+ (void)addActiveWindow:(NSWindow *)window {
  for (WeakReference *ref in activeWindows) {
    if (ref.nonretainedObjectValue == window) return;
  }
  [activeWindows addObject:[WeakReference weakReferenceWithObject:window]];
}

+ (void)advanceMinutes:(NSInteger)minutes {
  [NSTimer fireTimers];
}

@end
