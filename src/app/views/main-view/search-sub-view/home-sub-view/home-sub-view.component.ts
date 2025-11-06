import { Component, OnInit } from '@angular/core';
import {IonButton, IonChip, IonIcon, IonLabel} from '@ionic/angular/standalone';
import {Browser} from '@capacitor/browser';

@Component({
  selector: 'views-home-sub-view',
  templateUrl: './home-sub-view.component.html',
  styleUrls: ['./home-sub-view.component.less'],
  imports: [
    IonButton,
    IonIcon,
    IonChip,
    IonLabel
  ]
})
export class HomeSubViewComponent  implements OnInit {

  constructor() { }

  ngOnInit() {}

  openBrowser(url: string) { Browser.open({url}); }

}
