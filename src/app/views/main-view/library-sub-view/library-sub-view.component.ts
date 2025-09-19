import { Component, OnInit } from '@angular/core';
import {IonContent, IonHeader, IonTitle, IonToolbar} from '@ionic/angular/standalone';

@Component({
  selector: 'app-library-sub-view',
  templateUrl: './library-sub-view.component.html',
  styleUrls: ['./library-sub-view.component.less'],
  imports: [
    IonContent,
    IonHeader,
    IonTitle,
    IonToolbar
  ]
})
export class LibrarySubViewComponent  implements OnInit {

  constructor() { }

  ngOnInit() {}

}
