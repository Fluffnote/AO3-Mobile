import {
  ApplicationConfig, provideAppInitializer,
  provideBrowserGlobalErrorListeners,
  provideZoneChangeDetection
} from '@angular/core';
import { provideRouter } from '@angular/router';

import { routes } from './app.routes';
import { provideIonicAngular } from '@ionic/angular/standalone';
import {Init} from './data/init';
import {SQL} from './data/DB/sql';
import {CapSQLite} from './data/DB/lib/cap-sqlite';
import {DbNameVersion} from './data/DB/lib/db-name-version';
import {provideHttpClient, withFetch, withInterceptors} from '@angular/common/http';
import {AO3, loggingInterceptor} from './data/handlers/ao3';

export function initializeFactory(init: Init) {
  return () => init.initializeApp();
}

export const appConfig: ApplicationConfig = {
  providers: [
    SQL, Init, CapSQLite, DbNameVersion, AO3,
    provideBrowserGlobalErrorListeners(),
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(routes), provideIonicAngular({}),
    provideAppInitializer(async () => initializeFactory),
    provideHttpClient(
      withFetch(),
      withInterceptors([loggingInterceptor])
    )
  ]
};
