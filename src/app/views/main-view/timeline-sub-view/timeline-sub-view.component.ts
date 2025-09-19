import { Component, OnInit } from '@angular/core';
import {IonContent, IonHeader, IonTitle, IonToolbar} from '@ionic/angular/standalone';

@Component({
  selector: 'app-timeline-sub-view',
  templateUrl: './timeline-sub-view.component.html',
  styleUrls: ['./timeline-sub-view.component.less'],
  imports: [
    IonContent,
    IonHeader,
    IonTitle,
    IonToolbar
  ]
})
export class TimelineSubViewComponent  implements OnInit {

  constructor() { }

  ngOnInit() {}

}
