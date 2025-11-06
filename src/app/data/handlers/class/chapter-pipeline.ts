import {Injectable} from '@angular/core';
import {SQL} from '../../DB/sql';
import {AO3} from '../ao3';
import {concatMap, map, Observable} from 'rxjs';
import {Chapter} from '../../models/chapter';
import {createObservable} from '../create-observable';
import {ChapterParser} from '../../parsers/chapter-parser';
import {HttpResponse} from '@capacitor/core';
import {logger} from '../logger';

@Injectable({
  providedIn: 'root'
})
export class ChapterPipeline {

  constructor(
    private sql: SQL,
    private ao3: AO3
  ) { }

  // Gets Chapter object
  //
  // [refreshType] = 0 : Doesn't refresh - Only grabs database info
  //
  // [refreshType] = 1 : Soft refresh - Will attempt to refresh info if it has been more than 1 hour from last fetch
  //
  // [refreshType] = 2 : Hard refresh - Will attempt to refresh info regardless of last fetch
  get(workId: number, chapterId: number, refreshType?: number): Observable<Chapter> {
    refreshType = refreshType ? refreshType : 0;
    return createObservable(this.DB2Chapter, this.sql, workId, chapterId).pipe(concatMap(chapter => this.refreshChapter(chapter as Chapter, refreshType)));
  }

  private refreshChapter(chapter: Chapter, refreshType: number): Observable<Chapter> {
    if (refreshType >= 2 || (refreshType == 1 && chapter.lastFetchDate.getTime() < new Date().getTime() - (24 * 60 * 60 * 1000))) {
      return this.ao3.getChapterPage(chapter.workId, chapter.id).pipe(map(response => this.responseToChapter(chapter, response)));
    }

    // Only send db Work
    return new Observable(subscriber => {
      subscriber.next(chapter);
      subscriber.complete();
    });
  }

  private responseToChapter(startObj: Chapter, response: HttpResponse): Chapter {
    let chapter = new ChapterParser().parse(startObj, new DOMParser().parseFromString(response.data, "text/html"))
    ChapterPipeline.Chapter2DB(this.sql, chapter); // Caching object
    return chapter;
  }

  private async DB2Chapter(sql:SQL, workId: number, chapterId: number): Promise<Chapter> {
    let chapter = new Chapter();
    chapter.workId = workId;
    chapter.id = chapterId;
    try {
      const chapters = await sql.queryPromise(`SELECT * FROM CHAPTER_CACHE WHERE CHAPTER_ID = ${chapter.id} AND WORK_ID = ${chapter.workId}`);
      if (chapters.length > 0) {
        const chapterData = chapters[0];
        chapter.id = chapterData.CHAPTER_ID;
        chapter.workId = chapterData.WORK_ID;
        chapter.nextId = chapterData.NEXT_ID;
        chapter.order = chapterData.ORDER_NUM
        chapter.chapterListHeader = chapterData.CHAPTER_LIST_HEADER;
        chapter.chapterHeader = chapterData.CHAPTER_HEADER;
        chapter.summary = chapterData.SUMMARY;
        chapter.notes = chapterData.NOTES.split("|;|");
        chapter.endNotes = chapterData.END_NOTES.split("|;|");
        chapter.body = chapterData.BODY;
        chapter.lastFetchDate = chapterData.LAST_FETCHED_DATE != null? new Date(chapterData.LAST_FETCHED_DATE) : new Date(0);
        chapter.parserVersion = chapterData.PARSER_VERSION;
      }
    }
    catch (err) {
      logger.error((err as Error).message);
      logger.error((err as Error).stack+"");
      chapter.lastFetchDate = new Date(0);
    }
    return chapter;
  }

  static async Chapter2DB(sql:SQL, chapter: Chapter): Promise<void> {
    const check = await sql.queryPromise(`SELECT * FROM CHAPTER_CACHE WHERE CHAPTER_ID = ${chapter.id} AND WORK_ID = ${chapter.workId}`);
    if (check.length == 0) { // Insert
      const insertSQL =
        `INSERT INTO CHAPTER_CACHE (CHAPTER_ID, WORK_ID, NEXT_ID, ORDER_NUM, CHAPTER_LIST_HEADER,
                                   CHAPTER_HEADER, SUMMARY, NOTES, END_NOTES, BODY,
                                   LAST_FETCHED_DATE, PARSER_VERSION)
         VALUES (?, ?, ?, ?, ?,
                 ?, ?, ?, ?, ?,
                 ?, ?)`;
      await sql.execute(insertSQL, [
        chapter.id, chapter.workId, chapter.nextId, chapter.order, chapter.chapterListHeader,
        chapter.chapterHeader, chapter.summary, chapter.notes.join("|;|"), chapter.endNotes.join("|;|"), chapter.body,
        chapter.lastFetchDate, chapter.parserVersion
      ])
    }
    else { // Update
      const updateSQL =
        `UPDATE CHAPTER_CACHE SET NEXT_ID = ?, ORDER_NUM = ?, CHAPTER_LIST_HEADER = ?,
                                  CHAPTER_HEADER = ?, SUMMARY = ?, NOTES = ?, END_NOTES = ?, BODY = ?,
                                  LAST_FETCHED_DATE = ?, PARSER_VERSION = ?
         WHERE CHAPTER_ID = ${chapter.id} AND WORK_ID = ${chapter.workId}`;
      await sql.execute(updateSQL, [
        chapter.nextId, chapter.order, chapter.chapterListHeader,
        chapter.chapterHeader, chapter.summary, chapter.notes.join("|;|"), chapter.endNotes.join("|;|"), chapter.body,
        chapter.lastFetchDate, chapter.parserVersion
      ])
    }
  }

  static async WorkChapters(sql:SQL, workId: number): Promise<Chapter[]> {
    let chapters: Chapter[] = [];

    const check = await sql.queryPromise(`SELECT * FROM CHAPTER_CACHE WHERE WORK_ID = ${workId} ORDER BY ORDER_NUM ASC`);
    if (check.length > 0) {
      for (let chapterData of check) {
        let chapter = new Chapter();
        chapter.workId = workId;
        chapter.id = chapterData.CHAPTER_ID;
        chapter.nextId = chapterData.NEXT_ID;
        chapter.order = chapterData.ORDER_NUM
        chapter.chapterListHeader = chapterData.CHAPTER_LIST_HEADER;
        chapter.chapterHeader = chapterData.CHAPTER_HEADER;
        chapter.summary = chapterData.SUMMARY;
        chapter.notes = chapterData.NOTES.split("|;|");
        chapter.endNotes = chapterData.END_NOTES.split("|;|");
        chapter.body = chapterData.BODY;
        chapter.lastFetchDate = chapterData.LAST_FETCHED_DATE != null? new Date(chapterData.LAST_FETCHED_DATE) : new Date(0);
        chapter.parserVersion = chapterData.PARSER_VERSION;
        chapters.push(chapter);
      }
    }

    return chapters;
  }
}
