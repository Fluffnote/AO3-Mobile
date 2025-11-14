import {Directive, HostListener, Input} from '@angular/core';
import {logger} from '../data/handlers/logger';
import {Clipboard} from '@capacitor/clipboard';
import {Haptics, ImpactStyle} from '@capacitor/haptics';

@Directive({
  standalone: true,
  selector: "[HoldToCopy]"
})
export class UIHoldToCopyDirective {

  @Input('HoldToCopy') copyItem: string | null = null;

  private duration = 1000;
  private interval: any;
  private progress: number = 0;

  start() {
    this.interval = setInterval(() => {
      this.progress += 10;
      logger.info("progress: " + this.progress)
      if (this.progress >= this.duration) {
        this.reset();
        logger.info("copy: " + this.copyItem)
        if (this.copyItem != null) {
          Clipboard.write({string: this.copyItem});
          Haptics.impact({ style: ImpactStyle.Medium })
        }
      }
    })
  }

  reset() {
    clearInterval(this.interval);
    this.progress = 0;
  }

  @HostListener('mousedown', ['$event']) onMouseDown(e: any) { this.start(); }
  @HostListener('touchstart', ['$event']) onTouchStart(e: any) { this.start(); }


  @HostListener('mouseup', ['$event']) onMouseUp(e: any) { this.reset(); }
  @HostListener('mouseleave', ['$event']) onMouseLeave(e: any) { this.reset(); }
  @HostListener('touchend', ['$event']) onTouchEnd(e: any) { this.reset(); }
  @HostListener('touchcancel', ['$event']) onTouchCancel(e: any) { this.reset(); }
  @HostListener('touchmove', ['$event']) onTouchMove(e: any) { this.reset(); }
}
