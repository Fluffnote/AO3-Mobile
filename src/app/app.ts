import {AfterViewInit, Component, OnDestroy, signal} from '@angular/core';
import {IonApp, IonRouterOutlet} from '@ionic/angular/standalone';
import {SQL} from './data/DB/sql';

@Component({
  selector: 'app-root',
  imports: [IonApp, IonRouterOutlet],
  templateUrl: './app.html',
  styleUrl: './app.less'
})
export class App implements AfterViewInit, OnDestroy{
  protected readonly title = signal('AO3-Mobile');

  constructor(private sql : SQL) {}

  async ngAfterViewInit() {
    await this.sql.initializeDatabase()
  }
  async ngOnDestroy() {
    await this.sql.closeDatabase()
  }
}
