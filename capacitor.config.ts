import type { CapacitorConfig } from '@capacitor/cli';
import {localServer} from './localSettings';

let config: CapacitorConfig = {
  appId: 'com.fluffnote.ao3Mobile',
  appName: 'AO3 Mobile',
  webDir: 'dist/AO3-Mobile/browser',
  server: {
    url: localServer,
    cleartext: true
  },
  plugins: {
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
    }
  }
};

export default config;
