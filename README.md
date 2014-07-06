Integration testing for OS X.

## Example usage

 - Add the Schwarzwald framework as a dependency to your test target
 - Add your main app's Info.plist file to your test target

```objc
NSApplication *application = [Schwarzwald initWithTestBundle:@"com.example.MyAppTests" mainPlist:@"MyApp-Info"];

[application click:@"My Button"];

[Schwarzwald visibleWindow].title should equal(@"My App");
```

## Implementation Notes

`NSRunLoop` is completely bypassed with the following justification:
`NSRunLoop` only handles three types of events.  **Input events** are
completely simulated in tests and thus can be ignored.  **`NSTimer` events**
will be dealt with in an `NSTimer` category and thus can be ignored.  **Network
events** are not currently dealt with, but will most likely should be manually
controller with categories.  **`performSelector:` is implemented using
`NSTimer`, and thus is already dealt with.  The only unknown is whether or not
`NSApplication.updateWindows` will need to be called during tests.
