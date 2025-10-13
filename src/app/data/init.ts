import { Injectable } from '@angular/core';
import {CapSQLite} from './DB/lib/cap-sqlite';
import {SQL} from './DB/sql';

@Injectable({
  providedIn: 'root'
})
export class Init {
  isAppInit: boolean = false;
  platform!: string;

  constructor(
    private sqliteService: CapSQLite,
    private sql: SQL,
  ) { }

  async initializeApp() {
    await this.sqliteService.initializePlugin().then(async (ret) => {
      this.platform = this.sqliteService.platform;
      try {
        if( this.sqliteService.platform === 'web') {
          await this.sqliteService.initWebStore();
        }
        const DB_NAME = 'library'
        await this.sql.initializeDatabase(DB_NAME);
        // Here Initialize MOCK_DATA if required

        // Initialize whatever database and/or MOCK_DATA you like

        if( this.sqliteService.platform === 'web') {
          await this.sqliteService.saveToStore(DB_NAME);
        }

        this.isAppInit = true;

      } catch (error) {
        console.log(`initializeAppError: ${error}`);
        // await Toast.show({
        //   text: `initializeAppError: ${error}`,
        //   duration: 'long'
        // });
      }
    });
  }

}
