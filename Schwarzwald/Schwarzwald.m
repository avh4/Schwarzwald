#import "Schwarzwald.h"
#import "WeakReference.h"

NSMutableArray *activeWindows;


@implementation Schwarzwald

+ (void)load {
  activeWindows = [NSMutableArray array];
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
