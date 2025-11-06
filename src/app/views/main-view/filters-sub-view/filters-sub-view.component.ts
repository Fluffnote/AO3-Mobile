import { Component, OnInit } from '@angular/core';
import {IonContent, IonHeader, IonTitle, IonToolbar} from '@ionic/angular/standalone';
import {logger} from '../../../data/handlers/logger';

@Component({
  selector: 'views-filters-sub-view',
  templateUrl: './filters-sub-view.component.html',
  styleUrls: ['./filters-sub-view.component.less'],
  imports: [
    IonContent,
    IonHeader,
    IonTitle,
    IonToolbar
  ]
})
export class FiltersSubViewComponent  implements OnInit {

  constructor() { }

  out = ""

  ngOnInit() { }

}
