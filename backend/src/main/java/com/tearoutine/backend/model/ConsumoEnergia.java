package com.tearoutine.backend.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "consumo_energia")
public class ConsumoEnergia {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "usuario_id")
    private Usuario usuario;
    
    private String dispositivo;
    
    @Column(name = "consumo_kwh")
    private Double consumoKwh;
    
    private Double custo;
    
    @Column(name = "data_consumo")
    private LocalDate dataConsumo;
    
    @Column(name = "mes_ano")
    private String mesAno;
    
    // Constructors
    public ConsumoEnergia() {}
    
    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }
    
    public String getDispositivo() { return dispositivo; }
    public void setDispositivo(String dispositivo) { this.dispositivo = dispositivo; }
    
    public Double getConsumoKwh() { return consumoKwh; }
    public void setConsumoKwh(Double consumoKwh) { this.consumoKwh = consumoKwh; }
    
    public Double getCusto() { return custo; }
    public void setCusto(Double custo) { this.custo = custo; }
    
    public LocalDate getDataConsumo() { return dataConsumo; }
    public void setDataConsumo(LocalDate dataConsumo) { this.dataConsumo = dataConsumo; }
    
    public String getMesAno() { return mesAno; }
    public void setMesAno(String mesAno) { this.mesAno = mesAno; }
}