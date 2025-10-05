import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class SecurityService {

  sanitizeInput(input: string): string {
    if (!input) return '';
    
    return input
      .replace(/[<>]/g, '')
      .replace(/javascript:/gi, '')
      .replace(/on\w+=/gi, '')
      .trim();
  }

  isValidEmail(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  generateCSRFToken(): string {
    return Math.random().toString(36).substring(2) + Date.now().toString(36);
  }

  setSecureToken(token: string): void {
    sessionStorage.setItem('token', token);
    sessionStorage.setItem('tokenTime', Date.now().toString());
  }

  getToken(): string | null {
    const token = sessionStorage.getItem('token');
    const tokenTime = sessionStorage.getItem('tokenTime');
    
    if (!token || !tokenTime) return null;
    
    const now = Date.now();
    const tokenAge = now - parseInt(tokenTime);
    const maxAge = 24 * 60 * 60 * 1000; // 24 horas
    
    if (tokenAge > maxAge) {
      this.clearToken();
      return null;
    }
    
    return token;
  }

  clearToken(): void {
    sessionStorage.removeItem('token');
    sessionStorage.removeItem('tokenTime');
  }
}