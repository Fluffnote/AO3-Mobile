import type { CapacitorConfig } from '@capacitor/cli';
import localConfig from './localSettings';

let config: CapacitorConfig = localConfig || {}

config.appId = 'com.fluffnote.ao3dweller';
config.appName = 'AO3 Dweller';
config.webDir = 'dist/AO3-Mobile/browser';
config.plugins = {
  StatusBar: {
    overlaysWebView: false,
    style: "dark",
    backgroundColor: "#970000"
  },
  CapacitorSQLite: {
    iosDatabaseLocation: 'Library/Database',
    iosIsEncryption: false,
    iosKeychainPrefix: 'ao3-mobile',
    iosBiometric: {
      biometricAuth: false,
      biometricTitle : "Biometric login for capacitor sqlite"
    },
    androidIsEncryption: false,
    androidBiometric: {
      biometricAuth : false,
      biometricTitle : "Biometric login for capacitor sqlite",
      biometricSubTitle : "Log in using your biometric"
    }
  },
  CapacitorHttp: {
    enabled: true
  }
};

export default config;
