import type {CapacitorConfig} from '@capacitor/cli';

const localConfig: CapacitorConfig = {
  server: {
    url: "http://localhost:4200",
    cleartext: true
  }
};
export default localConfig;
