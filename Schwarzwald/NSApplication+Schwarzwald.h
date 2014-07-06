#import <Cocoa/Cocoa.h>

@interface NSApplication (Schwarzwald)

- (NSButton *)findButtonWithText:(NSString *)text;
- (void)click:(NSString *)buttonText;
- (NSArray *)visibleWindows;

- (void)setKeyWindow:(NSWindow *)window;

@end
