import {AfterViewInit, Component, OnDestroy, OnInit, signal} from '@angular/core';
import {IonApp, IonRouterOutlet} from '@ionic/angular/standalone';
import {SQL} from './data/DB/sql';
import { App as CapApp } from '@capacitor/app';
import {Location} from '@angular/common';

@Component({
  selector: 'app-root',
  imports: [IonApp, IonRouterOutlet],
  templateUrl: './app.html',
  styleUrl: './app.less'
})
export class App implements OnInit, AfterViewInit, OnDestroy{
  protected readonly title = signal('AO3-Dweller');

  constructor(
    private sql : SQL,
    private location: Location
  ) {}

  ngOnInit() {
    CapApp.addListener('backButton', () => {
      this.location.back();
    });
  }

  async ngAfterViewInit() {
    await this.sql.initializeDatabase()
  }
  async ngOnDestroy() {
    await this.sql.closeDatabase()
  }
}
