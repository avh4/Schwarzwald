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

  describe(@"-findButtonWithText", ^{
    __block NSButton *button;

    beforeEach(^{
      button = nice_fake_for([NSButton class]);
      spy_on(subject.contentView);
      subject.contentView stub_method(@selector(findButtonWithText:)).with(@"Text").and_return(button);
      subject.isVisible = YES;
    });

    it(@"should search the window's content view", ^{
      [subject findButtonWithText:@"Text"] should be_same_instance_as(button);
    });

    it(@"when the window is not visible should return nil", ^{
      subject.isVisible = NO;
      [subject findButtonWithText:@"Text"] should be_nil;
    });
  });
});

SPEC_END
