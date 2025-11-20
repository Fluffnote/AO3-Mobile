import { Component, OnInit } from '@angular/core';
import {IonButton, IonIcon} from "@ionic/angular/standalone";
import {Location} from '@angular/common';

@Component({
    selector: 'ui-back-button',
    templateUrl: './back-button.component.html',
    styleUrls: ['./back-button.component.less'],
    imports: [
        IonButton,
        IonIcon
    ]
})
export class BackButtonComponent {

  constructor(private location: Location) { }

  back() {this.location.back();}

}
