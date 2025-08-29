package com.tearoutine.backend.model;

import jakarta.persistence.*;


@Entity
public class Mapa {
@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
private Long id;


private String nome;
private String descricao;
private Double latitude;
private Double longitude;


public Mapa() {}


// getters/setters
public Long getId() { return id; }
public void setId(Long id) { this.id = id; }
public String getNome() { return nome; }
public void setNome(String nome) { this.nome = nome; }
public String getDescricao() { return descricao; }
public void setDescricao(String descricao) { this.descricao = descricao; }
public Double getLatitude() { return latitude; }
public void setLatitude(Double latitude) { this.latitude = latitude; }
public Double getLongitude() { return longitude; }
public void setLongitude(Double longitude) { this.longitude = longitude; }
}