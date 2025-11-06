import { Component, OnInit } from '@angular/core';
import {IonButton, IonContent, IonHeader, IonItem, IonLabel, IonTitle, IonToolbar} from '@ionic/angular/standalone';
import packageJson from '../../../../../package.json';
import {SQL} from '../../../data/DB/sql';

@Component({
  selector: 'views-extras-sub-view',
  templateUrl: './extras-sub-view.component.html',
  styleUrls: ['./extras-sub-view.component.less'],
  imports: [
    IonContent,
    IonButton,
    IonItem,
    IonLabel,
  ]
})
export class ExtrasSubViewComponent implements OnInit {

  constructor(private sql : SQL) { }

  ngOnInit() {}

  version = packageJson.version;

  onResetDB() {
    this.sql.resetDatabase();
  }

}
