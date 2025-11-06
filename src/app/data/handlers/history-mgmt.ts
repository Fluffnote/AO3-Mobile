import { Injectable } from '@angular/core';
import {SQL} from '../DB/sql';
import {Observable} from 'rxjs';
import {History} from '../models/history';
import {createObservable} from './create-observable';
import {logger} from './logger';

@Injectable({
  providedIn: 'root'
})
export class HistoryMgmt {

  constructor(private sql: SQL) { }

  get(workId: number, chapterId: number): Observable<History> {
    return createObservable(this.DB2History, this.sql, workId, chapterId)
  }

  private async DB2History(sql:SQL, workId: number, chapterId: number): Promise<History> {
    let history = new History();
    history.workId = workId;
    history.chapterId = chapterId;
    try {
      const histories = await sql.queryPromise(`SELECT * FROM HISTORY WHERE CHAPTER_ID = ${chapterId} AND WORK_ID = ${workId}`);
    }
    catch (err) {
      logger.error((err as Error).message);
      logger.error((err as Error).stack+"");
    }
    return history;
  }

  update(history: History) {

  }

}
