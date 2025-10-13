import { Component, OnInit } from '@angular/core';
import {IonContent, IonHeader, IonTitle, IonToolbar} from '@ionic/angular/standalone';
import packageJson from '../../../../../package.json';

@Component({
  selector: 'main-settings-sub-view',
  templateUrl: './settings-sub-view.component.html',
  styleUrls: ['./settings-sub-view.component.less'],
  imports: [
    IonContent,
  ]
})
export class SettingsSubViewComponent  implements OnInit {

  constructor() { }

  ngOnInit() {}

  version = packageJson.version;

}
