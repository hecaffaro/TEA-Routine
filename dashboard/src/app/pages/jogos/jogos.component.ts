import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApiService } from '../../services/api';

@Component({
  selector: 'app-jogos',
  standalone: true,
  imports: [CommonModule],
  template: `
    <h2>Jogos Programados</h2>
    <ul *ngIf="jogos.length > 0; else vazio">
      <li *ngFor="let jogo of jogos">
        {{ jogo.timeA }} vs {{ jogo.timeB }} — {{ jogo.data | date:'short' }}
      </li>
    </ul>
    <ng-template #vazio>
      <p>Nenhum jogo encontrado.</p>
    </ng-template>
  `
})
export class JogosComponent implements OnInit {
  jogos: any[] = [];
  loading = false;
  error: string | null = null;

  constructor(private api: ApiService) {}

  ngOnInit() {
    this.loadJogos();
  }
  
  private loadJogos() {
    this.loading = true;
    this.error = null;
    
    this.api.getJogos().subscribe({
      next: (data) => {
        this.jogos = data || [];
        this.loading = false;
      },
      error: (error) => {
        this.error = 'Erro ao carregar jogos: ' + error;
        this.loading = false;
        console.error('Erro ao carregar jogos:', error);
      }
    });
  }
}
