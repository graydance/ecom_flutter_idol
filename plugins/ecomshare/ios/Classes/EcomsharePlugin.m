#import "EcomsharePlugin.h"
#if __has_include(<ecomshare/ecomshare-Swift.h>)
#import <ecomshare/ecomshare-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ecomshare-Swift.h"
#endif

@implementation EcomsharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftEcomsharePlugin registerWithRegistrar:registrar];
}
@end
