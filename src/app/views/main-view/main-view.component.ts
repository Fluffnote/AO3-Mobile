import { Component, OnInit } from '@angular/core';
import {IonIcon, IonTabBar, IonTabButton, IonTabs} from '@ionic/angular/standalone';
import {AO3} from '../../data/handlers/ao3';

@Component({
  selector: 'views-main-view',
  templateUrl: './main-view.component.html',
  styleUrls: ['./main-view.component.less'],
  imports: [
    IonTabs,
    IonTabBar,
    IonTabButton,
    IonIcon
  ]
})
export class MainViewComponent  implements OnInit {

  constructor() { }

  ngOnInit() {}

}
