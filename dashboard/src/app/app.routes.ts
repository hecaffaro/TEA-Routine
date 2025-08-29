import { Routes } from '@angular/router';
import { LayoutComponent } from './layout/layout.component';
import { AdminComponent } from './pages/admin/admin.component';
import { HomeComponent } from './pages/home/home.component';

export const routes: Routes = [
  {
    path: '',
    component: LayoutComponent,
    children: [
      { path: 'home', component: HomeComponent },
      { path: 'admin', component: AdminComponent },
      { path: 'agenda', loadComponent: () => import('./pages/agenda/agenda.component').then(m => m.AgendaComponent) },
      { path: 'noticias', loadComponent: () => import('./pages/noticias/noticias.component').then(m => m.NoticiasComponent) },
      { path: 'jogos', loadComponent: () => import('./pages/jogos/jogos.component').then(m => m.JogosComponent) },
      { path: '', redirectTo: 'home', pathMatch: 'full' }
    ]
  }
];
