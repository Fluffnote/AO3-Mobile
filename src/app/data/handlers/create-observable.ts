import {Observable} from 'rxjs';

export function createObservable<T>(promiseFactory: (...args: any[]) => Promise<any>, ...args: any[]): Observable<T> {

  const observable: Observable<T> = new Observable((subscriber: any) => {

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

    subscription.unsubscribe = () => { _unsubscribe(); };
    return subscription;
  };

  return observable;
}
