#import "NSWindow+Schwarzwald.h"
#import "WeakReference.h"
#import <objc/runtime.h>
#import "Schwarzwald.h"
#import "NSApplication+Schwarzwald.h"

@interface Schwarzwald (Protected)

+ (void)addActiveWindow:(NSWindow *)window;

@end

@implementation NSWindow (Schwarzwald)

+ (void)load {
  // From http://nshipster.com/method-swizzling/
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class cl = [self class];

    SEL originalSelector = @selector(orderFront:);
    SEL swizzledSelector = @selector(__swizzled_orderFront:);

    Method originalMethod = class_getInstanceMethod(cl, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(cl, swizzledSelector);

    BOOL didAddMethod = class_addMethod(cl, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
      class_replaceMethod(cl, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
      method_exchangeImplementations(originalMethod, swizzledMethod);
    }
  });
}

- (NSButton *)findButtonWithText:(NSString *)text {
  return [self.contentView findButtonWithText:text];
}

#pragma mark - Swizzled methods

- (void)__swizzled_orderFront:(id)sender {
  [Schwarzwald addActiveWindow:self];
  [self __swizzled_orderFront:sender];
}

#pragma mark - Category overrides

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (void)makeKeyWindow {
  [NSApplication sharedApplication].keyWindow = self;
}

#pragma clang diagnostic pop

@end
