import {createObservable} from './create-observable';
import {CapacitorHttp, HttpOptions, HttpResponse} from '@capacitor/core';
import {HttpObservable} from './http-observable.interface';
import {logger} from '../logger';
import {tap} from 'rxjs';

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



  request<T = any>(config: HttpOptions): HttpObservable {
    return createObservable(CapacitorHttp.request, config).pipe(tap(res => {this.loggingInterceptor(res)}));
  }

  get<T = any>(config: HttpOptions): HttpObservable {
    return createObservable<T>(CapacitorHttp.get, config).pipe(tap(res => {this.loggingInterceptor(res)}));
  }

  post<T = any>(config: HttpOptions): HttpObservable {
    return createObservable<T>(CapacitorHttp.post, config).pipe(tap(res => {this.loggingInterceptor(res)}));
  }

  put<T = any>(config: HttpOptions): HttpObservable {
    return createObservable<T>(CapacitorHttp.put, config).pipe(tap(res => {this.loggingInterceptor(res)}));
  }

  patch<T = any>(config: HttpOptions): HttpObservable {
    return createObservable<T>(CapacitorHttp.patch, config).pipe(tap(res => {this.loggingInterceptor(res)}));
  }

  delete<T = any>(config: HttpOptions): HttpObservable {
    return createObservable<T>(CapacitorHttp.delete, config).pipe(tap(res => {this.loggingInterceptor(res)}));
  }

}
