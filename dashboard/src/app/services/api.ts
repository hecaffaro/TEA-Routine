import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class ApiService {
  private readonly baseUrl = 'http://localhost:8080/api';

  constructor(private http: HttpClient) {}

  private getAuthHeaders(): HttpHeaders {
    const token = localStorage.getItem('token'); // ou sessionStorage, dependendo de onde você guarda
    return new HttpHeaders({
      'Authorization': `Bearer ${token ?? ''}`,
      'Content-Type': 'application/json'
    });
  }

  getAgenda(): Observable<any[]> {
    return this.http.get<any[]>(`${this.baseUrl}/agenda`, {
      headers: this.getAuthHeaders()
    });
  }

  getNoticias(): Observable<any[]> {
    return this.http.get<any[]>(`${this.baseUrl}/noticias`, {
      headers: this.getAuthHeaders()
    });
  }

  getJogos(): Observable<any[]> {
    return this.http.get<any[]>(`${this.baseUrl}/jogos`, {
      headers: this.getAuthHeaders()
    });
  }

  getUsuarios(): Observable<any[]> {
    return this.http.get<any[]>(`${this.baseUrl}/usuarios`, {
      headers: this.getAuthHeaders()
    });
  }

createUsuario(usuario: any): Observable<any> {
  return this.http.post<any>(`${this.baseUrl}/usuarios`, usuario, {
    headers: this.getAuthHeaders()
  });
}

}
