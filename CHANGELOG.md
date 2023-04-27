# Changelog

## v1.0.4

### Changed

- From IOS 16.0 [CTCarrier was deprecated](https://developer.apple.com/documentation/coretelephony/cttelephonynetworkinfo/3024511-servicesubscribercellularprovide/). See [issue](https://github.com/dev-family/react-native-device-country/issues/7).
  Therefore, on IOS it is now possible to get only the country code from the phone settings and passing types are not supported.

## v1.0.2

### Fixed

- Update json response's country code key ([8c249c7058c40b69ad9a8d2e3f7b14e455f2d74a](https://github.com/dev-family/react-native-device-country/pull/3/commits/8c249c7058c40b69ad9a8d2e3f7b14e455f2d74a) by [@juancarlosqr](https://github.com/juancarlosqr))
- Fixed deprecated Objective-C method [#2](https://github.com/dev-family/react-native-device-country/issues/2)
