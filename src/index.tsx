import { NativeModules, Platform } from 'react-native';
const { DeviceCountryModule } = NativeModules;
export const TYPE_ANY = 'any';
export const TYPE_TELEPHONY = 'telephony';
export const TYPE_CONFIGURATION = 'config';

export type Types =
  | typeof TYPE_ANY
  | typeof TYPE_TELEPHONY
  | typeof TYPE_CONFIGURATION;

export interface ResolveType {
  code: string;
  type: string;
}

export const getCountryCodeIOS = () => {
  return new Promise<ResolveType>((resolve, reject) => {
    DeviceCountryModule.getCountryCode(TYPE_CONFIGURATION)
      .then((result: ResolveType) => {
        resolve(result);
      })
      .catch((e: any) => {
        reject(e);
      });
  });
};

export const getCountryCodeAndroid = (type?: Types) => {
  return new Promise<ResolveType>((resolve, reject) => {
    DeviceCountryModule.getCountryCode(type || TYPE_ANY)
      .then((result: string) => {
        resolve(JSON.parse(result));
      })
      .catch((e: any) => {
        reject(e);
      });
  });
};

export const getCountryCode = (type?: Types) => {
  return Platform.OS === 'ios'
    ? getCountryCodeIOS()
    : getCountryCodeAndroid(type);
};

export default {
  getCountryCode,
};
