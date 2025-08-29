package com.tearoutine.backend.service;

import com.tearoutine.backend.model.Jogo;
import com.tearoutine.backend.repository.JogoRepository;
import org.springframework.stereotype.Service;


import java.util.List;


@Service
public class JogoService {
private final JogoRepository repo;
public JogoService(JogoRepository repo) { this.repo = repo; }
public List<Jogo> listar() { return repo.findAll(); }
public Jogo salvar(Jogo j) { return repo.save(j); }
}