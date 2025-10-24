import {Parser, ParserBase} from '../models/parser';
import {SearchResponse} from '../models/search';
import {logger} from '../handlers/logger';
import {WorkSearchParser} from './work-parser';

export class SearchParser extends ParserBase implements Parser {
  version = 1;
  workSearchParser = new WorkSearchParser();

  parse(dom: Document): SearchResponse {
    let searchResponse = new SearchResponse();


    // Get Found Amount
    if (dom.getElementById("main") != null) {
      const found = (dom.getElementById("main") as HTMLDivElement).children[4] as HTMLHeadingElement;
      searchResponse.amountFound = Number(found.innerText.replace(/\D/g, ""));
    }

    // Add Works
    this.ifClassExists(dom.body, "work index group", (list) => {
      const works = list[0] as HTMLOListElement
      for (let i = 0; i < works.children.length; i++) {
        const work = works.children[i] as HTMLLIElement;
        searchResponse.works.push(this.workSearchParser.parse(work))
      }
    })



    // logger.info(JSON.stringify(searchResponse))

    return searchResponse;
  }
}
