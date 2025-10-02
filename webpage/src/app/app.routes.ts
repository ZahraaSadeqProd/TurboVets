import { Routes } from '@angular/router';
import { TicketViewer } from './components/ticket-viewer/ticket-viewer';
import { KnowledgebaseEditor } from './components/knowledgebase-editor/knowledgebase-editor';
import { LiveLogs } from './components/live-logs/live-logs';

export const routes: Routes = [
  { path: '', redirectTo: 'tickets', pathMatch: 'full' },
  { path: 'tickets', component: TicketViewer },
  { path: 'knowledgebase', component: KnowledgebaseEditor },
  { path: 'logs', component: LiveLogs },
];