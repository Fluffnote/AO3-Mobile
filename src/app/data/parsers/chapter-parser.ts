import {Parser, ParserBase} from './parser';
import {Chapter} from '../models/chapter';
import {logger} from '../handlers/logger';

export class ChapterParser extends ParserBase implements Parser {
  version = 1;
  parse(startObj: Chapter, dom: Document): Chapter {
    let chapter = startObj;
    chapter.lastFetchDate = new Date();
    chapter.parserVersion = this.version;



    //// Basic info

    // Set ID
    this.ifClassExists(dom.body, "chapter preface group", (list) => {
      const chapterLink = (list[0] as HTMLDivElement).children[0].children[0] as HTMLAnchorElement;
      chapter.id = Number(chapterLink.href.substring(chapterLink.href.indexOf("chapters/")+9));
    })
    // Set Work ID
    this.ifClassExists(dom.body, "share", (list) => {
      const share = (list[0] as HTMLLIElement).children[0] as HTMLAnchorElement;
      chapter.workId = Number(share.href.substring(share.href.indexOf("works/")+6, share.href.length - 6));
    })
    // Set Next ID
    this.ifClassExists(dom.body, "chapter next", (list) => {
      const next = (list[0] as HTMLLIElement).children[0] as HTMLAnchorElement;
      chapter.nextId = Number(next.href.substring(next.href.indexOf("chapters/")+9, next.href.indexOf("#")));
    })



    //// Main info

    // Set Chapter Header
    this.ifClassExists(dom.body, "chapter preface group", (list) => {
      const chapterTitle = (list[0] as HTMLDivElement).children[0] as HTMLHeadingElement;
      chapter.chapterHeader = chapterTitle.innerText.trim()
    })
    // Set Summary
    this.ifClassExists(dom.body, "summary module", (list) => {
      const summary = list[0] as HTMLDivElement;
      chapter.summary = (summary.children[summary.children.length -1] as HTMLDivElement).innerHTML.trim();
    })
    // Set Notes
    this.ifClassExists(dom.body, "notes module", (list) => {
      chapter.notes = [];
      chapter.endNotes = [];
      for (let i = 0; i < list.length; i++) {
        const notes = list[i] as HTMLDivElement;
        if (notes.classList.contains("end")) { // End Notes
          chapter.endNotes.push((notes.children[notes.children.length - 1] as HTMLElement).getHTML().trim())
        }
        else { // Start Notes
          chapter.notes.push((notes.children[notes.children.length - 1] as HTMLElement).getHTML().trim())
        }
      }
    })
    // Set Body
    this.ifClassExists(dom.body, "userstuff module", (list) => {
      const body = list[0] as HTMLDivElement;
      chapter.body = body.innerHTML.replace(/<h3 class="landmark heading" id="work">.*<\/h3>/g,"").trim()
    })

    if (chapter.body.length == 0) {
      if (dom.getElementById("chapters") != null) {
        const chaps = dom.getElementById("chapters") as HTMLDivElement;

        this.ifClassExists(chaps, "userstuff", (list) => {
          const body = list[0] as HTMLDivElement;
          chapter.body = body.innerHTML.replace(/<h3 class="landmark heading" id="work">.*<\/h3>/g,"").trim()
        })
      }
    }



    // logger.info(JSON.stringify(chapter))
    return chapter;
  }
}
