import { Component, OnInit } from '@angular/core';
import {IonContent, IonHeader, IonTitle, IonToolbar} from '@ionic/angular/standalone';
import {AO3} from '../../../data/handlers/ao3';
import {WorkParser} from '../../../data/parsers/work-parser';

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
  workParser = new WorkParser();

  ngOnInit() {
    this.ao3.getWorkPage(69567981).subscribe(data => {
      this.out = data.data
      this.workParser.parse(new DOMParser().parseFromString(data.data, "text/html"));
    });
  }

}
