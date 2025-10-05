-- Functions PL/SQL para Smart HAS

-- Function 1: Calcular consumo médio mensal por usuário
CREATE OR REPLACE FUNCTION FN_CONSUMO_MEDIO_USUARIO(p_usuario_id IN NUMBER)
RETURN NUMBER
IS
    v_consumo_medio NUMBER(10,2) := 0;
    v_count NUMBER := 0;
BEGIN
    -- Calcula consumo médio dos últimos 6 meses
    SELECT AVG(CONSUMO_KWH), COUNT(*)
    INTO v_consumo_medio, v_count
    FROM CONSUMO_ENERGIA
    WHERE USUARIO_ID = p_usuario_id
    AND DATA_CONSUMO >= ADD_MONTHS(SYSDATE, -6);
    
    -- Tratamento de exceção se não houver dados
    IF v_count = 0 THEN
        RETURN 0;
    END IF;
    
    RETURN NVL(v_consumo_medio, 0);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao calcular consumo médio: ' || SQLERRM);
        RETURN -1;
END FN_CONSUMO_MEDIO_USUARIO;
/

-- Function 2: Formatar relatório de sensor
CREATE OR REPLACE FUNCTION FN_RELATORIO_SENSOR(p_sensor_id IN NUMBER)
RETURN VARCHAR2
IS
    v_relatorio VARCHAR2(1000);
    v_sensor_nome VARCHAR2(50);
    v_sensor_tipo VARCHAR2(20);
    v_ultima_leitura NUMBER(10,2);
    v_data_leitura TIMESTAMP;
    v_total_leituras NUMBER;
BEGIN
    -- Busca informações do sensor
    SELECT s.NOME, s.TIPO
    INTO v_sensor_nome, v_sensor_tipo
    FROM SENSOR s
    WHERE s.ID = p_sensor_id;
    
    -- Busca última leitura
    SELECT ls.VALOR, ls.DATA_LEITURA
    INTO v_ultima_leitura, v_data_leitura
    FROM LEITURA_SENSOR ls
    WHERE ls.SENSOR_ID = p_sensor_id
    AND ls.DATA_LEITURA = (
        SELECT MAX(DATA_LEITURA) 
        FROM LEITURA_SENSOR 
        WHERE SENSOR_ID = p_sensor_id
    );
    
    -- Conta total de leituras
    SELECT COUNT(*)
    INTO v_total_leituras
    FROM LEITURA_SENSOR
    WHERE SENSOR_ID = p_sensor_id;
    
    -- Formata relatório
    v_relatorio := 'SENSOR: ' || v_sensor_nome || 
                   ' | TIPO: ' || v_sensor_tipo ||
                   ' | ÚLTIMA LEITURA: ' || v_ultima_leitura ||
                   ' | DATA: ' || TO_CHAR(v_data_leitura, 'DD/MM/YYYY HH24:MI') ||
                   ' | TOTAL LEITURAS: ' || v_total_leituras;
    
    RETURN v_relatorio;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Sensor não encontrado ou sem leituras';
    WHEN OTHERS THEN
        RETURN 'Erro ao gerar relatório: ' || SQLERRM;
END FN_RELATORIO_SENSOR;
/