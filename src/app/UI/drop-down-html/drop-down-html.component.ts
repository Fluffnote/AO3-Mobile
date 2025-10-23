import {Component, Input, OnInit} from '@angular/core';
import {IonButton, IonIcon} from "@ionic/angular/standalone";
import {NgClass} from '@angular/common';

@Component({
    selector: 'ui-drop-down-html',
    templateUrl: './drop-down-html.component.html',
    styleUrls: ['./drop-down-html.component.less'],
  imports: [
    IonButton,
    IonIcon,
    NgClass
  ]
})
export class DropDownHTMLComponent  implements OnInit {

  constructor() { }

  @Input() HTML: string = "";

  collapsed: boolean = true;

  ngOnInit() {}

  toggle() {this.collapsed = !this.collapsed;}

}
