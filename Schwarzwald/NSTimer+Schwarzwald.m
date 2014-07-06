#import "NSTimer+Schwarzwald.h"

NSMutableArray *activeTimers;

@implementation NSTimer (Schwarzwald)

+ (void)load {
  activeTimers = [NSMutableArray array];
}

+ (void)fireTimers {
  [activeTimers[0] fire];
}

#pragma mark - Category overrides

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
  NSTimer *timer = [NSTimer timerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
  [activeTimers addObject:timer];
  return timer;
}

#pragma clang diagnostic pop

@end
