import {Work} from '../models/work';
import {Parser, ParserBase} from '../models/parser';
import {logger} from '../handlers/logger';

export class WorkParser extends ParserBase implements Parser {
  version = 1;
  parse(dom: Document): Work {
    let work = new Work();
    work.lastFetchDate = new Date();
    work.parserVersion = this.version;



    //// Basic info

    // Set ID
    this.ifClassExists(dom.body, "share", (list) => {
      const share = (list[0] as HTMLLIElement).children[0] as HTMLAnchorElement;
      work.id = Number(share.href.substring(share.href.indexOf("works/")+6, share.href.length - 6));
    })
    // Set Title
    this.ifClassExists(dom.body, "title heading", (list) => {
      work.title = (list[0] as HTMLHeadingElement).innerText.trim();
    })
    // Set Author
    this.ifClassExists(dom.body, "byline heading", (list) => {
      work.author = ((list[0] as HTMLHeadingElement).children[0] as HTMLAnchorElement).text.trim();
    })
    // Set Summary



    //// Tags & info

    // Set Rating
    this.ifClassExists(dom.body, "rating tags", (list) => {
      work.rating = (list[list.length-1] as HTMLDivElement).innerText.trim();
    })
    // Set Warning
    this.ifClassExists(dom.body, "warning tags", (list) => {
      work.warning = (list[list.length-1] as HTMLDivElement).innerText.trim();
    })
    // Set Categories
    // Set Fandoms
    // Set Relationships
    // Set Characters
    // Set Additional Tags
    // Set Language
    this.ifClassExists(dom.body, "language", (list) => {
      work.language = (list[list.length-1] as HTMLDivElement).innerText.trim();
    })



    //// Stats

    this.ifClassExists(dom.body, "stats", (list) => {
      const stats = list[list.length-1] as HTMLDivElement;

      // Set Published Date
      // Set Last Updated Date
      // Set Complete Date
      // Set Chapter Stats
      // Set Words
      this.ifClassExists(stats, "words", (list) => {
        work.words = Number((list[list.length-1] as HTMLDivElement).innerText.replaceAll(/\D/g, ""));
      })
      // Set Comments
      this.ifClassExists(stats, "comments", (list) => {
        work.comments = Number((list[list.length-1] as HTMLDivElement).innerText.replaceAll(/\D/g, ""));
      })
      // Set Kudos
      this.ifClassExists(stats, "kudos", (list) => {
        work.kudos = Number((list[list.length-1] as HTMLDivElement).innerText.replaceAll(/\D/g, ""));
      })
      // Set Bookmarks
      // Set Hits
      this.ifClassExists(stats, "hits", (list) => {
        work.hits = Number((list[list.length-1] as HTMLDivElement).innerText.replaceAll(/\D/g, ""));
      })
    })



    //// Chapter(s) setup




    //// Send to db for cache



    logger.info(JSON.stringify(work))
    return work;
  }
}
