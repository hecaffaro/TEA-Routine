import { Component } from '@angular/core';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterModule],
  template: `
    <nav>
      <a routerLink="/home">Home</a> |
      <a routerLink="/admin">Admin</a>
    </nav>
    <hr />
    <router-outlet></router-outlet>
  `,
  styles: [`
    nav a {
      margin-right: 10px;
      text-decoration: none;
      color: #007bff;
    }
    nav a:hover {
      text-decoration: underline;
    }
  `]
})
export class AppComponent {}
