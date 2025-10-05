import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError, retry } from 'rxjs/operators';

@Injectable({ providedIn: 'root' })
export class ApiService {
  private readonly baseUrl = 'http://localhost:8080/api';

  constructor(private http: HttpClient) {}

  private getAuthHeaders(): HttpHeaders {
    const token = sessionStorage.getItem('token');
    const headers: any = {
      'Content-Type': 'application/json'
    };
    
    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }
    
    return new HttpHeaders(headers);
  }
  
  private handleError(error: HttpErrorResponse): Observable<never> {
    let errorMessage = 'Erro desconhecido';
    
    if (error.error instanceof ErrorEvent) {
      errorMessage = `Erro: ${error.error.message}`;
    } else {
      errorMessage = `Código: ${error.status}, Mensagem: ${error.message}`;
    }
    
    console.error('Erro na API:', errorMessage);
    return throwError(() => errorMessage);
  }

  getAgenda(): Observable<any[]> {
    return this.http.get<any[]>(`${this.baseUrl}/agenda`, {
      headers: this.getAuthHeaders()
    }).pipe(
      retry(2),
      catchError(this.handleError)
    );
  }

  getNoticias(): Observable<any[]> {
    return this.http.get<any[]>(`${this.baseUrl}/noticias`, {
      headers: this.getAuthHeaders()
    }).pipe(
      retry(2),
      catchError(this.handleError)
    );
  }

  getJogos(): Observable<any[]> {
    return this.http.get<any[]>(`${this.baseUrl}/jogos`, {
      headers: this.getAuthHeaders()
    }).pipe(
      retry(2),
      catchError(this.handleError)
    );
  }

  getUsuarios(): Observable<any[]> {
    return this.http.get<any[]>(`${this.baseUrl}/usuarios`, {
      headers: this.getAuthHeaders()
    }).pipe(
      retry(2),
      catchError(this.handleError)
    );
  }

  createUsuario(usuario: any): Observable<any> {
    return this.http.post<any>(`${this.baseUrl}/usuarios`, usuario, {
      headers: this.getAuthHeaders()
    }).pipe(
      catchError(this.handleError)
    );
  }

}
