import { Component, OnInit } from '@angular/core';
import {HistoryMgmt} from '../../../data/handlers/history-mgmt';
import {History} from '../../../data/models/history';
import {IonSpinner} from '@ionic/angular/standalone';
import {HistoryCardComponent} from '../../../UI/history-card/history-card.component';

@Component({
  selector: 'views-history-sub-view',
  templateUrl: './history-sub-view.component.html',
  styleUrls: ['./history-sub-view.component.less'],
  imports: [
    IonSpinner,
    HistoryCardComponent
  ]
})
export class HistorySubViewComponent  implements OnInit {

  constructor(private historyMgmt: HistoryMgmt) { }

  historyList: History[] | null = null;

  ngOnInit() {
    this.historyMgmt.updateHistoryList();
    this.historyMgmt.historyList.subscribe(list => this.historyList = list)
  }

}
