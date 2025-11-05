import { Injectable } from '@angular/core';
import {AO3} from './ao3';
import {concatMap, map, Observable, Subject} from 'rxjs';
import {WorkFilter} from '../models/filters/work-filter';
import {Work} from '../models/work';
import {SearchParser} from '../parsers/search-parser';
import {HttpResponse} from '@capacitor/core';
import {logger} from './logger';

@Injectable({
  providedIn: 'root'
})
export class Search {

  constructor(private ao3: AO3) { }

  filter: Subject<WorkFilter> = new Subject<WorkFilter>()
  amountFound: Subject<number> = new Subject<number>()
  searchResults: Subject<Work[]> = new Subject<Work[]>()
  searchEnd: Subject<boolean> = new Subject<boolean>()

  _filter: WorkFilter = new WorkFilter();
  _amountFound: number = 0;
  _searchResults: Work[] = [];
  _searchEnd: boolean = false;
  page: number = 1;

  searchParser: SearchParser = new SearchParser()

  searchText(query: string): Observable<boolean> {
    this._filter = new WorkFilter();
    this._filter.query = query;
    this.filter.next(this._filter);
    this.page = 1;
    this._searchResults = [];
    return this.ao3.getSearchPage(this._filter, this.page).pipe(map(response => this.responseToUpdate(response)))
  }

  searchNext(): Observable<boolean> {
    if (!this._searchEnd) {
      this.page++;
      return this.ao3.getSearchPage(this._filter, this.page).pipe(map(response => this.responseToUpdate(response)))
    }
    else {
      return new Observable(subscriber => {
        subscriber.next(true);
        subscriber.complete();
      });
    }
  }

  private responseToUpdate(response: HttpResponse): boolean {
    let searchResponse = this.searchParser.parse(new DOMParser().parseFromString(response.data, "text/html"));
    this._amountFound = searchResponse.amountFound;
    this.amountFound.next(this._amountFound);
    this._searchResults.push(...searchResponse.works);
    this.searchResults.next(this._searchResults);
    this._searchEnd = (this.page * 20) >= this._amountFound;
    this.searchEnd.next(this._searchEnd);
    logger.info("Search amount displayed: "+this._searchResults.length);
    logger.info("Search end: "+this._searchEnd);
    return true;
  }

}
