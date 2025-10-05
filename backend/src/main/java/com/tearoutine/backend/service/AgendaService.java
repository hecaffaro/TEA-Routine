package com.tearoutine.backend.service;

import com.tearoutine.backend.model.Agenda;
import com.tearoutine.backend.repository.AgendaRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
public class AgendaService {
    private final AgendaRepository repository;
    
    public AgendaService(AgendaRepository repository) { 
        this.repository = repository; 
    }
    
    public List<Agenda> listar() { 
        try {
            return repository.findAll();
        } catch (Exception e) {
            log.error("Erro ao listar agenda: {}", e.getMessage());
            throw new RuntimeException("Erro ao listar eventos", e);
        }
    }
    
    public Agenda salvar(Agenda agenda) { 
        try {
            return repository.save(agenda);
        } catch (Exception e) {
            log.error("Erro ao salvar agenda: {}", e.getMessage());
            throw new RuntimeException("Erro ao salvar evento", e);
        }
    }
}