package com.tearoutine.backend.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;


@Entity
public class Noticia {
@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
private Long id;


private String titulo;


@Column(length = 5000)
private String conteudo;


private LocalDateTime criadaEm = LocalDateTime.now();


public Noticia() {}


// getters / setters
public Long getId() { return id; }
public void setId(Long id) { this.id = id; }
public String getTitulo() { return titulo; }
public void setTitulo(String titulo) { this.titulo = titulo; }
public String getConteudo() { return conteudo; }
public void setConteudo(String conteudo) { this.conteudo = conteudo; }
public LocalDateTime getCriadaEm() { return criadaEm; }
public void setCriadaEm(LocalDateTime criadaEm) { this.criadaEm = criadaEm; }
}