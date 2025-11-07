import { Injectable } from '@angular/core';
import {SQL} from '../DB/sql';
import {Observable, Subject} from 'rxjs';
import {History} from '../models/history';
import {createObservable} from './create-observable';
import {logger} from './logger';

@Injectable({
  providedIn: 'root'
})
export class HistoryMgmt {

  constructor(private sql: SQL) { }


  historyList: Subject<History[]> = new Subject<History[]>()


  async updateHistoryList(): Promise<void> {
    let out: History[] = [];
    try {
      const query =
        `WITH MAX_HISTORY AS (
            SELECT WORK_ID, MAX(ACCESS_DATE) AS MAX_ACCESS_DATE FROM HISTORY GROUP BY WORK_ID
         )
         SELECT *
         FROM HISTORY H
         JOIN MAX_HISTORY M ON H.WORK_ID = M.WORK_ID AND H.ACCESS_DATE = M.MAX_ACCESS_DATE
         ORDER BY ACCESS_DATE DESC`;

      const histories = await this.sql.queryPromise(query);
      if (histories.length > 0) {
        for (let historyData of histories) {
          let tempHistory = new History();
          tempHistory.workId = historyData.WORK_ID;
          tempHistory.chapterId = historyData.CHAPTER_ID;
          tempHistory.workTitle = historyData.WORK_TITLE;
          tempHistory.author = historyData.AUTHOR;
          tempHistory.chapterHeader = historyData.CHAPTER_HEADER;
          tempHistory.scrollPosition = historyData.SCROLL_POSITION;
          tempHistory.scrollMax = historyData.SCROLL_MAX;
          tempHistory.accessDate = historyData.ACCESS_DATE;
          out.push(tempHistory);
        }
      }
    }
    catch (err) {
      logger.error((err as Error).message);
      logger.error((err as Error).stack+"");
    }

    this.historyList.next(out);
  }

  get(workId: number, chapterId: number): Observable<History> {
    return createObservable(this.DB2History, this.sql, workId, chapterId)
  }

  private async DB2History(sql:SQL, workId: number, chapterId: number): Promise<History> {
    let history = new History();
    history.workId = workId;
    history.chapterId = chapterId;
    try {
      const histories = await sql.queryPromise(`SELECT * FROM HISTORY WHERE CHAPTER_ID = ${chapterId} AND WORK_ID = ${workId}`);
      if (histories.length > 0) { // Grab from DB
        const historyData = histories[0];
        history.workTitle = historyData.WORK_TITLE;
        history.author = historyData.AUTHOR;
        history.chapterHeader = historyData.CHAPTER_HEADER;
        history.scrollPosition = historyData.SCROLL_POSITION;
        history.scrollMax = historyData.SCROLL_MAX;
      }
      else { // Create a new entry
        const works = await sql.queryPromise(`SELECT * FROM WORK_CACHE WHERE ID = ${workId}`);
        if (works.length > 0) {
          const workData = works[0];
          history.workTitle = workData.TITLE;
          history.author = workData.AUTHOR;
        }
        history.accessDate = new Date();

        const insertSQL =
          `INSERT INTO HISTORY (WORK_ID, CHAPTER_ID, WORK_TITLE, AUTHOR, CHAPTER_HEADER,
                                   SCROLL_POSITION, SCROLL_MAX, ACCESS_DATE)
         VALUES (?, ?, ?, ?, ?,
                 0, 0, ?)`;
        await sql.execute(insertSQL, [
          history.workId, history.chapterId, history.workTitle, history.author, history.chapterHeader,
          history.accessDate
        ])
      }
    }
    catch (err) {
      logger.error((err as Error).message);
      logger.error((err as Error).stack+"");
    }
    return history;
  }

  async update(history: History): Promise<void> {
    const updateSQL = `UPDATE HISTORY SET CHAPTER_HEADER = ?, SCROLL_POSITION = ?, SCROLL_MAX = ?,
                                          ACCESS_DATE = ?
                       WHERE CHAPTER_ID = ${history.chapterId} AND WORK_ID = ${history.workId}`;
    await this.sql.execute(updateSQL, [
      history.chapterHeader, history.scrollPosition, history.scrollMax,
      new Date()
    ])
  }

}
