package com.tearoutine.backend.controller;

import com.tearoutine.backend.model.Noticia;
import com.tearoutine.backend.service.NoticiaService;
import org.springframework.web.bind.annotation.*;


import java.util.List;


@RestController
@RequestMapping("/api/noticias")
public class NoticiaController {
private final NoticiaService service;
public NoticiaController(NoticiaService service) { this.service = service; }


@GetMapping
public List<Noticia> listar() { return service.listar(); }


@PostMapping
public Noticia criar(@RequestBody Noticia noticia) { return service.salvar(noticia); }
}