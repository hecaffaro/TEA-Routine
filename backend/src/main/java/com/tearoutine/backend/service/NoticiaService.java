package com.tearoutine.backend.service;

import com.tearoutine.backend.model.Noticia;
import com.tearoutine.backend.repository.NoticiaRepository;
import org.springframework.stereotype.Service;


import java.util.List;


@Service
public class NoticiaService {
private final NoticiaRepository repo;
public NoticiaService(NoticiaRepository repo) { this.repo = repo; }
public List<Noticia> listar() { return repo.findAll(); }
public Noticia salvar(Noticia n) { return repo.save(n); }
}