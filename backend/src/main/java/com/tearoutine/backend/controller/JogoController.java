package com.tearoutine.backend.controller;

import com.tearoutine.backend.model.Jogo;
import com.tearoutine.backend.service.JogoService;
import org.springframework.web.bind.annotation.*;


import java.util.List;


@RestController
@RequestMapping("/api/jogos")
public class JogoController {
private final JogoService service;
public JogoController(JogoService service) { this.service = service; }


@GetMapping
public List<Jogo> listar() { return service.listar(); }


@PostMapping
public Jogo criar(@RequestBody Jogo j) { return service.salvar(j); }
}