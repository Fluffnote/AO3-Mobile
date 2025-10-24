import { Component, OnInit } from '@angular/core';
import {
  IonButton,
  IonButtons,
  IonContent,
  IonHeader, IonIcon,
  IonSearchbar,
  IonToolbar
} from '@ionic/angular/standalone';
import {HomeSubViewComponent} from '../home-sub-view/home-sub-view.component';
import {Search} from '../../../data/handlers/search';
import {Work} from '../../../data/models/work';
import {DecimalPipe} from '@angular/common';
import {SearchCardComponent} from '../../../UI/search-card/search-card.component';
import {logger} from '../../../data/handlers/logger';

@Component({
  selector: 'main-search-sub-view',
  templateUrl: './search-sub-view.component.html',
  styleUrls: ['./search-sub-view.component.less'],
  imports: [
    IonHeader,
    IonToolbar,
    IonContent,
    IonSearchbar,
    HomeSubViewComponent,
    IonButtons,
    IonButton,
    IonIcon,
    DecimalPipe,
    SearchCardComponent
  ]
})
export class SearchSubViewComponent  implements OnInit {

  constructor(private search: Search) { }

  amountFound: number = -1;
  works: Work[] = [];

  ngOnInit() {
    this.search.amountFound.subscribe(amount => this.amountFound = amount);
    this.search.searchResults.subscribe(works => this.works = works);
  }

  onSearchChange(event: Event) {
    let value = (event.target as HTMLIonSearchbarElement).value;
    if (typeof value === "string" && value.length > 0) this.search.searchText(value as string);
    else {
      this.amountFound = -1
      this.works = [];
    }
  }

}
