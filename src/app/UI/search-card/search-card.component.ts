import {Component, Input, OnInit} from '@angular/core';
import {Work} from '../../data/models/work';
import {AO3SymbolsComponent} from '../ao3-symbols/ao3-symbols.component';
import {IonChip, IonIcon, IonNavLink} from '@ionic/angular/standalone';
import {DropDownHTMLComponent} from '../drop-down-html/drop-down-html.component';
import {DecimalPipe} from '@angular/common';
import {RouterLink} from '@angular/router';
import {UIHoldToCopyDirective} from '../hold-to-copy.dir';

@Component({
  selector: 'ui-search-card',
  templateUrl: './search-card.component.html',
  styleUrls: ['./search-card.component.less'],
  imports: [
    AO3SymbolsComponent,
    IonIcon,
    DropDownHTMLComponent,
    DecimalPipe,
    IonNavLink,
    RouterLink,
    IonChip,
    UIHoldToCopyDirective
  ]
})
export class SearchCardComponent  implements OnInit {

  constructor() { }

  @Input() work: Work | null = null;
  combinedTags: string[] = [];

  ngOnInit() {
    if (this.work != null) {
      this.combinedTags = [this.work.warning, ...this.work.fandoms, ...this.work.relationships, ...this.work.characters]
    }
  }

  dateOnly(date: Date) {
    return date.toISOString().split('T')[0];
  }

}
