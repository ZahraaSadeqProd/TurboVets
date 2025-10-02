import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TicketViewer } from './ticket-viewer';

describe('TicketViewer', () => {
  let component: TicketViewer;
  let fixture: ComponentFixture<TicketViewer>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [TicketViewer]
    })
    .compileComponents();

    fixture = TestBed.createComponent(TicketViewer);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
