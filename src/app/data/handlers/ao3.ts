import { Injectable } from '@angular/core';
import {Observable} from 'rxjs';
import {Http} from './http';
import {WorkFilter} from '../models/filters/work-filter';

@Injectable({
  providedIn: 'root'
})
export class AO3 {

  constructor() { }

  private _baseUrl = 'https://archiveofourown.org/';



  // Actual API calls go here
  getSearchPage(filter: WorkFilter, page: number = 1): Observable<any> {
    const url = this._baseUrl + 'works/search';
    let filterParams = filter.paramMap();
    filterParams.page = page.toString();
    const options = {url, params: filterParams}
    return Http.instance.get(options);
  }

  getWorkPage(id: number): Observable<any> {
    const url = this._baseUrl + 'works/' + id;
    const params = {"view_adult": "true"}
    const options = {url, params}
    return Http.instance.get(options);
  }

  getChapterPage(workId: number, chapterId: number): Observable<any> {
    let url;
    if (chapterId > 0) url = this._baseUrl + 'works/' + workId + '/chapters/' + chapterId;
    else url = this._baseUrl + 'works/' + workId;
    const params = {"view_adult": "true"}
    const options = {url, params}
    return Http.instance.get(options);
  }

}
