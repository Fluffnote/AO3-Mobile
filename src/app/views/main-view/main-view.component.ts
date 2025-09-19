import { Component, OnInit } from '@angular/core';
import {IonIcon, IonTabBar, IonTabButton, IonTabs} from '@ionic/angular/standalone';

@Component({
  selector: 'app-main-view',
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
