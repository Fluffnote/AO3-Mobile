import { Injectable } from '@angular/core';
import {
  HttpClient,
  HttpErrorResponse,
  HttpEvent,
  HttpEventType,
  HttpHandlerFn,
  HttpRequest
} from '@angular/common/http';
import {catchError, Observable, tap, throwError} from 'rxjs';



export function loggingInterceptor(req: HttpRequest<unknown>, next: HttpHandlerFn): Observable<HttpEvent<unknown>> {
  return next(req).pipe(tap(event => {
    if (event.type === HttpEventType.Response) {
      console.log(req.url, 'returned a response with status', event.status);
      console.log(event);
    }
  }));
}

@Injectable({
  providedIn: 'root'
})
export class AO3 {

  constructor(private http: HttpClient) { }

  private _baseUrl = 'https://archiveofourown.org/';

  private getData(url: string, options: any) {
    return this.http.get(url, options).pipe(catchError(this.handleError));
  }

  private handleError(err: HttpErrorResponse) {
    console.log(err);
    return throwError(() => new Error(err.error.message || 'Server error'));
  }


  // Actual API calls go here
  getWorkPage(id: number): Observable<any> {
    const url = this._baseUrl + 'works/' + id;
    const params = {view_adult: true}
    const options = {mode: 'no-cors', headers: {}, params: params};
    return this.getData(url, options);
  }

}
