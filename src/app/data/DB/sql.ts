import { Injectable } from '@angular/core';
import {UpgradePathStatements} from './upgrade-path.statements';
import {SQLiteDBConnection} from '@capacitor-community/sqlite';
import {CapSQLite} from './lib/cap-sqlite';
import {DbNameVersion} from './lib/db-name-version';

@Injectable({
  providedIn: 'root'
})
export class SQL {
  private databaseName: string = "";
  private updStmts: UpgradePathStatements = new UpgradePathStatements();
  private versionUpgrades;
  private loadToVersion;
  private db!: SQLiteDBConnection;

  constructor(private sqliteService: CapSQLite,
              private dbVerService: DbNameVersion) {
    this.versionUpgrades = this.updStmts.upgradeStmts;
    this.loadToVersion = this.versionUpgrades[this.versionUpgrades.length-1].toVersion;
  }
  async initializeDatabase(dbName: string) {
    this.databaseName = dbName;
    // create upgrade statements
    await this.sqliteService
      .addUpgradeStatement({
        database: this.databaseName,
        upgrade: this.versionUpgrades
      });
    // create and/or open the database
    this.db = await this.sqliteService.openDatabase(this.databaseName,
      false,
      'no-encryption',
      this.loadToVersion,
      false
    );
    this.dbVerService.set(this.databaseName, this.loadToVersion);
  }
}
