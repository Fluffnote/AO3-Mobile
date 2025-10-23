export class Chapter {

  // Basic info
  id: number = 0;
  workId: number = 0;
  nextId: number = 0;
  order: number = 1;

  // Main info
  chapterListHeader: string = "";
  chapterHeader: string = "";
  summary: string = "";
  notes: string[] = [];
  endNotes: string[] = [];
  body: string = "";

  // Extra
  lastFetchDate: Date = new Date(0);
  parserVersion: number = -1;

}
