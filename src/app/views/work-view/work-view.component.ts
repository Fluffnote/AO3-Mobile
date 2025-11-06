import { Component, OnInit } from '@angular/core';
import {
  IonBackButton, IonButton,
  IonButtons,
  IonContent, IonFab, IonFabButton,
  IonHeader, IonIcon, IonItem, IonLabel, IonNavLink,
  IonRefresher, IonRefresherContent, IonSpinner,
  IonTitle,
  IonToolbar
} from "@ionic/angular/standalone";
import {ActivatedRoute, RouterLink} from '@angular/router';
import {Work} from '../../data/models/work';
import {AO3} from '../../data/handlers/ao3';
import {WorkParser} from '../../data/parsers/work-parser';
import {DecimalPipe, NgIf} from '@angular/common';
import {RefresherCustomEvent} from '@ionic/angular';
import {WorkViewMetadataComponent} from './work-view-metadata/work-view-metadata.component';
import {Browser} from '@capacitor/browser';
import {DropDownHTMLComponent} from '../../UI/drop-down-html/drop-down-html.component';
import {SQL} from '../../data/DB/sql';
import {logger} from '../../data/handlers/logger';
import {WorkPipeline} from '../../data/handlers/class/work-pipeline';

@Component({
    selector: 'views-work-view',
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
    IonFabButton,
    IonSpinner,
    IonNavLink,
    IonItem,
    IonLabel,
    RouterLink,
  ]
})
export class WorkViewComponent  implements OnInit {

  constructor(
    private route: ActivatedRoute,
    private ao3: AO3,
    private workPipe: WorkPipeline
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
    if (this.workId != null) this.workPipe.get(Number(this.workId), 2).subscribe(work => {
      this.work = work;
      event.target.complete();
    })
  }

  toggleBookmark() {
    this.bookmarked = !this.bookmarked
  }

  openWebPage() {
    Browser.open({ url: "https://archiveofourown.org/works/"+this.workId+"?view_adult=true" });
  }

  grabWork() {
    if (this.workId != null) {
      this.workPipe.get(Number(this.workId), 1).subscribe(work => {
        this.work = work;
      })
    }
  }

}
