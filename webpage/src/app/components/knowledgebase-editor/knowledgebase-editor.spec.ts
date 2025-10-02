import { ComponentFixture, TestBed } from '@angular/core/testing';

import { KnowledgebaseEditor } from './knowledgebase-editor';

describe('KnowledgebaseEditor', () => {
  let component: KnowledgebaseEditor;
  let fixture: ComponentFixture<KnowledgebaseEditor>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [KnowledgebaseEditor]
    })
    .compileComponents();

    fixture = TestBed.createComponent(KnowledgebaseEditor);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
