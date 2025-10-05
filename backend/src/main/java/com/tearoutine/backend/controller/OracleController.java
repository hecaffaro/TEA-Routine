package com.tearoutine.backend.controller;

import com.tearoutine.backend.service.OraclePlSqlService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.sql.Types;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

@Slf4j
@RestController
@RequestMapping("/api/oracle")
@CrossOrigin(origins = {"http://localhost:4200", "http://localhost:3000"})
public class OracleController {

    private static final Pattern SAFE_NAME_PATTERN = Pattern.compile("^[a-zA-Z_][a-zA-Z0-9_]*$");

    @Autowired
    private OraclePlSqlService oracleService;

    @PostMapping("/procedure/{name}")
    public ResponseEntity<Map<String, Object>> executeProcedure(
            @PathVariable String name,
            @RequestBody Map<String, Object> parameters) {
        
        if (!isValidName(name)) {
            log.warn("Tentativa de execução de procedure com nome inválido");
            return ResponseEntity.badRequest().body(Map.of("error", "Nome de procedure inválido"));
        }
        
        log.info("Executando procedure com {} parâmetros", parameters.size());
        Map<String, Object> result = oracleService.executeProcedure(name, parameters);
        return ResponseEntity.ok(result);
    }

    @PostMapping("/function/{name}")
    public ResponseEntity<Object> executeFunction(
            @PathVariable String name,
            @RequestBody Map<String, Object> request) {
        
        if (!isValidName(name)) {
            log.warn("Tentativa de execução de function com nome inválido");
            return ResponseEntity.badRequest().body(Map.of("error", "Nome de function inválido"));
        }
        
        Map<String, Object> parameters = (Map<String, Object>) request.getOrDefault("parameters", Map.of());
        Integer returnType = (Integer) request.getOrDefault("returnType", Types.VARCHAR);
        
        log.info("Executando function com {} parâmetros", parameters.size());
        Object result = oracleService.executeFunction(name, parameters, returnType);
        return ResponseEntity.ok(result);
    }

    @PostMapping("/query")
    public ResponseEntity<List<Map<String, Object>>> executeQuery(@RequestBody Map<String, Object> request) {
        String sql = (String) request.get("sql");
        
        if (sql == null || sql.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(List.of(Map.of("error", "SQL não pode estar vazio")));
        }
        
        if (!isValidQuery(sql)) {
            log.warn("Tentativa de execução de query perigosa");
            return ResponseEntity.badRequest().body(List.of(Map.of("error", "Query não permitida")));
        }
        
        Map<String, Object> parameters = (Map<String, Object>) request.getOrDefault("parameters", Map.of());
        
        log.info("Executando query com {} parâmetros", parameters.size());
        List<Map<String, Object>> results = oracleService.executeQuery(sql, parameters);
        return ResponseEntity.ok(results);
    }
    
    private boolean isValidName(String name) {
        return name != null && SAFE_NAME_PATTERN.matcher(name).matches() && name.length() <= 30;
    }
    
    private boolean isValidQuery(String sql) {
        if (sql == null || sql.trim().isEmpty()) return false;
        String upperSql = sql.toUpperCase().trim();
        return upperSql.startsWith("SELECT") && 
               !upperSql.matches(".*(DROP|DELETE|UPDATE|INSERT|ALTER|CREATE|EXEC|EXECUTE).*");
    }
}