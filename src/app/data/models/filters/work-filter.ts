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

}
