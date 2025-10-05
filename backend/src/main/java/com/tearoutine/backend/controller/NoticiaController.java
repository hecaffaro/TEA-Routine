package com.tearoutine.backend.controller;

import com.tearoutine.backend.model.Noticia;
import com.tearoutine.backend.service.NoticiaService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/noticias")
public class NoticiaController {
    private final NoticiaService service;
    
    public NoticiaController(NoticiaService service) { 
        this.service = service; 
    }

    @GetMapping
    public ResponseEntity<List<Noticia>> listar() {
        try {
            List<Noticia> noticias = service.listar();
            return ResponseEntity.ok(noticias);
        } catch (Exception e) {
            log.error("Erro ao listar notícias: {}", e.getMessage());
            return ResponseEntity.internalServerError().build();
        }
    }

    @PostMapping
    public ResponseEntity<?> criar(@RequestBody Noticia noticia) {
        try {
            Noticia salva = service.salvar(noticia);
            log.info("Notícia criada com sucesso");
            return ResponseEntity.ok(salva);
        } catch (Exception e) {
            log.error("Erro ao criar notícia: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("error", "Erro ao criar notícia"));
        }
    }
}