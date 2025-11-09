import {Component, ElementRef, OnDestroy, OnInit, ViewChild} from '@angular/core';
import {ActivatedRoute, RouterLink} from '@angular/router';
import {AO3} from '../../data/handlers/ao3';
import {RefresherCustomEvent} from '@ionic/angular';
import {Browser} from '@capacitor/browser';
import {Chapter} from '../../data/models/chapter';
import {DropDownHTMLComponent} from '../../UI/drop-down-html/drop-down-html.component';
import {
  IonBackButton,
  IonButton,
  IonButtons,
  IonContent,
  IonHeader, IonIcon, IonRefresher, IonRefresherContent, IonSpinner, IonTitle, IonToolbar
} from '@ionic/angular/standalone';
import {ChapterParser} from '../../data/parsers/chapter-parser';
import {logger} from '../../data/handlers/logger';
import {ElementLoadDirective} from '../../UI/element-load.dir';
import {History} from '../../data/models/history';
import {ChapterPipeline} from '../../data/handlers/class/chapter-pipeline';
import {HistoryMgmt} from '../../data/handlers/history-mgmt';
import {HideHeaderDirective} from '../../UI/hide-header.dir';

@Component({
  selector: 'views-chapter-view',
  templateUrl: './chapter-view.component.html',
  styleUrls: ['./chapter-view.component.less'],
  imports: [
    DropDownHTMLComponent,
    IonBackButton,
    IonButton,
    IonButtons,
    IonContent,
    IonHeader,
    IonIcon,
    IonRefresher,
    IonRefresherContent,
    IonSpinner,
    IonTitle,
    IonToolbar,
    ElementLoadDirective,
    RouterLink,
    HideHeaderDirective
  ]
})
export class ChapterViewComponent  implements OnInit, OnDestroy {

  constructor(
    private route: ActivatedRoute,
    private chapterPipe: ChapterPipeline,
    private historyMgmt: HistoryMgmt
  ) { }

  @ViewChild("Content") content!: IonContent;

  chapterParser = new ChapterParser();
  workId: string | null = null;
  chapterId: string | null = null;
  chapter: Chapter | null = null;

  history: History | null = null;

  // Scroll vars
  maxHeight: number = 0;
  savedScrollPos: number = 0;
  scrollDiff: number = 100;

  ngOnInit() {
    this.route.paramMap.subscribe(params => {
      this.workId = params.get('workId');
      this.chapterId = params.get('chapterId');
      this.grabChapter();
    })
  }

  ngOnDestroy() {
    this.historyMgmt.updateHistoryList();
  }

  grabChapter() {
    if (this.workId != null && this.chapterId != null) {
      this.chapterPipe.get(Number(this.workId), Number(this.chapterId), 1).subscribe(chapter => {
        this.chapter = chapter

        this.historyMgmt.get(Number(this.workId), Number(this.chapterId)).subscribe(history => {
          this.history = history;
          history.chapterHeader = JSON.parse(JSON.stringify(this.chapter!.chapterHeader));
        })
      });
    }
  }

  handleRefresh(event: RefresherCustomEvent) {
    if (this.workId != null && this.chapterId != null) this.chapterPipe.get(Number(this.workId), Number(this.chapterId), 2).subscribe(chapter => {
      this.chapter = chapter;
      this.maxHeight = ((document.getElementById("InnerContent")!.offsetHeight) - (document.getElementById("OuterContent")!.offsetHeight));
      if (this.history != null) {
        this.history.scrollMax = this.maxHeight;
        this.historyMgmt.update(this.history!);
      }
      event.target.complete();
    });
  }

  openWebPage() {
    Browser.open({ url: "https://archiveofourown.org/works/"+this.workId });
  }

  bodyLoad() {
    if (this.chapter != null && this.history != null && this.history.scrollPosition >= 100) { // Resume reading position
      this.content.scrollToPoint(0, this.history.scrollPosition, 100);
    }
    this.maxHeight = ((document.getElementById("InnerContent")!.offsetHeight) - (document.getElementById("OuterContent")!.offsetHeight));
    if (this.history != null) {
      this.history.scrollMax = this.maxHeight;
      this.historyMgmt.update(this.history!);
    }
  }

  scrollHandler(event: any) {
    if (Math.abs(event.detail.scrollTop - this.savedScrollPos) >= this.scrollDiff) {
      this.savedScrollPos = JSON.parse(JSON.stringify(event.detail.scrollTop));
      // logger.info("pos: "+Math.round((this.savedScrollPos/this.maxHeight)*100)); // Read percentage
      if (this.history != null) this.history.scrollPosition = this.savedScrollPos;
      this.historyMgmt.update(this.history!);
    }

    if (event.detail.scrollTop >= this.maxHeight) { // Reached bottom
      this.savedScrollPos = JSON.parse(JSON.stringify(this.maxHeight));
      if (this.history != null) this.history.scrollPosition = this.savedScrollPos;
      this.historyMgmt.update(this.history!);
    }
  }

  protected readonly History = History;
}
