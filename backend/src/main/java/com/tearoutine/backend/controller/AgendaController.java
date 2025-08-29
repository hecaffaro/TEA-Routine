package com.tearoutine.backend.controller;

import com.tearoutine.backend.model.Agenda;
import com.tearoutine.backend.repository.AgendaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/agenda")
public class AgendaController {

    @Autowired
    private AgendaRepository agendaRepository;

    @PostMapping
    public ResponseEntity<Agenda> criarEvento(@RequestBody Agenda agenda) {
        Agenda salvo = agendaRepository.save(agenda);
        return ResponseEntity.status(HttpStatus.CREATED).body(salvo);
    }

    @GetMapping
    public List<Agenda> listarEventos() {
        return agendaRepository.findAll();
    }
}
