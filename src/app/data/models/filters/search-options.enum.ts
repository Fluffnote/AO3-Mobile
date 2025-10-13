const completionStatusMap = new Map<string, string>([
  ["", "All works"],
  ["T", "Complete works only"],
  ["F", "Works in progress only"],
]);

const crossoversMap = new Map<string, string>([
  ["", "Include crossovers"],
  ["F", "Exclude crossovers"],
  ["T", "Only crossovers"],
]);

const languageMap = new Map<string, string>([
  ["", "Any"],
]);

const sortColumnMap = new Map<string, string>([
  ["_score","Best Match"],
  ["authors_to_sort_on","Author"],
  ["title_to_sort_on","Title"],
  ["created_at","Date Posted"],
  ["revised_at","Date Updated"],
  ["word_count","Word Count"],
  ["hits","Hits"],
  ["kudos_count","Kudos"],
  ["comments_count","Comments"],
  ["bookmarks_count","Bookmarks"],
]);

const sortDirectionMap = new Map<string, string>([
  ["asc","Ascending"],
  ["desc","Descending"],
]);



export type CompletionStatusOptions = "" | "T" | "F";
export type CrossoversOptions = "" | "T" | "F";
export type LanguageOptions = "";
export type SortColumnOptions = "_score" | "authors_to_sort_on" | "title_to_sort_on" | "created_at" | "revised_at" | "word_count" | "hits" | "kudos_count" | "comments_count" | "bookmarks_count";
export type SortDirectionOptions = "asc" | "desc";

export { completionStatusMap, crossoversMap, languageMap, sortColumnMap, sortDirectionMap };
