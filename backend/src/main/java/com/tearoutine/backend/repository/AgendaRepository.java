package com.tearoutine.backend.repository;

import com.tearoutine.backend.model.Agenda;
import org.springframework.data.jpa.repository.JpaRepository;


public interface AgendaRepository extends JpaRepository<Agenda, Long> {}