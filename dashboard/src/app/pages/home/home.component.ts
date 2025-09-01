import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { provideHttpClient } from '@angular/common/http';
import { ApiService } from '../../services/api';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <h2>Cadastro de Usuário</h2>
    <form (ngSubmit)="salvar()" #form="ngForm">
      <label for="nome">Nome:</label>
      <input
        id="nome"
        name="nome"
        [(ngModel)]="novoUsuario.nome"
        required
        #nome="ngModel"
      />
      <div *ngIf="nome.invalid && nome.touched" class="erro">
        Nome é obrigatório.
      </div>

      <button type="submit" [disabled]="form.invalid || enviando">
        {{ enviando ? 'Salvando...' : 'Salvar' }}
      </button>
    </form>

    <p *ngIf="mensagem" [class.ok]="sucesso" [class.erro]="!sucesso">
      {{ mensagem }}
    </p>
  `,
  styles: [`
    form {
      margin-top: 20px;
    }
    input {
      margin-right: 10px;
      padding: 6px;
    }
    button {
      background-color: #007bff;
      color: white;
      border: none;
      padding: 6px 12px;
      border-radius: 4px;
      cursor: pointer;
    }
    button[disabled] {
      background-color: #aaa;
      cursor: not-allowed;
    }
    .erro {
      color: red;
      font-size: 0.9em;
      margin-top: 4px;
    }
    .ok {
      color: green;
      margin-top: 10px;
    }
    .erro:not(input) {
      color: red;
      margin-top: 10px;
    }
  `]
})
export class HomeComponent {
  novoUsuario = { nome: '' };
  mensagem = '';
  sucesso = false;
  enviando = false;

  constructor(private api: ApiService) {}

  salvar() {
    this.enviando = true;
    this.api.createUsuario(this.novoUsuario).subscribe({
      next: () => {
        this.mensagem = 'Usuário criado com sucesso!';
        this.sucesso = true;
        this.novoUsuario.nome = '';
        this.enviando = false;
      },
      error: (err) => {
        console.error('Erro ao criar usuário:', err);
        this.mensagem = 'Erro ao criar usuário. Tente novamente.';
        this.sucesso = false;
        this.enviando = false;
      }
    });
  }
}
