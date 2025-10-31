import {ContentRating, ContentWarning, RPO, Status} from './ao3-symbols.enum';
import {Chapter} from './chapter';

export class Work {

  // Basic info
  id: number = 0;
  title: string = "";
  author: string = "";
  summary: string = "";

  chapters: Chapter[] = [];

  // Info symbols
  ratingSymbol: ContentRating = ContentRating.None;
  rpoSymbol: RPO = RPO.None;
  warningSymbol: ContentWarning = ContentWarning.None;
  statusSymbol: Status = Status.Unknown;

  // Tags & info
  rating: string = "";
  warning: string = "";
  categories: string[] = [];
  fandoms: string[] = [];
  relationships: string[] = [];
  characters: string[] = [];
  freeforms: string[] = [];
  language: string = "";

  // Stats
  publishedDate: Date | null = null;
  lastUpdatedDate: Date | null = null;
  completeDate: Date | null = null;
  chapterStats: string = "";
  words: number = 0;
  comments: number = 0;
  kudos: number = 0;
  bookmarks: number = 0;
  hits: number = 0;

  // Extra
  lastFetchDate: Date = new Date(0);
  parserVersion: number = -1;

}
