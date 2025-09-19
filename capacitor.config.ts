import type { CapacitorConfig } from '@capacitor/cli';
import {localServer} from './localSettings';

const config: CapacitorConfig = {
  appId: 'com.fluffnote.ao3Mobile',
  appName: 'AO3 Mobile',
  webDir: 'dist/AO3-Mobile/browser',
  server: {
    url: localServer,
    cleartext: true
  },
  "plugins": {
    "StatusBar": {
      "overlaysWebView": false,
      "style": "dark",
      "backgroundColor": "#970000"
    }
  }
};

export default config;
