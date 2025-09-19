import { Component, OnInit } from '@angular/core';
import {IonContent, IonHeader, IonTitle, IonToolbar} from '@ionic/angular/standalone';

@Component({
  selector: 'app-settings-sub-view',
  templateUrl: './settings-sub-view.component.html',
  styleUrls: ['./settings-sub-view.component.less'],
  imports: [
    IonContent,
    IonHeader,
    IonTitle,
    IonToolbar
  ]
})
export class SettingsSubViewComponent  implements OnInit {

  constructor() { }

  ngOnInit() {}

}
