import { Component, OnInit } from '@angular/core';
import {IonContent, IonHeader, IonTitle, IonToolbar} from '@ionic/angular/standalone';

@Component({
  selector: 'app-search-sub-view',
  templateUrl: './search-sub-view.component.html',
  styleUrls: ['./search-sub-view.component.less'],
  imports: [
    IonHeader,
    IonToolbar,
    IonTitle,
    IonContent
  ]
})
export class SearchSubViewComponent  implements OnInit {

  constructor() { }

  ngOnInit() {}

}
