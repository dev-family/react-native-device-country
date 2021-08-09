import { NativeModules } from 'react-native';
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

export const getCountryCode = (type?: Types) => {
  return new Promise<ResolveType>((resolve, reject) => {
    DeviceCountryModule.getCountryCode(type || TYPE_ANY)
      .then((result: Object | string) => {
        resolve(typeof result === 'object' ? result : JSON.parse(result));
      })
      .catch((e: any) => {
        reject(e);
      });
  });
};

export default {
  getCountryCode,
};
