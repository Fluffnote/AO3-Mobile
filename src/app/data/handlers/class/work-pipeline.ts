import { Injectable } from '@angular/core';
import {SQL} from '../../DB/sql';
import {concatMap, map, Observable} from 'rxjs';
import {Work} from '../../models/work';
import {createObservable} from '../create-observable';
import {AO3} from '../ao3';
import {WorkParser} from '../../parsers/work-parser';
import {logger} from '../logger';
import {HttpResponse} from '@capacitor/core';
import {ChapterPipeline} from './chapter-pipeline';

@Injectable({
  providedIn: 'root'
})
export class WorkPipeline {

  constructor(
    private sql: SQL,
    private ao3: AO3
  ) { }

  // Gets Work object
  //
  // [refreshType] = 0 : Doesn't refresh - Only grabs database info
  //
  // [refreshType] = 1 : Soft refresh - Will attempt to refresh info if it has been more than 1 hour from last fetch
  //
  // [refreshType] = 2 : Hard refresh - Will attempt to refresh info regardless of last fetch
  get(id: number, refreshType?: number): Observable<Work> {
    refreshType = refreshType ? refreshType : 0;
    return createObservable(this.DB2Work, this.sql, id).pipe(concatMap(work => this.refreshWork(work as Work, refreshType)));
  }

  private refreshWork(work: Work, refreshType: number): Observable<Work> {
    if (refreshType >= 2 || (refreshType == 1 && work.lastFetchDate.getTime() < new Date().getTime() - (24 * 60 * 60 * 1000))) {
      return this.ao3.getWorkPage(work.id).pipe(map(response => this.responseToWork(work, response)));
    }

    // Only send db Work
    return new Observable(subscriber => {
      subscriber.next(work);
      subscriber.complete();
    });
  }

  private responseToWork(startObj: Work, response: HttpResponse): Work {
    let work = new WorkParser().parse(startObj, new DOMParser().parseFromString(response.data, "text/html"))
    WorkPipeline.Work2DB(this.sql, work); // Caching object
    return work;
  }

  private async DB2Work(sql:SQL, id: number): Promise<Work> {
    let work = new Work();
    work.id = id;
    try {
      const works = await sql.queryPromise(`SELECT * FROM WORK_CACHE WHERE ID = ${id}`);
      if (works.length > 0) {
        const workData = works[0];
        work.id = workData.ID;
        work.title = workData.TITLE;
        work.author = workData.AUTHOR;
        work.summary = workData.SUMMARY;
        work.ratingSymbol = workData.RATING_SYMBOL;
        work.rpoSymbol = workData.RPO_SYMBOL;
        work.warningSymbol = workData.WARNING_SYMBOL;
        work.statusSymbol = workData.STATUS_SYMBOL;
        work.rating = workData.RATING;
        work.warning = workData.WARNING;
        work.categories = workData.CATEGORIES.split("|;|");
        work.fandoms = workData.FANDOMS.split("|;|");
        work.relationships = workData.REALATIONSHIPS.split("|;|");
        work.characters = workData.CHARACTERS.split("|;|");
        work.freeforms = workData.FREEFORMS.split("|;|");
        work.language = workData.LANGUAGE_ID;
        work.publishedDate = workData.PUBLISHED_DATE != null? new Date(workData.PUBLISHED_DATE) : null;
        work.lastUpdatedDate = workData.LAST_UPDATED_DATE != null? new Date(workData.LAST_UPDATED_DATE) : null;
        work.completeDate = workData.COMPLETE_DATE != null? new Date(workData.COMPLETE_DATE) : null;
        work.chapterStats = workData.CHAPTER_STATS;
        work.words = workData.WORDS;
        work.comments = workData.COMMENTS;
        work.kudos = workData.KUDOS;
        work.bookmarks = workData.BOOKMARKS;
        work.hits = workData.HITS;
        work.lastFetchDate = workData.LAST_FETCHED_DATE != null? new Date(workData.LAST_FETCHED_DATE) : new Date(0);
        work.parserVersion = workData.PARSER_VERSION;
      }

      work.chapters = await ChapterPipeline.WorkChapters(sql, work.id);
    }
    catch (err) {
      logger.error((err as Error).message);
      logger.error((err as Error).stack+"");
      work.lastFetchDate = new Date(0);
    }
    return work;
  }

