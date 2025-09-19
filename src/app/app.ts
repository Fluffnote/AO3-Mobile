import { Component, signal } from '@angular/core';
import {IonApp, IonRouterOutlet} from '@ionic/angular/standalone';

@Component({
  selector: 'app-root',
  imports: [IonApp, IonRouterOutlet],
  templateUrl: './app.html',
  styleUrl: './app.less'
})
export class App {
  protected readonly title = signal('AO3-Mobile');
}
