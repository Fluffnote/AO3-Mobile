import {createObservable} from './create-observable';
import {CapacitorHttp, HttpOptions} from '@capacitor/core';
import {HttpObservable} from './http-observable.interface';

export class Http {
  private constructor() { }

  // Singleton setup
  static #instance: Http;
  public static get instance(): Http {
    if (!Http.#instance) Http.#instance = new Http();
    return Http.#instance;
  }
  // Singleton setup



  request<T = any>(config: HttpOptions): HttpObservable {
    return createObservable(CapacitorHttp.request, config);
  }

  get<T = any>(config: HttpOptions): HttpObservable {
    return createObservable<T>(CapacitorHttp.get, config);
  }

  post<T = any>(config: HttpOptions): HttpObservable {
    return createObservable<T>(CapacitorHttp.post, config);
  }

  put<T = any>(config: HttpOptions): HttpObservable {
    return createObservable<T>(CapacitorHttp.put, config);
  }

  patch<T = any>(config: HttpOptions): HttpObservable {
    return createObservable<T>(CapacitorHttp.patch, config);
  }

  delete<T = any>(config: HttpOptions): HttpObservable {
    return createObservable<T>(CapacitorHttp.delete, config);
  }

}
