import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApiService } from '../../services/api';

@Component({
  selector: 'app-agenda',
  standalone: true,
  imports: [CommonModule],
  template: `
    <h2>Agenda de Eventos</h2>
    <ul *ngIf="eventos.length > 0; else vazio">
      <li *ngFor="let evento of eventos">
        <strong>{{ evento.titulo }}</strong> — {{ evento.data | date:'shortDate' }}
      </li>
    </ul>
    <ng-template #vazio>
      <p>Nenhum evento encontrado.</p>
    </ng-template>
  `
})
export class AgendaComponent implements OnInit {
  eventos: any[] = [];
  loading = false;
  error: string | null = null;

  constructor(private api: ApiService) {}

  ngOnInit() {
    this.loadEventos();
  }
  
  private loadEventos() {
    this.loading = true;
    this.error = null;
    
    this.api.getAgenda().subscribe({
      next: (data) => {
        this.eventos = data || [];
        this.loading = false;
      },
      error: (error) => {
        this.error = 'Erro ao carregar eventos: ' + error;
        this.loading = false;
        console.error('Erro ao carregar agenda:', error);
      }
    });
  }
}
