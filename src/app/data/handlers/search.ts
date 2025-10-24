import { Injectable } from '@angular/core';
import {AO3} from './ao3';
import {Subject} from 'rxjs';
import {WorkFilter} from '../models/filters/work-filter';
import {Work} from '../models/work';
import {SearchParser} from '../parsers/search-parser';

@Injectable({
  providedIn: 'root'
})
export class Search {

  constructor(private ao3: AO3) { }

  filter: Subject<WorkFilter> = new Subject<WorkFilter>()
  amountFound: Subject<number> = new Subject<number>()
  searchResults: Subject<Work[]> = new Subject<Work[]>()

  _filter: WorkFilter = new WorkFilter();
  _amountFound: number = 0;
  _searchResults: Work[] = [];
  page: number = 1;

  searchParser: SearchParser = new SearchParser()

  searchText(query: string) {
    this._filter = new WorkFilter();
    this._filter.query = query;
    this.filter.next(this._filter);
    this.page = 1;
    this.ao3.getSearchPage(this._filter, this.page).subscribe(data => {
      let searchResponse = this.searchParser.parse(new DOMParser().parseFromString(data.data, "text/html"));
      this._amountFound = searchResponse.amountFound;
      this.amountFound.next(this._amountFound);
      this._searchResults = searchResponse.works;
      this.searchResults.next(this._searchResults);
    })

  }

  searchNext() {

  }

}
