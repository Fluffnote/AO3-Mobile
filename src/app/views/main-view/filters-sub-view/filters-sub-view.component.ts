import { Component, OnInit } from '@angular/core';
import {IonContent, IonHeader, IonTitle, IonToolbar} from '@ionic/angular/standalone';
import {AO3SymbolsComponent} from '../../../UI/ao3-symbols/ao3-symbols.component';
import {AO3} from '../../../data/handlers/ao3';

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

  constructor(private ao3: AO3) { }

  out = ""

  ngOnInit() {
    this.ao3.getWorkPage(68994691).subscribe(data => this.out = data);
  }

}
