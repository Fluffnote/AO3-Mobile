import {Component, Input, OnInit} from '@angular/core';
import {ContentRating, ContentWarning, RPO, Status} from '../../data/models/ao3-symbols.enum';

@Component({
  selector: 'ui-ao3-symbols',
  templateUrl: './ao3-symbols.component.html',
  styleUrls: ['./ao3-symbols.component.less'],
})
export class AO3SymbolsComponent  implements OnInit {

  constructor() { }

  @Input() size: number = 40;

  @Input() rating: ContentRating = ContentRating.None;
  @Input() rpo: RPO = RPO.None;
  @Input() warning: ContentWarning = ContentWarning.None;
  @Input() status: Status = Status.Unknown;

  ngOnInit() {}

}
