# Documentação Oracle - Smart HAS (TEARoutine)

## 📊 Diagrama Entidade-Relacionamento (DER)

```
┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
│     USUARIO     │       │     SENSOR      │       │ LEITURA_SENSOR  │
├─────────────────┤       ├─────────────────┤       ├─────────────────┤
│ ID (PK)         │       │ ID (PK)         │       │ ID (PK)         │
│ EMAIL (UNIQUE)  │       │ NOME            │       │ SENSOR_ID (FK)  │
│ SENHA           │       │ TIPO            │       │ VALOR           │
│ NOME            │       │ LOCALIZACAO     │       │ UNIDADE         │
│ DATA_CADASTRO   │       │ STATUS          │       │ DATA_LEITURA    │
└─────────────────┘       │ DATA_INSTALACAO │       └─────────────────┘
         │                └─────────────────┘                │
         │                         │                         │
         │                         └─────────────────────────┘
         │
         │                ┌─────────────────┐
         │                │     ALERTA      │
         │                ├─────────────────┤
         │                │ ID (PK)         │
         └────────────────│ USUARIO_ID (FK) │
                          │ SENSOR_ID (FK)  │
                          │ TIPO            │
                          │ MENSAGEM        │
                          │ CRITICIDADE     │
                          │ DATA_ALERTA     │
                          │ STATUS          │
                          └─────────────────┘
         │
         │                ┌─────────────────┐
         │                │ CONSUMO_ENERGIA │
         │                ├─────────────────┤
         │                │ ID (PK)         │
         └────────────────│ USUARIO_ID (FK) │
                          │ DISPOSITIVO     │
                          │ CONSUMO_KWH     │
                          │ CUSTO           │
                          │ DATA_CONSUMO    │
                          │ MES_ANO         │
                          └─────────────────┘
```

## 🗃️ Estrutura das Tabelas

### 1. USUARIO
**Propósito**: Armazena dados dos usuários do sistema
```sql
ID              NUMBER          -- Chave primária (auto-incremento)
EMAIL           VARCHAR2(100)   -- Email único do usuário
SENHA           VARCHAR2(255)   -- Senha criptografada
NOME            VARCHAR2(100)   -- Nome completo
DATA_CADASTRO   DATE           -- Data de criação (padrão: SYSDATE)
```

### 2. SENSOR
**Propósito**: Cadastro dos sensores IoT instalados
```sql
ID                NUMBER          -- Chave primária (auto-incremento)
NOME              VARCHAR2(50)    -- Nome identificador do sensor
TIPO              VARCHAR2(20)    -- TEMPERATURA, UMIDADE, MOVIMENTO, LUZ
LOCALIZACAO       VARCHAR2(50)    -- Local de instalação
STATUS            VARCHAR2(10)    -- ATIVO, INATIVO, MANUTENCAO (padrão: ATIVO)
DATA_INSTALACAO   DATE           -- Data de instalação (padrão: SYSDATE)
```

### 3. LEITURA_SENSOR
**Propósito**: Histórico de leituras dos sensores
```sql
ID             NUMBER          -- Chave primária (auto-incremento)
SENSOR_ID      NUMBER          -- FK para SENSOR
VALOR          NUMBER(10,2)    -- Valor medido pelo sensor
UNIDADE        VARCHAR2(10)    -- Unidade de medida (°C, %, lux, bool)
DATA_LEITURA   TIMESTAMP       -- Timestamp da leitura (padrão: CURRENT_TIMESTAMP)
```

### 4. ALERTA
**Propósito**: Sistema de alertas baseado em leituras críticas
```sql
ID            NUMBER          -- Chave primária (auto-incremento)
SENSOR_ID     NUMBER          -- FK para SENSOR
USUARIO_ID    NUMBER          -- FK para USUARIO
TIPO          VARCHAR2(20)    -- Tipo do alerta
MENSAGEM      VARCHAR2(500)   -- Mensagem descritiva
CRITICIDADE   VARCHAR2(10)    -- BAIXA, MEDIA, ALTA (padrão: MEDIA)
DATA_ALERTA   TIMESTAMP       -- Timestamp do alerta (padrão: CURRENT_TIMESTAMP)
STATUS        VARCHAR2(15)    -- PENDENTE, LIDO, RESOLVIDO (padrão: PENDENTE)
```

