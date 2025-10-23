import { Component, OnInit } from '@angular/core';
import {NgTemplateOutlet} from '@angular/common';
import {IonButton, IonIcon} from '@ionic/angular/standalone';

@Component({
  selector: 'ui-drop-down-container',
  templateUrl: './drop-down-container.component.html',
  styleUrls: ['./drop-down-container.component.less'],
  imports: [
    IonButton,
    IonIcon
  ]
})
export class DropDownContainerComponent  implements OnInit {

  constructor() { }

  collapsed: boolean = true;

  ngOnInit() {}

  toggle() {this.collapsed = !this.collapsed;}

}
