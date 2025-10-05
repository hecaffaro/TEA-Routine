import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApiService } from '../../services/api';

@Component({
  selector: 'app-noticias',
  standalone: true,
  imports: [CommonModule],
  template: `
    <h2>Últimas Notícias</h2>
    <div *ngIf="noticias.length > 0; else vazio">
      <article *ngFor="let noticia of noticias">
        <h3>{{ noticia.titulo }}</h3>
        <p>{{ noticia.resumo }}</p>
        <small>{{ noticia.data | date:'short' }}</small>
        <hr />
      </article>
    </div>
    <ng-template #vazio>
      <p>Nenhuma notícia disponível.</p>
    </ng-template>
  `
})
export class NoticiasComponent implements OnInit {
  noticias: any[] = [];
  loading = false;
  error: string | null = null;

  constructor(private api: ApiService) {}

  ngOnInit() {
    this.loadNoticias();
  }
  
  private loadNoticias() {
    this.loading = true;
    this.error = null;
    
    this.api.getNoticias().subscribe({
      next: (data) => {
        this.noticias = data || [];
        this.loading = false;
      },
      error: (error) => {
        this.error = 'Erro ao carregar notícias: ' + error;
        this.loading = false;
        console.error('Erro ao carregar notícias:', error);
      }
    });
  }
}
