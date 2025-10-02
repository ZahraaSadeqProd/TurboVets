import {
  Component,
  OnInit,
  OnDestroy,
  ElementRef,
  ViewChild,
  AfterViewChecked,
} from '@angular/core';

@Component({
  selector: 'app-live-logs',
  templateUrl: './live-logs.html',
  styleUrls: ['./live-logs.css'], 
})
export class LiveLogs implements OnInit, OnDestroy, AfterViewChecked {
  logs: string[] = [];
  intervalId?: number;

  autoScroll = true; // always enabled until user scrolls up
  private needsScroll = false; // flag to scroll after DOM update

  @ViewChild('logContainer') logContainer?: ElementRef<HTMLDivElement>;

  ngOnInit() {
    this.intervalId = window.setInterval(() => {
      const timestamp = new Date().toLocaleTimeString();
      const randomEvent = this.fakeEvent();
      this.logs.push(`[${timestamp}] ${randomEvent}`);

      // mark that after Angular renders, we should scroll if needed
      this.needsScroll = true;
    }, 2000);
  }

  ngAfterViewChecked() {
    if (this.needsScroll) {
      this.scrollIfNeeded();
      this.needsScroll = false;
    }
  }

  ngOnDestroy() {
    if (this.intervalId) clearInterval(this.intervalId);
  }

  onScroll() {
    if (this.logContainer) {
      const el = this.logContainer.nativeElement;
      const atBottom =
        el.scrollTop + el.clientHeight >= el.scrollHeight - 10;

      // Disable autoScroll ONLY if user is not at bottom
      this.autoScroll = atBottom;
    }
  }

  scrollToBottom() {
    if (this.logContainer) {
      const el = this.logContainer.nativeElement;
      el.scrollTop = el.scrollHeight;
    }
    this.autoScroll = true;
  }

  private scrollIfNeeded() {
    if (this.autoScroll && this.logContainer) {
      const el = this.logContainer.nativeElement;
      el.scrollTop = el.scrollHeight;
    }
  }

  private fakeEvent(): string {
    const events = [
      'User login successful',
      'New ticket created: #123',
      'Database connection established',
      'Error: Payment API timeout',
      'Notification sent to agent',
      'Refreshing session token',
    ];
    return events[Math.floor(Math.random() * events.length)];
  }
}
