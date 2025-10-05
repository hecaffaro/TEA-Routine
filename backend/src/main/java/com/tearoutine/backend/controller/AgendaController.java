package com.tearoutine.backend.controller;

import com.tearoutine.backend.model.Agenda;
import com.tearoutine.backend.repository.AgendaRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/agenda")
public class AgendaController {

    @Autowired
    private AgendaRepository agendaRepository;

    @PostMapping
    public ResponseEntity<?> criarEvento(@RequestBody Agenda agenda) {
        try {
            Agenda salvo = agendaRepository.save(agenda);
            log.info("Evento criado com sucesso");
            return ResponseEntity.status(HttpStatus.CREATED).body(salvo);
        } catch (Exception e) {
            log.error("Erro ao criar evento: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("error", "Erro ao criar evento"));
        }
    }

    @GetMapping
    public ResponseEntity<List<Agenda>> listarEventos() {
        try {
            List<Agenda> eventos = agendaRepository.findAll();
            return ResponseEntity.ok(eventos);
        } catch (Exception e) {
            log.error("Erro ao listar eventos: {}", e.getMessage());
            return ResponseEntity.internalServerError().build();
        }
    }
}
