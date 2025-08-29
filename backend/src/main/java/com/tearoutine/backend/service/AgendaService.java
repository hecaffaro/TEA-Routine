package com.tearoutine.backend.service;

import com.tearoutine.backend.model.Agenda;
import com.tearoutine.backend.repository.AgendaRepository;
import org.springframework.stereotype.Service;


import java.util.List;


@Service
public class AgendaService {
private final AgendaRepository repo;
public AgendaService(AgendaRepository repo) { this.repo = repo; }
public List<Agenda> listar() { return repo.findAll(); }
public Agenda salvar(Agenda e) { return repo.save(e); }
}