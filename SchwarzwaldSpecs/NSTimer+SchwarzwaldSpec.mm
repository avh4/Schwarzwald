#import "NSTimer+Schwarzwald.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

@protocol TestCallback <NSObject>
- (void)call;
@end

SPEC_BEGIN(NSTimer_SchwarzwaldSpec)

describe(@"NSTimer+Schwarzwald", ^{
  __block id<TestCallback, CedarDouble> callback1;
  __block id<TestCallback, CedarDouble> callback2;

  beforeEach(^{
    callback1 = nice_fake_for(@protocol(TestCallback));
    callback2 = nice_fake_for(@protocol(TestCallback));
  });

  describe(@"+fireTimers", ^{
    beforeEach(^{
      [NSTimer scheduledTimerWithTimeInterval:0 target:callback1 selector:@selector(call) userInfo:nil repeats:NO];
      [NSTimer scheduledTimerWithTimeInterval:0 target:callback2 selector:@selector(call) userInfo:nil repeats:NO];
      [NSTimer fireTimers];
    });

    it(@"should trigger schedule timers", ^{
      callback1 should have_received(@selector(call));
    });

    it(@"should trigger all scheduled timers", ^{
      callback2 should have_received(@selector(call));
    });

    it(@"should not call previously-triggered timers again", ^{
      [callback1 reset_sent_messages];
      [NSTimer fireTimers];
      callback1 should_not have_received(@selector(call));
    });
  });
});

SPEC_END
