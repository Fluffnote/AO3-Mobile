import { Injectable } from '@angular/core';
import {UpgradePathStatements} from './lib/upgrade-path.statements';
import {SQLiteDBConnection} from '@capacitor-community/sqlite';
import {CapSQLite} from './lib/cap-sqlite';
import {DbNameVersion} from './lib/db-name-version';
import {logger} from '../handlers/logger';
import {Observable} from 'rxjs';
import {createObservable} from '../handlers/create-observable';

@Injectable({
  providedIn: 'root'
})
export class SQL {
  private databaseName: string = "library";
  private updStmts: UpgradePathStatements = new UpgradePathStatements();
  private versionUpgrades;
  private loadToVersion;
  private db!: SQLiteDBConnection;

  constructor(private sqliteService: CapSQLite,
              private dbVerService: DbNameVersion) {
    this.versionUpgrades = this.updStmts.upgradeStmts;
    this.loadToVersion = this.versionUpgrades[this.versionUpgrades.length-1].toVersion;
  }
  async initializeDatabase() {
    await this.sqliteService.initializePlugin().then(async (ret) => {
      try {
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
      catch (err) {
        logger.error((err as Error).message);
        logger.error((err as Error).stack+"");
      }
    })
    logger.info("Database Initializing Done");
  }

  async closeDatabase() {
    if (this.db) {
      await this.db.close();
    }
  }


  query(query: string): Observable<any[]> { return createObservable(this.queryPromise, query) }
  async queryPromise(query: string): Promise<any[]> {
    if (!this.db) throw new Error('Database connection is not open');
    const result = await this.db.query(query);
    return result.values || [];
  }

  insert(stmt: string, values? : any[]): Observable<any> { return createObservable(this.execute, stmt, values) }
  update(stmt: string, values? : any[]): Observable<any> { return createObservable(this.execute, stmt, values) }
  delete(stmt: string, values? : any[]): Observable<any> { return createObservable(this.execute, stmt, values) }
  async execute(stmt: string, values? : any[]): Promise<any> {
    if (!this.db) throw new Error('Database connection is not open');
    return await this.db.run(stmt, values);
  }
}
