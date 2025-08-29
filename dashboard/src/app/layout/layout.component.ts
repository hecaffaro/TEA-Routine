import { Component } from '@angular/core';
import { RouterModule } from '@angular/router';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatListModule } from '@angular/material/list';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-layout',
  standalone: true,
  imports: [CommonModule, RouterModule, MatSidenavModule, MatListModule],
  template: `
    <mat-sidenav-container style="height: 100vh;">
      <mat-sidenav mode="side" opened>
        <mat-nav-list>
          <a mat-list-item routerLink="/home">🏠 Home</a>
          <a mat-list-item routerLink="/admin">🛠️ Admin</a>
          <a mat-list-item routerLink="/agenda">📅 Agenda</a>
          <a mat-list-item routerLink="/noticias">📰 Notícias</a>
          <a mat-list-item routerLink="/jogos">🎮 Jogos</a>
        </mat-nav-list>
      </mat-sidenav>
      <mat-sidenav-content style="padding: 20px;">
        <router-outlet></router-outlet>
      </mat-sidenav-content>
    </mat-sidenav-container>
  `
})
export class LayoutComponent {}
