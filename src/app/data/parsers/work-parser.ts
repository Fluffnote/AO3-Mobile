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
    this.ifClassExists(dom.body, "summary module", (list) => {
      const summary = list[0] as HTMLDivElement;
      work.summary = (summary.children[summary.children.length -1] as HTMLDivElement).innerHTML.trim();
    })



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
    this.ifClassExists(dom.body, "category tags", (list) => {
      const ul = (list[list.length-1] as HTMLDivElement).children[0] as HTMLUListElement;
      for (let i = 0; i < ul.children.length; i++) {
        work.categories.push((ul.children[i] as HTMLLIElement).innerText.trim());
      }
    })
    // Set Fandoms
    this.ifClassExists(dom.body, "fandom tags", (list) => {
      const ul = (list[list.length-1] as HTMLDivElement).children[0] as HTMLUListElement;
      for (let i = 0; i < ul.children.length; i++) {
        work.fandoms.push((ul.children[i] as HTMLLIElement).innerText.trim());
      }
    })
    // Set Relationships
    this.ifClassExists(dom.body, "relationship tags", (list) => {
      const ul = (list[list.length-1] as HTMLDivElement).children[0] as HTMLUListElement;
      for (let i = 0; i < ul.children.length; i++) {
        work.relationships.push((ul.children[i] as HTMLLIElement).innerText.trim());
      }
    })
    // Set Characters
    this.ifClassExists(dom.body, "character tags", (list) => {
      const ul = (list[list.length-1] as HTMLDivElement).children[0] as HTMLUListElement;
      for (let i = 0; i < ul.children.length; i++) {
        work.characters.push((ul.children[i] as HTMLLIElement).innerText.trim());
      }
    })
    // Set Additional Tags
    this.ifClassExists(dom.body, "freeform tags", (list) => {
      const ul = (list[list.length-1] as HTMLDivElement).children[0] as HTMLUListElement;
      for (let i = 0; i < ul.children.length; i++) {
        work.addTags.push((ul.children[i] as HTMLLIElement).innerText.trim());
      }
    })
    // Set Language
    this.ifClassExists(dom.body, "language", (list) => {
      work.language = (list[list.length-1] as HTMLDivElement).innerText.trim();
    })



    //// Stats

    this.ifClassExists(dom.body, "stats", (list) => {
      const stats = list[list.length-1] as HTMLDivElement;

      // Set Published Date
      this.ifClassExists(stats, "published", (list) => {
        work.publishedDate = new Date((list[list.length-1] as HTMLDivElement).innerText.trim());
      })
      // Set Status
      this.ifClassExists(stats, "status", (list) => {
        // Set Last Updated Date
        work.lastUpdatedDate = new Date((list[list.length-1] as HTMLDivElement).innerText.trim());
        // Set Complete Date
        if ((list[0] as HTMLDivElement).innerText.includes("Completed")) {
          work.completeDate = new Date((list[list.length-1] as HTMLDivElement).innerText.trim());
        }
      })
      // Set Chapter Stats
      this.ifClassExists(stats, "chapters", (list) => {
        work.chapterStats = (list[list.length-1] as HTMLDivElement).innerText.trim();
      })
      // Set Words
      this.ifClassExists(stats, "words", (list) => {
        work.words = Number((list[list.length-1] as HTMLDivElement).innerText.replace(/\D/g, ""));
      })
      // Set Comments
      this.ifClassExists(stats, "comments", (list) => {
        work.comments = Number((list[list.length-1] as HTMLDivElement).innerText.replace(/\D/g, ""));
      })
      // Set Kudos
      this.ifClassExists(stats, "kudos", (list) => {
        work.kudos = Number((list[list.length-1] as HTMLDivElement).innerText.replace(/\D/g, ""));
      })
      // Set Bookmarks
      this.ifClassExists(stats, "bookmarks", (list) => {
        work.bookmarks = Number((list[list.length-1] as HTMLDivElement).innerText.replace(/\D/g, ""));
      })
      // Set Hits
      this.ifClassExists(stats, "hits", (list) => {
        work.hits = Number((list[list.length-1] as HTMLDivElement).innerText.replace(/\D/g, ""));
      })
    })



    //// Chapter(s) setup




    //// Send to db for cache



    // logger.info(JSON.stringify(work))
    return work;
  }
}
