import {Component, Input, OnInit} from '@angular/core';
import {IonButton, IonIcon} from "@ionic/angular/standalone";
import {NgClass} from '@angular/common';
import {RouterLink} from '@angular/router';

@Component({
    selector: 'ui-drop-down-html',
    templateUrl: './drop-down-html.component.html',
    styleUrls: ['./drop-down-html.component.less'],
  imports: [
    IonButton,
    IonIcon,
    NgClass,
    RouterLink
  ]
})
export class DropDownHTMLComponent  implements OnInit {

  constructor() { }

  @Input() HTML: string = "";
  @Input() route: string | null = null;

  collapsed: boolean = true;

  ngOnInit() {}

  toggle() {this.collapsed = !this.collapsed;}

}
