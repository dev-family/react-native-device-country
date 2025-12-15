#import <NativeDeviceCountrySpec/NativeDeviceCountrySpec.h>
#if __has_include(<react_native_device_country/react_native_device_country-Swift.h>)
// if use_frameworks! :static
#import <react_native_device_country/react_native_device_country-Swift.h>
#else
#import "react_native_device_country-Swift.h"
#endif

@interface NativeDeviceCountry : NSObject <NativeDeviceCountrySpec>
@end

@implementation NativeDeviceCountry

RCT_EXPORT_MODULE();

DeviceCountryImpl *deviceCountry = [[DeviceCountryImpl alloc] init];

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeDeviceCountrySpecJSI>(params);
}

- (void)getCountryCode:(nonnull NSString *)type resolve:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject {
  NSDictionary<NSString *, NSString *> *result = [deviceCountry getCountryCode:type];
  if (result) {
          resolve(result);
  } else {
    reject(@"event_failure", @"No country code found exception", nil);
  }
}

@end
