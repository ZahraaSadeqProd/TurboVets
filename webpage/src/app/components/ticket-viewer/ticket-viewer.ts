import { Component } from '@angular/core';

interface Ticket {
  id: number;
  subject: string;
  status: 'Open' | 'In Progress' | 'Closed';
  createdAt: string;
}

@Component({
  selector: 'app-ticket-viewer',
  imports: [],
  templateUrl: './ticket-viewer.html',
  styleUrl: './ticket-viewer.css'
})
export class TicketViewer {
  // Status filter options
  statusOptions: Array<'All' | 'Open' | 'In Progress' | 'Closed'> = [
    'All',
    'Open',
    'In Progress',
    'Closed',
  ];

  selectedStatus: 'All' | 'Open' | 'In Progress' | 'Closed' = 'All';

  // Dummy ticket data
  tickets: Ticket[] = [
    {
      id: 1,
      subject: 'Login not working',
      status: 'Open',
      createdAt: '2025-09-28',
    },
    {
      id: 2,
      subject: 'Payment declined',
      status: 'In Progress',
      createdAt: '2025-09-27',
    },
    {
      id: 3,
      subject: 'Feature request: Dark mode',
      status: 'Closed',
      createdAt: '2025-09-25',
    },
  ];

  // Filter tickets dynamically
  get filteredTickets() {
    return this.selectedStatus === 'All'
      ? this.tickets
      : this.tickets.filter((t) => t.status === this.selectedStatus);
  }
}