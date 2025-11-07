import {Component, Input, OnInit} from '@angular/core';
import {History} from '../../data/models/history';
import {AO3SymbolsComponent} from '../ao3-symbols/ao3-symbols.component';
import {DecimalPipe} from '@angular/common';
import {DropDownHTMLComponent} from '../drop-down-html/drop-down-html.component';
import {IonIcon, IonNavLink, IonProgressBar} from '@ionic/angular/standalone';
import {RouterLink} from '@angular/router';
import {logger} from '../../data/handlers/logger';

@Component({
  selector: 'ui-history-card',
  templateUrl: './history-card.component.html',
  styleUrls: ['./history-card.component.less'],
  imports: [
    AO3SymbolsComponent,
    DecimalPipe,
    DropDownHTMLComponent,
    IonIcon,
    IonNavLink,
    RouterLink,
    IonProgressBar
  ]
})
export class HistoryCardComponent  implements OnInit {

  constructor() { }

  @Input() history: History | null = null;

  progressAmount : number = 0.0;

  ngOnInit() {
    this.progressAmount = this.history!.scrollPosition/this.history!.scrollMax;
  }

}
