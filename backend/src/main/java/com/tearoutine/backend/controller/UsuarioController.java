package com.tearoutine.backend.controller;

import com.tearoutine.backend.model.Usuario;
import com.tearoutine.backend.repository.UsuarioRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/usuarios")
public class UsuarioController {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @PostMapping
    public ResponseEntity<?> criarUsuario(@RequestBody Usuario usuario) {
        try {
            if (usuario.getEmail() == null || usuario.getNome() == null) {
                return ResponseEntity.badRequest().body(Map.of("error", "Email e nome são obrigatórios"));
            }
            
            Usuario salvo = usuarioRepository.save(usuario);
            log.info("Usuário criado com sucesso");
            return ResponseEntity.ok(salvo);
        } catch (Exception e) {
            log.error("Erro ao salvar usuário: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("error", "Erro ao salvar usuário"));
        }
    }

    @GetMapping
    public ResponseEntity<List<Usuario>> listarUsuarios() {
        try {
            List<Usuario> usuarios = usuarioRepository.findAll();
            return ResponseEntity.ok(usuarios);
        } catch (Exception e) {
            log.error("Erro ao listar usuários: {}", e.getMessage());
            return ResponseEntity.internalServerError().build();
        }
    }
}