### 5. CONSUMO_ENERGIA
**Propósito**: Controle de consumo energético por dispositivo
```sql
ID             NUMBER          -- Chave primária (auto-incremento)
USUARIO_ID     NUMBER          -- FK para USUARIO
DISPOSITIVO    VARCHAR2(50)    -- Nome do dispositivo
CONSUMO_KWH    NUMBER(10,3)    -- Consumo em kWh
CUSTO          NUMBER(10,2)    -- Custo em reais
DATA_CONSUMO   DATE           -- Data do consumo
MES_ANO        VARCHAR2(7)     -- Formato MM/YYYY para agrupamento
```

## 🔧 Functions PL/SQL

### 1. FN_CONSUMO_MEDIO_USUARIO
**Propósito**: Calcula o consumo médio mensal de energia por usuário

**Parâmetros**:
- `p_usuario_id`: ID do usuário

**Retorno**: NUMBER (consumo médio em kWh)

**Funcionamento**:
1. Busca registros de consumo dos últimos 6 meses
2. Calcula a média de consumo em kWh
3. Retorna 0 se não houver dados
4. Retorna -1 em caso de erro

**Uso**:
```sql
SELECT FN_CONSUMO_MEDIO_USUARIO(1) FROM DUAL;
```

### 2. FN_RELATORIO_SENSOR
**Propósito**: Gera relatório formatado de um sensor específico

**Parâmetros**:
- `p_sensor_id`: ID do sensor

**Retorno**: VARCHAR2 (relatório formatado)

**Funcionamento**:
1. Busca informações básicas do sensor
2. Obtém a última leitura registrada
3. Conta o total de leituras históricas
4. Formata tudo em uma string legível

**Formato do Retorno**:
```
SENSOR: [nome] | TIPO: [tipo] | ÚLTIMA LEITURA: [valor] | DATA: [data] | TOTAL LEITURAS: [count]
```

**Uso**:
```sql
SELECT FN_RELATORIO_SENSOR(1) FROM DUAL;
```

## 🔄 Procedures PL/SQL

### 1. SP_PROCESSAR_ALERTAS_CRITICOS
**Propósito**: Processa automaticamente leituras críticas e gera alertas

**Parâmetros**: Nenhum

**Funcionamento**:
1. **Busca leituras críticas** da última hora:
   - Temperatura > 35°C ou < 10°C
   - Umidade > 80% ou < 30%
   - Movimento detectado (valor = 1)

2. **Determina criticidade**:
   - Temperatura alta: ALTA
   - Temperatura baixa: MEDIA
   - Umidade alta: MEDIA
   - Umidade baixa: BAIXA
   - Movimento: BAIXA

3. **Evita duplicatas**: Verifica se já existe alerta similar nas últimas 2 horas

4. **Cria alertas**: Insere alerta para todos os usuários ativos

**Uso**:
```sql
EXEC SP_PROCESSAR_ALERTAS_CRITICOS;
```

**Saída**: Número de alertas processados via DBMS_OUTPUT

### 2. SP_RELATORIO_CONSUMO_USUARIO
**Propósito**: Gera relatório detalhado de consumo energético por usuário

**Parâmetros**:
- `p_usuario_id`: ID do usuário (obrigatório)
- `p_mes_ano`: Período no formato MM/YYYY (opcional, padrão: mês atual)

**Funcionamento**:
1. Valida se o usuário existe
2. Define o período (atual se não especificado)
3. Lista todos os dispositivos e consumos
4. Calcula totais e médias
5. Formata saída em tabela legível

