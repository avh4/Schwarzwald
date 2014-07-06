#import "NSWindow+Schwarzwald.h"
#import "Schwarzwald.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(NSWindow_SchwarzwaldSpec)

describe(@"NSWindow", ^{
  __block NSApplication *application;
  __block NSWindow *subject;

  beforeEach(^{
    application = [Schwarzwald createApplication];
    subject = [[NSWindow alloc] initWithContentRect:CGRectZero styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:YES];
  });

  describe(@"makeKeyWindow", ^{
    it(@"should set the application's key window", ^{
      [subject makeKeyWindow];
    });
  });
});

SPEC_END
