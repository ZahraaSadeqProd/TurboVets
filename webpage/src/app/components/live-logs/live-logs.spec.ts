import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LiveLogs } from './live-logs';

describe('LiveLogs', () => {
  let component: LiveLogs;
  let fixture: ComponentFixture<LiveLogs>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [LiveLogs]
    })
    .compileComponents();

    fixture = TestBed.createComponent(LiveLogs);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
