import {HttpObservable} from './http-observable.interface';
import {HttpOptions, HttpResponse} from '@capacitor/core';
import {Observable} from 'rxjs';

export function createObservable<T>(promiseFactory: (...args: any[]) => Promise<HttpResponse>, ...args: any[]): HttpObservable {
  let options: HttpOptions = args[args.length - 1];
  options = options ? {...options} : {url: args[0]};
  args[args.length - 1] = options;

  // let abortController: AbortController;
  // const hasCancelToken: boolean = !!options.cancelToken;
  // const hasSignal: boolean = !!options.signal;
  // if (hasCancelToken) {
  //   console.warn(`No need to use cancel token, just unsubscribe the subscription would cancel the http request automatically`);
  // }
  // if (hasSignal) {
  //   console.warn(`No need to use cancel token, just unsubscribe the subscription would cancel the http request automatically`);
  // }

  const observable: HttpObservable = new Observable((subscriber: any) => {

    // if (!hasSignal) {
    //   abortController = new AbortController();
    //   config.signal = abortController.signal;
    // }

    promiseFactory(...args).then(response => {
      subscriber.next(response);
      subscriber.complete();
    })
      .catch(error => subscriber.error(error));
  });

  const _subscribe = observable.subscribe.bind(observable);

  observable.subscribe = (...args2: any[]) => {

    const subscription = _subscribe(...args2);

    const _unsubscribe = subscription.unsubscribe.bind(subscription);

    subscription.unsubscribe = () => {
      // if (abortController) {
      //   abortController.abort();
      // }
      _unsubscribe();
    };
    return subscription;
  };

  return observable;

}
