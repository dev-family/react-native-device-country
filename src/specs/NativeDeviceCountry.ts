import { TurboModule, TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  getCountryCode(type: string): Promise<{
    code: string;
    type: string;
  }>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('NativeDeviceCountry');
