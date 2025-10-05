package com.tearoutine.backend.controller;

import com.tearoutine.backend.service.OraclePlSqlService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/smarthas")
@CrossOrigin(origins = {"http://localhost:4200", "http://localhost:3000"})
public class SmartHasController {

    @Autowired
    private OraclePlSqlService oracleService;

    @PostMapping("/alertas/processar")
    public ResponseEntity<Map<String, Object>> processarAlertas() {
        Map<String, Object> result = oracleService.executeProcedure("SP_PROCESSAR_ALERTAS_CRITICOS", Map.of());
        return ResponseEntity.ok(result);
    }

    @PostMapping("/relatorio/consumo/{usuarioId}")
    public ResponseEntity<Map<String, Object>> relatorioConsumo(
            @PathVariable Long usuarioId,
            @RequestParam(required = false) String mesAno) {
        
        Map<String, Object> params = Map.of(
            "p_usuario_id", usuarioId,
            "p_mes_ano", mesAno != null ? mesAno : ""
        );
        
        Map<String, Object> result = oracleService.executeProcedure("SP_RELATORIO_CONSUMO_USUARIO", params);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/consumo/medio/{usuarioId}")
    public ResponseEntity<?> consumoMedio(@PathVariable Long usuarioId) {
        try {
            Object result = oracleService.executeFunction("FN_CONSUMO_MEDIO_USUARIO", 
                Map.of("p_usuario_id", usuarioId), java.sql.Types.NUMERIC);
            return ResponseEntity.ok(((Number) result).doubleValue());
        } catch (Exception e) {
            log.error("Erro ao calcular consumo médio: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("error", "Erro ao calcular consumo"));
        }
    }

    @GetMapping("/sensor/relatorio/{sensorId}")
    public ResponseEntity<?> relatorioSensor(@PathVariable Long sensorId) {
        try {
            Object result = oracleService.executeFunction("FN_RELATORIO_SENSOR", 
                Map.of("p_sensor_id", sensorId), java.sql.Types.VARCHAR);
            return ResponseEntity.ok(Map.of("relatorio", (String) result));
        } catch (Exception e) {
            log.error("Erro ao gerar relatório do sensor: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("error", "Erro ao gerar relatório"));
        }
    }

    @GetMapping("/alertas/pendentes")
    public ResponseEntity<List<Map<String, Object>>> alertasPendentes() {
        String sql = """
            SELECT a.ID, a.TIPO, a.MENSAGEM, a.CRITICIDADE, a.DATA_ALERTA,
                   s.NOME as SENSOR_NOME, s.LOCALIZACAO
            FROM ALERTA a
            JOIN SENSOR s ON a.SENSOR_ID = s.ID
            WHERE a.STATUS = 'PENDENTE'
            ORDER BY a.DATA_ALERTA DESC
            """;
        
        List<Map<String, Object>> alertas = oracleService.executeQuery(sql, Map.of());
        return ResponseEntity.ok(alertas);
    }
}