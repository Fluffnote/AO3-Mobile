import {Component, ElementRef, OnInit, ViewChild} from '@angular/core';
import {ActivatedRoute} from '@angular/router';
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

@Component({
  selector: 'app-chapter-view',
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
    ElementLoadDirective
  ]
})
export class ChapterViewComponent  implements OnInit {

  constructor(
    private route: ActivatedRoute,
    private ao3: AO3
  ) { }

  @ViewChild("Content") content!: IonContent;

  chapterParser = new ChapterParser();
  workId: string | null = null;
  chapterId: string | null = null;
  chapter: Chapter | null = null;

  history: History = new History();

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

  grabChapter() {
    if (this.workId != null && this.chapterId != null) this.ao3.getChapterPage(Number(this.workId), Number(this.chapterId)).subscribe(data => {
      this.chapter = this.chapterParser.parse(new DOMParser().parseFromString(data.data, "text/html"));
    });
  }

  handleRefresh(event: RefresherCustomEvent) {
    if (this.workId != null && this.chapterId != null) this.ao3.getChapterPage(Number(this.workId), Number(this.chapterId)).subscribe(data => {
      this.chapter = this.chapterParser.parse(new DOMParser().parseFromString(data.data, "text/html"));
      this.maxHeight = ((document.getElementById("InnerContent")!.offsetHeight) - (document.getElementById("OuterContent")!.offsetHeight));
      event.target.complete();
    });
  }

  openWebPage() {
    Browser.open({ url: "https://archiveofourown.org/works/"+this.workId });
  }

  bodyLoad() {
    if (this.chapter != null && this.history.scrollPosition >= 100) { // Resume reading position
      this.content.scrollToPoint(0, this.history.scrollPosition, 100);
    }
    this.maxHeight = ((document.getElementById("InnerContent")!.offsetHeight) - (document.getElementById("OuterContent")!.offsetHeight));
  }

  scrollHandler(event: any) {
    if (Math.abs(event.detail.scrollTop - this.savedScrollPos) >= this.scrollDiff) {
      this.savedScrollPos = JSON.parse(JSON.stringify(event.detail.scrollTop));
      // logger.info("pos: "+Math.round((this.savedScrollPos/this.maxHeight)*100)); // Read percentage
      this.history.scrollPosition = this.savedScrollPos;
    }

    if (event.detail.scrollTop >= this.maxHeight) { // Reached bottom
      this.savedScrollPos = JSON.parse(JSON.stringify(this.maxHeight));
      this.history.scrollPosition = this.savedScrollPos;
    }
  }

}
