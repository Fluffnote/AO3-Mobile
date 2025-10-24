import { HttpParams } from "@angular/common/http";
import {
  CompletionStatusOptions,
  CrossoversOptions,
  LanguageOptions,
  SortColumnOptions,
  SortDirectionOptions
} from './search-options.enum';

export class WorkFilter {

  // Work Info
  query: string = "";
  title: string = "";
  creators: string = "";
  revisedAt: string = "";
  complete: CompletionStatusOptions = "";
  crossover: CrossoversOptions = "";
  singleChapter: boolean = false;
  wordCount: string = "";
  languageId: LanguageOptions = "";

  // Work Tags
  ratingIds: string = "";
  fandomNames: string[] = [];
  relationshipNames: string[] = [];
  characterNames: string[] = [];
  archiveWarningIds: string[] = [];
  categoryIds: string[] = [];
  freeformNames: string[] = [];

  // Work Stats
  hits: string = "";
  kudosCount: string = "";
  commentsCount: string = "";
  bookmarksCount: string = "";

  // Search
  sortColumn: SortColumnOptions = "_score";
  sortDirection: SortDirectionOptions = "desc";

  paramMap() {
    let params =  {
      // Work Info
      "work_search[query]": this.query,
      "work_search[title]": this.title,
      "work_search[creators]": this.creators,
      "work_search[revised_at]": this.revisedAt,
      "work_search[complete]": this.complete,
      "work_search[crossover]": this.crossover,
      "work_search[single_chapter]": this.singleChapter?'1':'0',
      "work_search[word_count]": this.wordCount,
      "work_search[language_id]": this.languageId,

      // Work Tags
      "work_search[rating_ids]": this.ratingIds,
      "work_search[fandom_names]": this.fandomNames.join(","),
      "work_search[relationship_names]": this.relationshipNames.join(","),
      "work_search[character_names]": this.characterNames.join(","),
      "work_search[archive_warning_ids]": this.archiveWarningIds.join(","),
      "work_search[category_ids]": this.categoryIds.join(","),
      "work_search[freeform_names]": this.freeformNames.join(","),

      // Work Stats
      "work_search[hits]": this.hits,
      "work_search[kudos_count]": this.kudosCount,
      "work_search[comments_count]": this.commentsCount,
      "work_search[bookmarks_count]": this.bookmarksCount,

      // Search
      "work_search[sort_column]": this.sortColumn,
      "work_search[sort_direction]": this.sortDirection,
      "commit": "Search",
      "page":"1"
    };

    return params;
  }

}
