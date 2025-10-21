import { Component, OnInit } from '@angular/core';
import {IonButton, IonContent, IonHeader, IonNavLink, IonTitle, IonToolbar} from '@ionic/angular/standalone';
import {RouterLink} from '@angular/router';

@Component({
  selector: 'main-filters-sub-view',
  templateUrl: './filters-sub-view.component.html',
  styleUrls: ['./filters-sub-view.component.less'],
  imports: [
    IonContent,
    IonHeader,
    IonTitle,
    IonToolbar,
    RouterLink,
    IonButton,
    IonNavLink
  ]
})
export class FiltersSubViewComponent  implements OnInit {

  constructor() { }

  out = ""

  ngOnInit() { }

}
