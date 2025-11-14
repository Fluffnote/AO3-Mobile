import {AfterViewInit, Directive, EventEmitter, Input, Output} from '@angular/core';

@Directive({
  selector: "[UIElemLoad]"
})
export class ElementLoadDirective implements AfterViewInit {

  @Output('UIElemLoad') initEvent: EventEmitter<any> = new EventEmitter();

  ngAfterViewInit() {
    this.initEvent.emit();
  }
}
