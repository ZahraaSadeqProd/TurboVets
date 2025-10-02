import { Component } from '@angular/core';
import { marked } from 'marked';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-knowledgebase-editor',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './knowledgebase-editor.html',
  styleUrl: './knowledgebase-editor.css',
})
export class KnowledgebaseEditor {
  content: string = '# Welcome to TurboVets\n\nStart writing here...';
  previewMode: boolean = false;

  saved: boolean = false; // control success banner

  get renderedContent(): string {
    return marked.parse(this.content) as string;
  }

  togglePreview(state: boolean) {
    this.previewMode = state;
  }

  saveContent() {
    this.saved = true;
    setTimeout(() => (this.saved = false), 3000); // hide after 3s
  }
}