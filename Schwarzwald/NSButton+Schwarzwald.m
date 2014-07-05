#import "NSButton+Schwarzwald.h"

@implementation NSButton (Schwarzwald)

- (NSButton *)findButtonWithText:(NSString *)text {
  if ([self.title isEqualToString:text]) return self;
  return nil;
}

@end
