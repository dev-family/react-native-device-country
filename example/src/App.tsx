import * as React from 'react';

import { StyleSheet, View, Text, SafeAreaView, StatusBar } from 'react-native';
import DeviceCountry, {
  // TYPE_ANY,
  TYPE_TELEPHONY,
  TYPE_CONFIGURATION,
  ResolveType,
  Types,
} from 'react-native-device-country';

export default function App() {
  const [countryCodeAny, setCountryCodeAny] = React.useState<
    ResolveType | undefined
  >();
  const [countryCodeTelephony, setCountryCodeTelephony] = React.useState<
    ResolveType | undefined
  >();
  const [
    countryCodeConfiguration,
    setCountryCodeConfiguration,
  ] = React.useState<ResolveType | undefined>();

  React.useEffect(() => {
    getCurrentContry().then((result) => {
      setCountryCodeAny(result);
    });
    getCurrentContry(TYPE_TELEPHONY).then((result) => {
      setCountryCodeTelephony(result);
    });
    getCurrentContry(TYPE_CONFIGURATION).then((result) => {
      setCountryCodeConfiguration(result);
    });
  }, []);

  const getCurrentContry = async (type?: Types) => {
    return await DeviceCountry.getCountryCode(type);
  };

  const getFlagEmoji = (countryCode: string) => {
    const codePoints = countryCode
      .toUpperCase()
      .split('')
      .map((char) => 127397 + char.charCodeAt(0));
    return String.fromCodePoint(...codePoints);
  };

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="dark-content" />
      <View style={styles.box}>
        {countryCodeAny && (
          <View style={styles.resultItem}>
            <Text>Type Any:</Text>
            <Text>
              {JSON.stringify(countryCodeAny)}{' '}
              {getFlagEmoji(countryCodeAny.code)}
            </Text>
          </View>
        )}
        {countryCodeTelephony && (
          <View style={styles.resultItem}>
            <Text>Type Telephony:</Text>
            <Text>
              {JSON.stringify(countryCodeTelephony)}{' '}
              {getFlagEmoji(countryCodeTelephony.code)}
            </Text>
          </View>
        )}
        {countryCodeConfiguration && (
          <View style={styles.resultItem}>
            <Text>Type Configuration:</Text>
            <Text>
              {JSON.stringify(countryCodeConfiguration)}{' '}
              {getFlagEmoji(countryCodeConfiguration.code)}
            </Text>
          </View>
        )}
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  box: {
    padding: 20,
  },
  resultItem: {
    marginBottom: 16,
  },
});
