#import "NSApplication+Schwarzwald.h"
#import "NSWindow+Schwarzwald.h"

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

@end
