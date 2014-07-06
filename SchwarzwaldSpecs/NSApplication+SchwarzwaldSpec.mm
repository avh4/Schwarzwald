#import "NSApplication+Schwarzwald.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(NSApplicationSpec)

describe(@"NSApplication", ^{
  __block NSApplication *subject;

  beforeEach(^{
    NSApp = nil;
    subject = [[NSApplication alloc] init];
  });

  it(@"should be able to set the key window", ^{
    NSWindow *window = nice_fake_for([NSWindow class]);
    subject.keyWindow = window;
    subject.keyWindow should be_same_instance_as(window);
  });
});

SPEC_END
