import { Component, OnInit } from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {AO3} from '../../data/handlers/ao3';
import {WorkParser} from '../../data/parsers/work-parser';
import {Work} from '../../data/models/work';
import {RefresherCustomEvent} from '@ionic/angular';
import {Browser} from '@capacitor/browser';
import {Chapter} from '../../data/models/chapter';
import {DropDownHTMLComponent} from '../../UI/drop-down-html/drop-down-html.component';
import {
  IonBackButton,
  IonButton,
  IonButtons,
  IonContent,
  IonFab,
  IonFabButton,
  IonHeader, IonIcon, IonItem, IonLabel, IonRefresher, IonRefresherContent, IonSpinner, IonTitle, IonToolbar
} from '@ionic/angular/standalone';
import {WorkViewMetadataComponent} from '../work-view/work-view-metadata/work-view-metadata.component';
import {ChapterParser} from '../../data/parsers/chapter-parser';

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
    IonFab,
    IonFabButton,
    IonHeader,
    IonIcon,
    IonItem,
    IonLabel,
    IonRefresher,
    IonRefresherContent,
    IonSpinner,
    IonTitle,
    IonToolbar,
    WorkViewMetadataComponent
  ]
})
export class ChapterViewComponent  implements OnInit {

  constructor(
    private route: ActivatedRoute,
    private ao3: AO3
  ) { }

  chapterParser = new ChapterParser();
  workId: string | null = null;
  chapterId: string | null = null;
  chapter: Chapter | null = null;

  bookmarked: boolean = false;

  ngOnInit() {
    this.route.paramMap.subscribe(params => {
      this.workId = params.get('workId');
      this.chapterId = params.get('chapterId');
      this.grabChapter();
    })
  }

  handleRefresh(event: RefresherCustomEvent) {
    if (this.workId != null && this.chapterId != null) this.ao3.getChapterPage(Number(this.workId), Number(this.chapterId)).subscribe(data => {
      this.chapter = this.chapterParser.parse(new DOMParser().parseFromString(data.data, "text/html"));
      event.target.complete();
    });
  }

  openWebPage() {
    Browser.open({ url: "https://archiveofourown.org/works/"+this.workId });
  }

  grabChapter() {
    if (this.workId != null && this.chapterId != null) this.ao3.getChapterPage(Number(this.workId), Number(this.chapterId)).subscribe(data => {
      this.chapter = this.chapterParser.parse(new DOMParser().parseFromString(data.data, "text/html"));
    });
  }

}