  static async Work2DB(sql:SQL, work: Work): Promise<void> {
    const check = await sql.queryPromise("SELECT * FROM WORK_CACHE WHERE id = " + work.id);
    if (check.length == 0) { // Insert
      const insertSQL =
        `INSERT INTO WORK_CACHE (ID, TITLE, AUTHOR, SUMMARY, RATING_SYMBOL,
                                 RPO_SYMBOL, WARNING_SYMBOL, STATUS_SYMBOL, RATING, WARNING,
                                 CATEGORIES, FANDOMS, REALATIONSHIPS, CHARACTERS, FREEFORMS,
                                 LANGUAGE_ID, PUBLISHED_DATE, LAST_UPDATED_DATE, COMPLETE_DATE, CHAPTER_STATS,
                                 WORDS, COMMENTS, KUDOS, BOOKMARKS, HITS,
                                 LAST_FETCHED_DATE, PARSER_VERSION)
         VALUES (?, ?, ?, ?, ?,
                 ?, ?, ?, ?, ?,
                 ?, ?, ?, ?, ?,
                 ?, ?, ?, ?, ?,
                 ?, ?, ?, ?, ?,
                 ?, ?)`;
      await sql.execute(insertSQL, [
        work.id, work.title, work.author, work.summary, work.ratingSymbol,
        work.rpoSymbol, work.warningSymbol, work.statusSymbol, work.rating, work.warning,
        work.categories.join("|;|"), work.fandoms.join("|;|"), work.relationships.join("|;|"), work.characters.join("|;|"), work.freeforms.join("|;|"),
        work.language, work.publishedDate, work.lastUpdatedDate, work.completeDate, work.chapterStats,
        work.words, work.comments, work.kudos, work.bookmarks, work.hits,
        work.lastFetchDate, work.parserVersion
      ])
    }
    else { // Update
      const updateSQL =
        `UPDATE WORK_CACHE SET TITLE = ?, AUTHOR = ?, SUMMARY = ?, RATING_SYMBOL = ?,
                               RPO_SYMBOL = ?, WARNING_SYMBOL = ?, STATUS_SYMBOL = ?, RATING = ?, WARNING = ?,
                               CATEGORIES = ?, FANDOMS = ?, REALATIONSHIPS = ?, CHARACTERS = ?, FREEFORMS = ?,
                               LANGUAGE_ID = ?, PUBLISHED_DATE = ?, LAST_UPDATED_DATE = ?, COMPLETE_DATE = ?, CHAPTER_STATS = ?,
                               WORDS = ?, COMMENTS = ?, KUDOS = ?, BOOKMARKS = ?, HITS = ?,
                               LAST_FETCHED_DATE = ?, PARSER_VERSION = ?
         WHERE ID = `;
      await sql.execute(updateSQL+work.id, [
        work.title, work.author, work.summary, work.ratingSymbol,
        work.rpoSymbol, work.warningSymbol, work.statusSymbol, work.rating, work.warning,
        work.categories.join("|;|"), work.fandoms.join("|;|"), work.relationships.join("|;|"), work.characters.join("|;|"), work.freeforms.join("|;|"),
        work.language, work.publishedDate, work.lastUpdatedDate, work.completeDate, work.chapterStats,
        work.words, work.comments, work.kudos, work.bookmarks, work.hits,
        work.lastFetchDate, work.parserVersion
      ])
    }

    // Cache chapters
    if (work.chapters != null) {
      for (let chapter of work.chapters) {
        ChapterPipeline.Chapter2DB(sql, chapter)
      }
    }
  }
}
