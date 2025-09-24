import { Component, OnInit } from '@angular/core';
import {
  IonButton,
  IonButtons,
  IonContent,
  IonHeader, IonIcon,
  IonSearchbar,
  IonTitle,
  IonToolbar
} from '@ionic/angular/standalone';
import {HomeSubViewComponent} from '../home-sub-view/home-sub-view.component';

@Component({
  selector: 'app-search-sub-view',
  templateUrl: './search-sub-view.component.html',
  styleUrls: ['./search-sub-view.component.less'],
  imports: [
    IonHeader,
    IonToolbar,
    IonTitle,
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
