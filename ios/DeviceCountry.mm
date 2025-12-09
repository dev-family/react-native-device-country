#import <NativeDeviceCountrySpec/NativeDeviceCountrySpec.h>
#import "react_native_device_country-Swift.h"

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
