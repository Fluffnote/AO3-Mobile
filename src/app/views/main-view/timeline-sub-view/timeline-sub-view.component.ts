import { Component, OnInit } from '@angular/core';
import {
  IonContent,
  IonHeader,
  IonLabel,
  IonSegment,
  IonSegmentButton, IonSegmentContent, IonSegmentView,
  IonTitle,
  IonToolbar
} from '@ionic/angular/standalone';
import {HistorySubViewComponent} from '../../timeline-sub-views/history-sub-view/history-sub-view.component';

@Component({
  selector: 'views-timeline-sub-view',
  templateUrl: './timeline-sub-view.component.html',
  styleUrls: ['./timeline-sub-view.component.less'],
  imports: [
    IonContent,
    IonHeader,
    IonTitle,
    IonToolbar,
    IonSegment,
    IonSegmentButton,
    IonLabel,
    IonSegmentView,
    IonSegmentContent,
    HistorySubViewComponent
  ]
})
export class TimelineSubViewComponent  implements OnInit {

  constructor() { }

  ngOnInit() {}

}