**Formato da Saída**:
```
=== RELATÓRIO DE CONSUMO ENERGÉTICO ===
Usuário: [nome]
Período: [MM/YYYY]
----------------------------------------
[Dispositivo]        | [kWh] | [Custo] | [Data]
----------------------------------------
TOTAL: [total_kwh] kWh | R$ [total_custo]
MÉDIA: [media_kwh] kWh por dispositivo
```

**Uso**:
```sql
EXEC SP_RELATORIO_CONSUMO_USUARIO(1, '12/2024');
EXEC SP_RELATORIO_CONSUMO_USUARIO(1); -- mês atual
```

### 3. SP_PROCESSAR_ALERTAS_USUARIO (Melhorada)
**Propósito**: Versão melhorada que permite especificar usuário alvo

**Parâmetros**:
- `p_usuario_id`: ID do usuário alvo (opcional, padrão: todos)

**Funcionamento**: Similar à SP_PROCESSAR_ALERTAS_CRITICOS, mas permite direcionar alertas para usuário específico

## 🔐 Segurança e Constraints

### Constraints Implementadas:
```sql
-- Validação de tipos de sensor
ALTER TABLE SENSOR ADD CONSTRAINT CHK_SENSOR_TIPO 
    CHECK (TIPO IN ('TEMPERATURA', 'UMIDADE', 'MOVIMENTO', 'LUZ'));

-- Validação de status do sensor
ALTER TABLE SENSOR ADD CONSTRAINT CHK_SENSOR_STATUS 
    CHECK (STATUS IN ('ATIVO', 'INATIVO', 'MANUTENCAO'));

-- Validação de criticidade de alerta
ALTER TABLE ALERTA ADD CONSTRAINT CHK_ALERTA_CRITICIDADE 
    CHECK (CRITICIDADE IN ('BAIXA', 'MEDIA', 'ALTA'));

-- Validação de status de alerta
ALTER TABLE ALERTA ADD CONSTRAINT CHK_ALERTA_STATUS 
    CHECK (STATUS IN ('PENDENTE', 'LIDO', 'RESOLVIDO'));
```

### Índices para Performance:
```sql
CREATE INDEX IDX_LEITURA_SENSOR_DATA ON LEITURA_SENSOR(DATA_LEITURA);
CREATE INDEX IDX_ALERTA_STATUS ON ALERTA(STATUS, DATA_ALERTA);
CREATE INDEX IDX_CONSUMO_USUARIO_DATA ON CONSUMO_ENERGIA(USUARIO_ID, DATA_CONSUMO);
```

## 🚀 Integração com Spring Boot

### Endpoints Disponíveis:
- `POST /api/oracle/procedure/SP_PROCESSAR_ALERTAS_CRITICOS`
- `POST /api/oracle/function/FN_CONSUMO_MEDIO_USUARIO`
- `POST /api/oracle/function/FN_RELATORIO_SENSOR`
- `POST /api/smarthas/relatorio/consumo/{usuarioId}`

### Exemplo de Uso via API:
```bash
# Processar alertas
curl -X POST http://localhost:8080/api/oracle/procedure/SP_PROCESSAR_ALERTAS_CRITICOS

# Consumo médio
curl -X POST http://localhost:8080/api/oracle/function/FN_CONSUMO_MEDIO_USUARIO \
  -H "Content-Type: application/json" \
  -d '{"parameters": {"p_usuario_id": 1}, "returnType": 3}'
```

## 📈 Casos de Uso

1. **Monitoramento Automático**: SP_PROCESSAR_ALERTAS_CRITICOS roda periodicamente
2. **Relatórios de Consumo**: Usuários consultam gastos mensais
3. **Dashboard de Sensores**: FN_RELATORIO_SENSOR alimenta interface
4. **Análise de Eficiência**: FN_CONSUMO_MEDIO_USUARIO para comparações

Esta estrutura suporta um sistema completo de automação residencial com monitoramento em tempo real e geração de relatórios!