package com.tearoutine.backend.service;

import com.tearoutine.backend.model.Mapa;
import com.tearoutine.backend.repository.MapaRepository;
import org.springframework.stereotype.Service;


import java.util.List;


@Service
public class MapaService {
private final MapaRepository repo;
public MapaService(MapaRepository repo) { this.repo = repo; }
public List<Mapa> listar() { return repo.findAll(); }
public Mapa salvar(Mapa l) { return repo.save(l); }
}