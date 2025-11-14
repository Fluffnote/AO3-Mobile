import {
  ApplicationConfig, importProvidersFrom,
  provideBrowserGlobalErrorListeners,
  provideZoneChangeDetection
} from '@angular/core';
import { provideRouter } from '@angular/router';

import { routes } from './app.routes';
import { provideIonicAngular } from '@ionic/angular/standalone';
import {SQL} from './data/DB/sql';
import {CapSQLite} from './data/DB/lib/cap-sqlite';
import {DbNameVersion} from './data/DB/lib/db-name-version';
import {AO3} from './data/handlers/ao3';
import {Search} from './data/handlers/search';
import {WorkPipeline} from './data/handlers/class/work-pipeline';

export const appConfig: ApplicationConfig = {
  providers: [
    SQL, CapSQLite, DbNameVersion, AO3, Search,
    WorkPipeline,
    provideBrowserGlobalErrorListeners(),
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(routes), provideIonicAngular({})
  ]
};
