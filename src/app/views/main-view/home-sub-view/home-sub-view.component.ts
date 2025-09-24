import { Component, OnInit } from '@angular/core';
import {IonButton, IonChip, IonIcon, IonLabel} from '@ionic/angular/standalone';

@Component({
  selector: 'main-home-sub-view',
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

}
