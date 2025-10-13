import { Component, OnInit } from '@angular/core';
import {
  IonButton,
  IonButtons,
  IonContent,
  IonHeader, IonIcon,
  IonSearchbar,
  IonToolbar
} from '@ionic/angular/standalone';
import {HomeSubViewComponent} from '../home-sub-view/home-sub-view.component';

@Component({
  selector: 'main-search-sub-view',
  templateUrl: './search-sub-view.component.html',
  styleUrls: ['./search-sub-view.component.less'],
  imports: [
    IonHeader,
    IonToolbar,
    IonContent,
    IonSearchbar,
    HomeSubViewComponent,
    IonButtons,
    IonButton,
    IonIcon
  ]
})
export class SearchSubViewComponent  implements OnInit {

  constructor() { }

  ngOnInit() {}

}
