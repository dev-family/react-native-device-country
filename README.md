<a href="https://dev.family/?utm_source=github&utm_medium=react-native-device-country&utm_campaign=readme"><img width="auto" center src="https://github.com/dev-family/react-native-device-country/blob/main/docs/logo.png?raw=true" /></a>

# react-native-device-country

Get device location by telephony (SIM card) or settings without using GPS tracker

[![npm version](https://badge.fury.io/js/react-native-device-country.svg)](https://www.npmjs.org/package/react-native-device-country)
[![npm](https://img.shields.io/npm/dt/react-native-device-country.svg)](https://www.npmjs.org/package/react-native-device-country)
[![MIT](https://img.shields.io/dub/l/vibe-d.svg)](https://opensource.org/licenses/MIT)
<br>
[![Platform - Android](https://img.shields.io/badge/platform-Android-3ddc84.svg?style=flat&logo=android)](https://www.android.com)
[![Platform - iOS](https://img.shields.io/badge/platform-iOS-000.svg?style=flat&logo=apple)](https://developer.apple.com/ios)

<img width="400" height="auto" center src="https://github.com/dev-family/react-native-device-country/blob/main/docs/screenshot.png?raw=true" />

## Installation

```sh
yarn add react-native-device-country
```

or

```sh
npm install react-native-device-country
```

_Don't forget to run `pod install` after that!_

## Usage

```js
import DeviceCountry, {
  TYPE_ANY,
  TYPE_TELEPHONY,
  TYPE_CONFIGURATION,
} from 'react-native-device-country';

// ...

DeviceCountry.getCountryCode()
  .then((result) => {
    console.log(result);
    // {"code": "BY", "type": "telephony"}
  })
  .catch((e) => {
    console.log(e);
  });
```

### You can use spicific method for getting country

`TYPE_TELEPHONY` for getting country code from SIM card

```js
DeviceCountry.getCountryCode(TYPE_TELEPHONY)
  .then((result) => {
    console.log(result);
    // {"code": "BY", "type": "telephony"}
  })
  .catch((e) => {
    console.log(e);
  });
```

or `TYPE_CONFIGURATION` for getting country code from phone location settings on iOS and phone language settings on Android

```js
DeviceCountry.getCountryCode(TYPE_CONFIGURATION)
  .then((result) => {
    console.log(result);
    // {"code": "BY", "type": "config"}
  })
  .catch((e) => {
    console.log(e);
  });
```

`TYPE_ANY` will be used by default. It tries to use `TYPE_TELEPHONY` and fallbacks with `TYPE_CONFIGURATION`, if devive without SIM card.

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
