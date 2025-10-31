import {Work} from '../models/work';
import {Parser, ParserBase} from './parser';
import {logger} from '../handlers/logger';
import {Chapter} from '../models/chapter';
import {ContentRating, ContentWarning, RPO, Status} from '../models/ao3-symbols.enum';

export class WorkParser extends ParserBase implements Parser {
  version = 1;
  parse(startObj: Work, dom: Document): Work {
    let work = startObj
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
        work.freeforms.push((ul.children[i] as HTMLLIElement).innerText.trim());
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
    if (dom.getElementById("selected_id") != null) { // Multi chapter
      const list = dom.getElementById("selected_id") as HTMLSelectElement;

      for (let i = 0; i < list.length; i++) {
        let chap = new Chapter()
        chap.id = Number(list.item(i)!.value)
        chap.workId = work.id
        chap.chapterListHeader = list.item(i)!.text
        chap.order = i + 1
        work.chapters.push(chap)
      }
    }
    else { // One-shot
      let chap = new Chapter()
      chap.id = 0
      chap.workId = work.id
      chap.chapterListHeader = work.title
      chap.order = 1
      work.chapters.push(chap)
    }



    return work;
  }
}





export class WorkSearchParser extends ParserBase implements Parser {
  version = 1;
  parse(part: HTMLElement): Work {
    let work = new Work();
    work.parserVersion = this.version;



    //// Basic info

    // Set ID
    work.id = Number(part.id.substring(part.id.indexOf("work_")+5));
    // Set Title
    this.ifClassExists(part, "header module", (list) => {
      let header = ((list[0] as HTMLDivElement).children[0] as HTMLHeadingElement).innerText.trim();
      header = header.replace(/[\n\r]/g, "").replace(/[\s\t\n\r]*by[\s\t\n\r]*/g, " by ");
      work.title = header.substring(0, header.indexOf(" by "));
      work.author = header.substring(header.indexOf(" by ")+4);
    })
    // Set Summary
    this.ifClassExists(part, "userstuff summary", (list) => {
      work.summary = (list[0] as HTMLDivElement).innerHTML.trim();
    })



    //// Tags & info

    // Set Symbols
    this.ifClassExists(part, "required-tags", (list) => {
      const tags = list[0] as HTMLUListElement;

      // Set Rating Symbol
      this.ifClassExists(tags, "rating", (list) => {
        const rating = (list[0] as HTMLSpanElement).innerText.trim();
        if (rating == "Not Rated") work.ratingSymbol = ContentRating.None;
        if (rating == "General Audiences") work.ratingSymbol = ContentRating.General;
        if (rating == "Teen And Up Audiences") work.ratingSymbol = ContentRating.Teen;
        if (rating == "Mature") work.ratingSymbol = ContentRating.Mature;
        if (rating == "Explicit") work.ratingSymbol = ContentRating.Explicit;
      })
      // Set RPO Symbol
      this.ifClassExists(tags, "category", (list) => {
        const rpo = (list[0] as HTMLSpanElement).innerText.trim();
        if (rpo.includes("No category")) work.rpoSymbol = RPO.None;
        if (rpo.includes("F/F")) work.rpoSymbol = RPO.FF;
        if (rpo.includes("M/M")) work.rpoSymbol = RPO.MM;
        if (rpo.includes("F/M")) work.rpoSymbol = RPO.FM;
        if (rpo.includes("Gen")) work.rpoSymbol = RPO.Gen;
        if (rpo.includes("Other")) work.rpoSymbol = RPO.Other;
        if (rpo.includes("Multi")) work.rpoSymbol = RPO.Multi;
      })
      // Set Warning Symbol
      this.ifClassExists(tags, "warnings", (list) => {
        const warning = (list[0] as HTMLSpanElement).innerText.trim();
        if (warning.includes("No Archive Warnings Apply")) work.warningSymbol = ContentWarning.None;
        if (warning.includes("Choose Not To Use Archive Warnings")) work.warningSymbol = ContentWarning.Unspecified;
        if (warning.includes("External")) work.warningSymbol = ContentWarning.External;
        if (warning.includes("Graphic Depictions Of Violence")) work.warningSymbol = ContentWarning.Explicit;
        if (warning.includes("Major Character Death")) work.warningSymbol = ContentWarning.Explicit;
        if (warning.includes("Rape/Non-Con")) work.warningSymbol = ContentWarning.Explicit;
        if (warning.includes("Underage Sex")) work.warningSymbol = ContentWarning.Explicit;
      })
      // Set Status Symbol
      this.ifClassExists(tags, "iswip", (list) => {
        const status = (list[0] as HTMLSpanElement).innerText.trim();
        if (status.includes("Work in Progress")) work.statusSymbol = Status.InProgress;
        if (status.includes("Complete Work")) work.statusSymbol = Status.Completed;
      })
    })

    // Set Fandoms
    this.ifClassExists(part, "fandoms heading", (list) => {
      const header = list[0] as HTMLHeadingElement;
      for (let i = 0; i < header.children.length; i++) {
        if (i == 0) continue;
        work.fandoms.push((header.children[i] as HTMLElement).innerText.trim());
      }
    })
    // Set Additional Tags
    this.ifClassExists(part, "tags commas", (list) => {
      const ul = list[0] as HTMLUListElement;

      // Set Warning Tag
      this.ifClassExists(ul, "warnings", (list) => {
        work.warning = (list[0] as HTMLLIElement).innerText.trim();
      })
      // Set Relationship Tags
      this.ifClassExists(ul, "relationships", (list) => {
        for (let i = 0; i < list.length; i++) {
          work.relationships.push((list[i] as HTMLLIElement).innerText.trim());
        }
      })
      // Set Character Tags
      this.ifClassExists(ul, "characters", (list) => {
        for (let i = 0; i < list.length; i++) {
          work.characters.push((list[i] as HTMLLIElement).innerText.trim());
        }
      })
      // Set Freeform Tags
      this.ifClassExists(ul, "freeforms", (list) => {
        for (let i = 0; i < list.length; i++) {
          work.freeforms.push((list[i] as HTMLLIElement).innerText.trim());
        }
      })
    })
    // Set Last Updated Date
    this.ifClassExists(part, "datetime", (list) => {
      work.lastUpdatedDate = new Date((list[0] as HTMLParagraphElement).innerText.trim());
    })



    //// Stats

    this.ifClassExists(part, "stats", (list) => {
      const stats = list[list.length-1] as HTMLDivElement;

      // Set Language
      this.ifClassExists(stats, "language", (list) => {
        work.language = (list[list.length-1] as HTMLDivElement).innerText.trim();
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




    //// Send to db for cache



    return work;
  }
}
