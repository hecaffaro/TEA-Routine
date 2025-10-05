package com.tearoutine.backend.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import javax.sql.DataSource;
import java.sql.*;
import java.sql.Date;
import java.util.*;

@Slf4j
@Service
public class OraclePlSqlService {

    @Autowired
    private DataSource dataSource;

    public Map<String, Object> executeProcedure(String procedureName, Map<String, Object> parameters) {
        Map<String, Object> result = new HashMap<>();
        
        if (!isValidProcedureName(procedureName)) {
            log.error("Nome de procedure inválido");
            result.put("success", false);
            result.put("error", "Nome de procedure inválido");
            return result;
        }
        
        try (Connection connection = dataSource.getConnection()) {
            StringBuilder sql = new StringBuilder("{call ");
            sql.append(procedureName).append("(");
            
            if (!parameters.isEmpty()) {
                String placeholders = String.join(",", Collections.nCopies(parameters.size(), "?"));
                sql.append(placeholders);
            }
            sql.append(")}");
            
            log.debug("Executando procedure: {}", sql.toString());
            
            try (CallableStatement statement = connection.prepareCall(sql.toString())) {
                int paramIndex = 1;
                for (Map.Entry<String, Object> param : parameters.entrySet()) {
                    setParameterSafely(statement, paramIndex++, param.getValue());
                }
                
                statement.execute();
                result.put("success", true);
                result.put("message", "Procedure executada com sucesso");
                log.info("Procedure {} executada com sucesso", procedureName);
                
            }
        } catch (SQLException e) {
            log.error("Erro ao executar procedure {}: {}", procedureName, e.getMessage());
            result.put("success", false);
            result.put("error", "Erro na execução: " + e.getMessage());
        }
        
        return result;
    }

    public Object executeFunction(String functionName, Map<String, Object> parameters, int returnType) {
        if (!isValidProcedureName(functionName)) {
            log.error("Nome de function inválido");
            throw new IllegalArgumentException("Nome de function inválido");
        }
        
        try (Connection connection = dataSource.getConnection()) {
            StringBuilder sql = new StringBuilder("{? = call ");
            sql.append(functionName).append("(");
            
            if (!parameters.isEmpty()) {
                String placeholders = String.join(",", Collections.nCopies(parameters.size(), "?"));
                sql.append(placeholders);
            }
            sql.append(")}");
            
            log.debug("Executando function: {}", sql.toString());
            
            try (CallableStatement statement = connection.prepareCall(sql.toString())) {
                statement.registerOutParameter(1, returnType);
                
                int paramIndex = 2;
                for (Object value : parameters.values()) {
                    setParameterSafely(statement, paramIndex++, value);
                }
                
                statement.execute();
                Object result = statement.getObject(1);
                log.info("Function {} executada com sucesso", functionName);
                return result;
            }
        } catch (SQLException e) {
            log.error("Erro ao executar function {}: {}", functionName, e.getMessage());
            throw new RuntimeException("Erro ao executar function: " + e.getMessage(), e);
        }
    }

    public List<Map<String, Object>> executeQuery(String sql, Map<String, Object> parameters) {
        List<Map<String, Object>> results = new ArrayList<>();
        
        try (Connection connection = dataSource.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            log.debug("Executando query com {} parâmetros", parameters.size());
            
            int paramIndex = 1;
            for (Object value : parameters.values()) {
                setParameterSafely(statement, paramIndex++, value);
            }
            
            try (ResultSet resultSet = statement.executeQuery()) {
                ResultSetMetaData metaData = resultSet.getMetaData();
                int columnCount = metaData.getColumnCount();
                
                while (resultSet.next()) {
                    Map<String, Object> row = new HashMap<>();
                    for (int i = 1; i <= columnCount; i++) {
                        String columnName = metaData.getColumnName(i);
                        Object value = resultSet.getObject(i);
                        row.put(columnName, value);
                    }
                    results.add(row);
                }
            }
            
            log.info("Query executada com sucesso, {} registros retornados", results.size());
            
        } catch (SQLException e) {
            log.error("Erro ao executar query: {}", e.getMessage());
            throw new RuntimeException("Erro ao executar query: " + e.getMessage(), e);
        }
        
        return results;
    }
    
    private void setParameterSafely(PreparedStatement statement, int index, Object value) throws SQLException {
        if (value == null) {
            statement.setNull(index, Types.NULL);
        } else if (value instanceof String) {
            statement.setString(index, (String) value);
        } else if (value instanceof Integer) {
            statement.setInt(index, (Integer) value);
        } else if (value instanceof Long) {
            statement.setLong(index, (Long) value);
        } else if (value instanceof Double) {
            statement.setDouble(index, (Double) value);
        } else if (value instanceof Boolean) {
            statement.setBoolean(index, (Boolean) value);
        } else if (value instanceof Date) {
            statement.setDate(index, new java.sql.Date(((Date) value).getTime()));
        } else {
            statement.setObject(index, value);
        }
    }
    
    private boolean isValidProcedureName(String name) {
        return name != null && name.matches("^[a-zA-Z_][a-zA-Z0-9_]*$") && name.length() <= 30;
    }
}