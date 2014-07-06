#import "NSApplication+Schwarzwald.h"
#import "NSWindow+Schwarzwald.h"
#import <objc/runtime.h>

@implementation NSApplication (Schwarzwald)

- (NSButton *)findButtonWithText:(NSString *)text {
  for (NSWindow *window in self.windows) {
    NSButton *button = [window findButtonWithText:text];
    if (button) return button;
  }
  return nil;
}

- (void)click:(NSString *)buttonText {
  NSButton *button = [self findButtonWithText:buttonText];
  if (!button) @throw [NSException exceptionWithName:@"NSButton not found" reason:[NSString stringWithFormat:@"%@ has no visible button with text: %@", self, buttonText] userInfo:nil];
  [button performClick:nil];
}

- (void)setKeyWindow:(NSWindow *)window {
  objc_setAssociatedObject(self, @selector(keyWindow), window, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)visibleWindows {
  return [self.windows filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isVisible = YES"]];
}

#pragma mark - Category overrides

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (NSWindow *)keyWindow {
  return objc_getAssociatedObject(self, @selector(keyWindow));
}

#pragma clang diagnostic pop

@end
