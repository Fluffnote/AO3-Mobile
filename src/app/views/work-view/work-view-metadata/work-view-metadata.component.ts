import {Component, Input, OnInit} from '@angular/core';
import {Work} from '../../../data/models/work';
import {DropDownContainerComponent} from '../../../UI/drop-down-container/drop-down-container.component';
import {DecimalPipe} from '@angular/common';
import {IonChip, IonIcon} from '@ionic/angular/standalone';

@Component({
  selector: 'views-work-view-metadata',
  templateUrl: './work-view-metadata.component.html',
  styleUrls: ['./work-view-metadata.component.less'],
  imports: [
    DropDownContainerComponent,
    DecimalPipe,
    IonIcon,
    IonChip
  ]
})
export class WorkViewMetadataComponent  implements OnInit {

  constructor() { }

  @Input() work: Work | null = null;

  ngOnInit() {}

  dateOnly(date: Date) {
    return date.toISOString().split('T')[0];
  }

}
