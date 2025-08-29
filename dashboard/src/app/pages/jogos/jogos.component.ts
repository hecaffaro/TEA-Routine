import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApiService } from '../../services/api';
import { HttpClientModule } from '@angular/common/http'

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

  constructor(private api: ApiService) {}

  ngOnInit() {
    this.api.getJogos().subscribe(data => this.jogos = data);
  }
}
