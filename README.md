Integration testing for OS X.

## Example usage

 - Add the Schwarzwald framework as a dependency to your test target
 - Add your main app's Info.plist file to your test target

```objc
NSApplication *application = [Schwarzwald initWithTestBundle:@"com.example.MyAppTests" mainPlist:@"MyApp-Info"];

[application click:@"My Button"];

[Schwarzwald visibleWindow].title should equal(@"My App");
```
