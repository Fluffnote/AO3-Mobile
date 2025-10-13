export class Chapter {

  // Basic info
  id: number = 0;
  workId: number = 0;
  nextId: number = 0;
  order: number = 1;

  // Main info
  chapterHeader: string = "";
  summary: string = "";
  notes: string[] = [];
  body: string = "";

  // Extra
  lastFetchDate: Date = new Date();
  parserVersion: string = "";

}
