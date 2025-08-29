import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApiService } from '../../services/api';
import { HttpClientModule } from '@angular/common/http'

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

  constructor(private api: ApiService) {}

  ngOnInit() {
    this.api.getAgenda().subscribe(data => this.eventos = data);
  }
}
