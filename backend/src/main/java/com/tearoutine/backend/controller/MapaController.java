package com.tearoutine.backend.controller;

import com.tearoutine.backend.model.Mapa;
import com.tearoutine.backend.service.MapaService;
import org.springframework.web.bind.annotation.*;


import java.util.List;


@RestController
@RequestMapping("/api/mapa")
public class MapaController {
private final MapaService service;
public MapaController(MapaService service) { this.service = service; }


@GetMapping
public List<Mapa> listar() { return service.listar(); }


@PostMapping
public Mapa criar(@RequestBody Mapa l) { return service.salvar(l); }
}