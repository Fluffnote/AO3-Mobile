import {Directive, EventEmitter, Input, Output} from '@angular/core';

@Directive({
  selector: "[elemLoad]"
})
export class ElementLoadDirective {

  @Output('elemLoad') initEvent: EventEmitter<any> = new EventEmitter();

  ngAfterViewInit() {
    this.initEvent.emit();
  }
}
