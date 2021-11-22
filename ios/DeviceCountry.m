#import "DeviceCountry.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation DeviceCountry

NSString * const TYPE_ANY = @"any";
NSString * const TYPE_CONFIGURATION = @"config";
NSString * const TYPE_TELEPHONY = @"telephony";

RCT_EXPORT_MODULE(DeviceCountryModule);

RCT_EXPORT_METHOD(
                  getCountryCode:(NSString *)type
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{

  NSString * countryCode = NULL;
  NSString * resolveType = type;

  if ([type isEqualToString:TYPE_TELEPHONY] || [type isEqualToString:TYPE_ANY]) {
    countryCode = [self getCountryCodeFromTelephonyNetworkInfo];
    resolveType = TYPE_TELEPHONY;
  }

  if ([type isEqualToString:TYPE_CONFIGURATION] || (countryCode == NULL && [type isEqualToString:TYPE_TELEPHONY] == FALSE)) {
    countryCode = [self getCountryCodeFromLocale];
    resolveType = TYPE_CONFIGURATION;
  }

  @try {
    NSString * result = [self getDictionaryResult:countryCode countryCodeType:resolveType];
    resolve(result);
    return;
  }
  @catch (NSException * e) {
    reject(@"event_failure", @"No country code found exception", nil);
    return;
  }
}

- (NSString *)getDictionaryResult:(NSString *)countryCode countryCodeType:(NSString *)type
{
  if (countryCode == NULL) {
    [NSException raise:@"Country code is empty" format:@""];
  }

  NSDictionary * data = @{@"code":countryCode,@"type":type};
  return @[data][0];
}

- (NSString *)getCountryCodeFromTelephonyNetworkInfo
{
  @try {
    CTTelephonyNetworkInfo * telephony = [CTTelephonyNetworkInfo new];
    CTCarrier *carrier;
    if (@available(iOS 12.1, *)) {
      NSDictionary<NSString *, CTCarrier *> *carriers = [telephony serviceSubscriberCellularProviders];
      carrier = [self firstCarrier:carriers];
    } else if (@available(iOS 12, *)) {
      NSDictionary<NSString *, CTCarrier *> *carriers = [telephony valueForKey:@"serviceSubscriberCellularProvider"];
      carrier = [self firstCarrier:carriers];
    }
    if (carrier == nil) {
        carrier = [telephony subscriberCellularProvider];
    }
    NSString * countryCode = [carrier.isoCountryCode uppercaseString];
    return countryCode;
  }
  @catch ( NSException *e ) {
    return NULL;
  }
}

- (CTCarrier *)firstCarrier:(NSDictionary<NSString *, CTCarrier *> *)carriers {
  NSEnumerator * en = [carriers objectEnumerator];
  if ([[en.allObjects firstObject] isKindOfClass:(CTCarrier.class)]) {
      CTCarrier * carrier = (CTCarrier *)[en.allObjects firstObject];
      return carrier;
  }
  return nil;
}

- (NSString *)getCountryCodeFromLocale
{
  @try {
    NSLocale * locale = [NSLocale currentLocale];
    NSString * countryCode = [locale objectForKey: NSLocaleCountryCode];

    return countryCode;
  }
  @catch ( NSException *e ) {
    return NULL;
  }
}

@end