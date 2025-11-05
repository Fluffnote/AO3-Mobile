import {Component, OnInit, ViewChild} from '@angular/core';
import {
  IonButton,
  IonButtons,
  IonContent,
  IonHeader, IonIcon, IonInfiniteScroll, IonInfiniteScrollContent,
  IonSearchbar,
  IonToolbar
} from '@ionic/angular/standalone';
import {HomeSubViewComponent} from '../home-sub-view/home-sub-view.component';
import {Search} from '../../../data/handlers/search';
import {Work} from '../../../data/models/work';
import {DecimalPipe} from '@angular/common';
import {SearchCardComponent} from '../../../UI/search-card/search-card.component';
import {logger} from '../../../data/handlers/logger';
import {Router} from '@angular/router';
import {InfiniteScrollCustomEvent} from '@ionic/angular';
import {Keyboard} from '@capacitor/keyboard';

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
    SearchCardComponent,
    IonInfiniteScroll,
    IonInfiniteScrollContent
  ]
})
export class SearchSubViewComponent  implements OnInit {

  constructor(
    private search: Search,
    private router: Router
  ) { }

  @ViewChild("SearchBar") searchBar!: IonSearchbar;

  amountFound: number = -1;
  works: Work[] = [];
  searchEnd: boolean = false;

  ngOnInit() {
    this.search.amountFound.subscribe(amount => this.amountFound = amount);
    this.search.searchResults.subscribe(works => this.works = works);
    this.search.searchEnd.subscribe(searchEnd => this.searchEnd = searchEnd);
  }

  onSearchChange(event: Event) {
    let value = (event.target as HTMLIonSearchbarElement).value;
    if (typeof value === "string" && value.length > 0) {
      if (value.includes("/works/")) {
        logger.info("value: "+value);
        let workId = value.substring(value.indexOf("/works/")+7)
        workId = workId.substring(0, workId.search(/[\/?]/));
        this.router.navigate(['/work', workId]);
        this.searchBar.value = "";
      }
      else this.search.searchText(value as string).subscribe(() => { Keyboard.hide(); });
    }
    else {
      this.amountFound = -1
      this.works = [];
    }
  }

  onSearchNext(event: InfiniteScrollCustomEvent) {
    this.search.searchNext().subscribe(result => {
      event.target.complete();
    });
  }

}
