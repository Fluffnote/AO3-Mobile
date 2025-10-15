import { Component, OnInit } from '@angular/core';
import {IonContent, IonHeader, IonTitle, IonToolbar} from '@ionic/angular/standalone';
import {AO3} from '../../../data/handlers/ao3';
import {Logger} from '@aparajita/capacitor-logger';

@Component({
  selector: 'main-filters-sub-view',
  templateUrl: './filters-sub-view.component.html',
  styleUrls: ['./filters-sub-view.component.less'],
  imports: [
    IonContent,
    IonHeader,
    IonTitle,
    IonToolbar
  ]
})
export class FiltersSubViewComponent  implements OnInit {

  constructor(
    private ao3: AO3
  ) { }

  out = ""

  ngOnInit() {
    this.ao3.getWorkPage(68994691).subscribe(data => {
      console.log(data)
      new Logger("AO3").info(JSON.stringify(data))
      this.out = JSON.stringify(data)
    });
  }

}
