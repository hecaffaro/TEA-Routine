package com.tearoutine.backend.service;

import com.tearoutine.backend.model.Usuario;
import com.tearoutine.backend.repository.UsuarioRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UsuarioService {

    private final UsuarioRepository repository;
    private final BCryptPasswordEncoder passwordEncoder;

    public UsuarioService(UsuarioRepository repository) {
        this.repository = repository;
        this.passwordEncoder = new BCryptPasswordEncoder();
    }

    public Optional<Usuario> autenticar(String email, String senhaDigitada) {
        if (email == null || senhaDigitada == null || email.isBlank() || senhaDigitada.isBlank()) {
            return Optional.empty();
        }

        Optional<Usuario> usuarioOpt = repository.findByEmail(email);

        if (usuarioOpt.isPresent()) {
            Usuario usuario = usuarioOpt.get();
            if (verificarSenha(senhaDigitada, usuario.getSenha())) {
                return Optional.of(usuario);
            }
        }

        return Optional.empty();
    }

    private boolean verificarSenha(String senhaDigitada, String senhaArmazenada) {
        return passwordEncoder.matches(senhaDigitada, senhaArmazenada);
    }

    public Usuario salvarUsuario(Usuario usuario) {
        String senhaCriptografada = passwordEncoder.encode(usuario.getSenha());
        usuario.setSenha(senhaCriptografada);
        return repository.save(usuario);
    }
}
