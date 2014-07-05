#import "NSView+Schwarzwald.h"

@implementation NSView (Schwarzwald)

- (NSButton *)findButtonWithText:(NSString *)text {
  for (NSView *subview in self.subviews) {
    NSButton *button = [subview findButtonWithText:text];
    if (button) return button;
  }
  return nil;
}

@end
