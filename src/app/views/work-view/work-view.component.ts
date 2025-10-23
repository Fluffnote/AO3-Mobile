import { Component, OnInit } from '@angular/core';
import {
  IonBackButton, IonButton,
  IonButtons,
  IonContent, IonFab, IonFabButton,
  IonHeader, IonIcon,
  IonRefresher, IonRefresherContent,
  IonTitle,
  IonToolbar
} from "@ionic/angular/standalone";
import {ActivatedRoute} from '@angular/router';
import {Work} from '../../data/models/work';
import {AO3} from '../../data/handlers/ao3';
import {WorkParser} from '../../data/parsers/work-parser';
import {DecimalPipe, NgIf} from '@angular/common';
import {RefresherCustomEvent} from '@ionic/angular';
import {WorkViewMetadataComponent} from './work-view-metadata/work-view-metadata.component';
import {Browser} from '@capacitor/browser';
import {DropDownHTMLComponent} from '../../UI/drop-down-html/drop-down-html.component';

@Component({
    selector: 'app-work-view',
    templateUrl: './work-view.component.html',
    styleUrls: ['./work-view.component.less'],
  imports: [
    IonContent,
    IonHeader,
    IonTitle,
    IonToolbar,
    IonButtons,
    IonBackButton,
    IonRefresher,
    IonRefresherContent,
    WorkViewMetadataComponent,
    IonButton,
    IonIcon,
    DropDownHTMLComponent,
    IonFab,
    IonFabButton
  ]
})
export class WorkViewComponent  implements OnInit {

  constructor(
    private route: ActivatedRoute,
    private ao3: AO3
  ) { }

  workParser = new WorkParser();
  workId: string | null = null;
  work: Work | null = null;

  bookmarked: boolean = false;

  ngOnInit() {
    this.route.paramMap.subscribe(params => {
      this.workId = params.get('workId');
      this.grabWork();
    })
  }

  handleRefresh(event: RefresherCustomEvent) {
    if (this.workId != null) this.ao3.getWorkPage(Number(this.workId)).subscribe(data => {
      this.work = this.workParser.parse(new DOMParser().parseFromString(data.data, "text/html"));
      event.target.complete();
    });
  }

  toggleBookmark() {
    this.bookmarked = !this.bookmarked
  }

  openWebPage() {
    Browser.open({ url: "https://archiveofourown.org/works/"+this.workId });
  }

  grabWork() {
    if (this.workId != null) this.ao3.getWorkPage(Number(this.workId)).subscribe(data => {
      this.work = this.workParser.parse(new DOMParser().parseFromString(data.data, "text/html"));
    });
  }

}
