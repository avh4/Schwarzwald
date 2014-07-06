#import <Cocoa/Cocoa.h>

@interface NSApplication (Schwarzwald)

- (NSButton *)findButtonWithText:(NSString *)text;
- (void)click:(NSString *)buttonText;

- (void)setKeyWindow:(NSWindow *)window;

@end
