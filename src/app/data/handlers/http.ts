import {CapacitorHttp, HttpOptions, HttpResponse} from '@capacitor/core';
import {logger} from './logger';
import {Observable, tap} from 'rxjs';
import {createObservable} from './create-observable';

export class Http {
  private constructor() { }

  // Singleton setup
  static #instance: Http;
  public static get instance(): Http {
    if (!Http.#instance) Http.#instance = new Http();
    return Http.#instance;
  }
  // Singleton setup



  loggingInterceptor(res: HttpResponse) {
    if (res.status === 200) {
      logger.info("status: " + res.status + " - " + res.data.length + " bytes" + " - "+ res.url);
    }
    else {
      logger.error(JSON.stringify(res))
    }
  }



  request(config: HttpOptions): Observable<HttpResponse> {
    return createObservable<HttpResponse>(CapacitorHttp.request, config).pipe(tap(res => {this.loggingInterceptor(res)}));
  }

  get(config: HttpOptions): Observable<HttpResponse> {
    return createObservable<HttpResponse>(CapacitorHttp.get, config).pipe(tap(res => {this.loggingInterceptor(res)}));
  }

  post(config: HttpOptions): Observable<HttpResponse> {
    return createObservable<HttpResponse>(CapacitorHttp.post, config).pipe(tap(res => {this.loggingInterceptor(res)}));
  }

  put(config: HttpOptions): Observable<HttpResponse> {
    return createObservable<HttpResponse>(CapacitorHttp.put, config).pipe(tap(res => {this.loggingInterceptor(res)}));
  }

  patch(config: HttpOptions): Observable<HttpResponse> {
    return createObservable<HttpResponse>(CapacitorHttp.patch, config).pipe(tap(res => {this.loggingInterceptor(res)}));
  }

  delete(config: HttpOptions): Observable<HttpResponse> {
    return createObservable<HttpResponse>(CapacitorHttp.delete, config).pipe(tap(res => {this.loggingInterceptor(res)}));
  }

}
