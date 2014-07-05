#import "Schwarzwald.h"
#import "WeakReference.h"

NSMutableArray *activeWindows;


@implementation Schwarzwald

+ (NSApplication *)initWithTestBundle:(NSString *)specBundleIdentifier mainPlist:(NSString *)appPlistFilename {
  activeWindows = [NSMutableArray array];

  // Start the app
  NSBundle *specBundle = [NSBundle bundleWithIdentifier:specBundleIdentifier];
  NSString *plistPath =
  [specBundle pathForResource:appPlistFilename ofType:@"plist"];
  NSDictionary *infoDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
  Class principalClass = NSClassFromString([infoDictionary objectForKey:@"NSPrincipalClass"]);
  NSAssert([principalClass respondsToSelector:@selector(sharedApplication)], @"Principal class must implement sharedApplication.");
  NSApplication *application = [principalClass sharedApplication];
  if (!application) @throw [NSException exceptionWithName:@"SchwarzwaldInitializationException" reason:[NSString stringWithFormat:@"[%@ sharedApplication] returned nil", NSStringFromClass(principalClass)] userInfo:nil];

  // Load the nib file
  NSString *mainNibName = [infoDictionary objectForKey:@"NSMainNibFile"];
  NSNib *mainNib = [[NSNib alloc] initWithNibNamed:mainNibName bundle:specBundle];
  [mainNib instantiateWithOwner:application topLevelObjects:nil];

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

+ (void)addActiveWindow:(NSWindow *)window {
  [activeWindows addObject:[WeakReference weakReferenceWithObject:window]];
}

@end
