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
    return createObservable(HistoryMgmt.DB2History, this.sql, workId, chapterId, true)
  }

  static async DB2History(sql:SQL, workId: number, chapterId: number, createNew: boolean): Promise<History|null> {
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
      else if (createNew) { // Create a new entry
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
                 0, 10, ?)`;
        await sql.execute(insertSQL, [
          history.workId, history.chapterId, history.workTitle, history.author, history.chapterHeader,
          history.accessDate
        ])
      }
      else return null;
    }
    catch (err) {
      logger.error((err as Error).message);
      logger.error((err as Error).stack+"");
    }
    return history;
  }

  static async DB2RecentChapterId(sql:SQL, workId: number): Promise<number|null> {
    try {
      const query =
        `SELECT CHAPTER_ID, ACCESS_DATE
         FROM HISTORY H
         WHERE WORK_ID = ${workId}
         ORDER BY ACCESS_DATE DESC`;

      const histories = await sql.queryPromise(query);
      if (histories.length > 0) { // Grab from DB
        const historyData = histories[0];
        return historyData.CHAPTER_ID;
      }
    }
    catch (err) {
      logger.error((err as Error).message);
      logger.error((err as Error).stack+"");
    }
    return null;
  }

  async resetPos(workId: number, chapterId: number): Promise<void> {
    try {
      await this.sql.execute(`UPDATE HISTORY SET SCROLL_POSITION = 0 WHERE CHAPTER_ID = ${chapterId} AND WORK_ID = ${workId}`);
    }
    catch (err) {
      logger.error((err as Error).message);
      logger.error((err as Error).stack+"");
    }
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
