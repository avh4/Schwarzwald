// From http://stackoverflow.com/a/14219598

@interface WeakReference : NSObject {
  __weak id nonretainedObjectValue;
  __unsafe_unretained id originalObjectValue;
}

+ (WeakReference *) weakReferenceWithObject:(id) object;

- (id) nonretainedObjectValue;
- (void *) originalObjectValue;

@end