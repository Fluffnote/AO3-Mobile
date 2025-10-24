import {logger} from '../handlers/logger';

export interface Parser {
  version: number;
  parse(dom: Document | HTMLElement): any;
}

export class ParserBase {
  ifClassExists(elem: HTMLElement, className: string, fn: (elemList: HTMLCollectionOf<Element>) => void): void {
    if (elem.getElementsByClassName(className).length > 0) {
      try {
        fn(elem.getElementsByClassName(className));
      }
      catch (e) {
        logger.error((e as Error).message);
        logger.error((e as Error).stack+"");
      }
    }
  }
}
