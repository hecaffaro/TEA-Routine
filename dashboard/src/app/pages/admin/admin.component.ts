import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApiService } from '../../services/api';
import { HttpClientModule } from '@angular/common/http'


@Component({
  selector: 'app-admin',
  standalone: true,
  imports: [CommonModule],
  template: `
    <h2>Lista de Usuários</h2>
    <ul *ngIf="usuarios.length > 0; else vazio">
      <li *ngFor="let user of usuarios">{{ user.nome }}</li>
    </ul>
    <ng-template #vazio>
      <p>Nenhum usuário encontrado.</p>
    </ng-template>
  `,
  styles: [`
    ul {
      margin-top: 20px;
      padding-left: 20px;
    }
    li {
      margin-bottom: 5px;
    }
  `]
})
export class AdminComponent implements OnInit {
  usuarios: any[] = [];

  constructor(private api: ApiService) {}

  ngOnInit() {
    this.api.getUsuarios().subscribe(data => this.usuarios = data);
  }
}
