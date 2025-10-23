import { Injectable } from '@angular/core';
import {Observable} from 'rxjs';
import {Http} from './http/http';



// export function loggingInterceptor(req: HttpRequest<unknown>, next: HttpHandlerFn): Observable<HttpEvent<unknown>> {
//   return next(req).pipe(tap(event => {
//     console.log(req);
//     if (event.type === HttpEventType.Response || event.type === HttpEventType.ResponseHeader) {
//       console.log(req.url, 'returned a response with status', event.status);
//     }
//   }));
// }

@Injectable({
  providedIn: 'root'
})
export class AO3 {

  constructor() { }

  private _baseUrl = 'https://archiveofourown.org/';



  // Actual API calls go here
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
