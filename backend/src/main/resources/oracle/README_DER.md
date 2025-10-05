# Smart HAS - Modelo de Dados Oracle

## Diagrama Entidade-Relacionamento (DER)

```
┌─────────────┐       ┌─────────────┐       ┌─────────────┐
│   USUARIO   │       │   SENSOR    │       │ LEITURA_    │
│             │       │             │       │  SENSOR     │
│ ID (PK)     │       │ ID (PK)     │       │             │
│ EMAIL       │       │ NOME        │       │ ID (PK)     │
│ SENHA       │       │ TIPO        │       │ SENSOR_ID   │──┐
│ NOME        │       │ LOCALIZACAO │       │ VALOR       │  │
│ DATA_CADAST │       │ STATUS      │       │ UNIDADE     │  │
└─────────────┘       │ DATA_INSTAL │       │ DATA_LEITURA│  │
       │              └─────────────┘       └─────────────┘  │
       │                     │                              │
       │                     └──────────────────────────────┘
       │
       │              ┌─────────────┐       ┌─────────────┐
       │              │   ALERTA    │       │  CONSUMO_   │
       │              │             │       │  ENERGIA    │
       │              │ ID (PK)     │       │             │
       └──────────────│ SENSOR_ID   │       │ ID (PK)     │
                      │ USUARIO_ID  │───────│ USUARIO_ID  │
                      │ TIPO        │       │ DISPOSITIVO │
                      │ MENSAGEM    │       │ CONSUMO_KWH │
                      │ CRITICIDADE │       │ CUSTO       │
                      │ DATA_ALERTA │       │ DATA_CONSUMO│
                      │ STATUS      │       │ MES_ANO     │
                      └─────────────┘       └─────────────┘
```

## Tabelas e Relacionamentos

### USUARIO
- **Chave Primária**: ID
- **Campos**: EMAIL (único), SENHA, NOME, DATA_CADASTRO
- **Relacionamentos**: 1:N com ALERTA, 1:N com CONSUMO_ENERGIA

### SENSOR
- **Chave Primária**: ID
- **Campos**: NOME, TIPO, LOCALIZACAO, STATUS, DATA_INSTALACAO
- **Tipos**: TEMPERATURA, UMIDADE, MOVIMENTO, LUZ
- **Relacionamentos**: 1:N com LEITURA_SENSOR, 1:N com ALERTA

### LEITURA_SENSOR
- **Chave Primária**: ID
- **Chave Estrangeira**: SENSOR_ID → SENSOR(ID)
- **Campos**: VALOR, UNIDADE, DATA_LEITURA

### ALERTA
- **Chave Primária**: ID
- **Chaves Estrangeiras**: 
  - SENSOR_ID → SENSOR(ID)
  - USUARIO_ID → USUARIO(ID)
- **Campos**: TIPO, MENSAGEM, CRITICIDADE, DATA_ALERTA, STATUS

### CONSUMO_ENERGIA
- **Chave Primária**: ID
- **Chave Estrangeira**: USUARIO_ID → USUARIO(ID)
- **Campos**: DISPOSITIVO, CONSUMO_KWH, CUSTO, DATA_CONSUMO, MES_ANO

## Functions Implementadas

### FN_CONSUMO_MEDIO_USUARIO(p_usuario_id)
- **Propósito**: Calcula consumo médio de energia dos últimos 6 meses
- **Retorno**: NUMBER - Consumo médio em kWh
- **Tratamento**: Exceções para dados não encontrados

### FN_RELATORIO_SENSOR(p_sensor_id)
- **Propósito**: Formata relatório completo de um sensor
- **Retorno**: VARCHAR2 - Relatório formatado
- **Inclui**: Nome, tipo, última leitura, total de leituras

## Procedures Implementadas

### SP_PROCESSAR_ALERTAS_CRITICOS
- **Propósito**: Processa leituras críticas e gera alertas automáticos
- **Lógica**: 
  - Temperatura > 35°C ou < 10°C
  - Umidade > 80% ou < 30%
  - Detecção de movimento
- **Recursos**: CURSOR, LOOP, tratamento de exceções

### SP_RELATORIO_CONSUMO_USUARIO(p_usuario_id, p_mes_ano)
- **Propósito**: Gera relatório detalhado de consumo energético
- **Saída**: DBMS_OUTPUT com relatório formatado
- **Recursos**: CURSOR, formatação de dados, cálculos agregados

## Endpoints REST Integrados

- `POST /api/smarthas/alertas/processar` - Executa SP_PROCESSAR_ALERTAS_CRITICOS
- `POST /api/smarthas/relatorio/consumo/{usuarioId}` - Executa SP_RELATORIO_CONSUMO_USUARIO
- `GET /api/smarthas/consumo/medio/{usuarioId}` - Executa FN_CONSUMO_MEDIO_USUARIO
- `GET /api/smarthas/sensor/relatorio/{sensorId}` - Executa FN_RELATORIO_SENSOR
- `GET /api/smarthas/alertas/pendentes` - Query direta para alertas pendentes