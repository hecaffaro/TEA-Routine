-- Procedures PL/SQL para Smart HAS

-- Procedure 1: Registrar alertas baseados em leituras críticas
CREATE OR REPLACE PROCEDURE SP_PROCESSAR_ALERTAS_CRITICOS
IS
    CURSOR c_leituras_criticas IS
        SELECT ls.ID, ls.SENSOR_ID, ls.VALOR, s.TIPO, s.NOME, s.LOCALIZACAO
        FROM LEITURA_SENSOR ls
        JOIN SENSOR s ON ls.SENSOR_ID = s.ID
        WHERE ls.DATA_LEITURA >= SYSDATE - 1/24 -- última hora
        AND (
            (s.TIPO = 'TEMPERATURA' AND (ls.VALOR > 35 OR ls.VALOR < 10)) OR
            (s.TIPO = 'UMIDADE' AND (ls.VALOR > 80 OR ls.VALOR < 30)) OR
            (s.TIPO = 'MOVIMENTO' AND ls.VALOR = 1)
        );
    
    v_count_alertas NUMBER := 0;
    v_mensagem VARCHAR2(500);
    v_criticidade VARCHAR2(10);
BEGIN
    -- Loop através das leituras críticas
    FOR rec IN c_leituras_criticas LOOP
        -- Determina mensagem e criticidade baseado no tipo
        IF rec.TIPO = 'TEMPERATURA' THEN
            IF rec.VALOR > 35 THEN
                v_mensagem := 'Temperatura alta detectada: ' || rec.VALOR || '°C em ' || rec.LOCALIZACAO;
                v_criticidade := 'ALTA';
            ELSE
                v_mensagem := 'Temperatura baixa detectada: ' || rec.VALOR || '°C em ' || rec.LOCALIZACAO;
                v_criticidade := 'MEDIA';
            END IF;
        ELSIF rec.TIPO = 'UMIDADE' THEN
            IF rec.VALOR > 80 THEN
                v_mensagem := 'Umidade alta detectada: ' || rec.VALOR || '% em ' || rec.LOCALIZACAO;
                v_criticidade := 'MEDIA';
            ELSE
                v_mensagem := 'Umidade baixa detectada: ' || rec.VALOR || '% em ' || rec.LOCALIZACAO;
                v_criticidade := 'BAIXA';
            END IF;
        ELSIF rec.TIPO = 'MOVIMENTO' THEN
            v_mensagem := 'Movimento detectado em ' || rec.LOCALIZACAO;
            v_criticidade := 'BAIXA';
        END IF;
        
        -- Verifica se já existe alerta similar nas últimas 2 horas
        DECLARE
            v_existe NUMBER := 0;
        BEGIN
            SELECT COUNT(*)
            INTO v_existe
            FROM ALERTA
            WHERE SENSOR_ID = rec.SENSOR_ID
            AND TIPO = rec.TIPO
            AND DATA_ALERTA >= SYSDATE - 2/24
            AND STATUS = 'PENDENTE';
            
            -- Insere alerta apenas se não existir similar recente
            IF v_existe = 0 THEN
                -- Insere alerta para todos os usuários ativos
                INSERT INTO ALERTA (SENSOR_ID, USUARIO_ID, TIPO, MENSAGEM, CRITICIDADE)
                SELECT rec.SENSOR_ID, u.ID, rec.TIPO, v_mensagem, v_criticidade
                FROM USUARIO u
                WHERE u.ID IS NOT NULL;
                
                v_count_alertas := v_count_alertas + 1;
            END IF;
        END;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Processados ' || v_count_alertas || ' novos alertas');
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao processar alertas: ' || SQLERRM);
        RAISE;
END SP_PROCESSAR_ALERTAS_CRITICOS;
/

-- Procedure 2: Gerar relatório de consumo por usuário
CREATE OR REPLACE PROCEDURE SP_RELATORIO_CONSUMO_USUARIO(
    p_usuario_id IN NUMBER,
    p_mes_ano IN VARCHAR2 DEFAULT NULL
)
AUTHID DEFINER
IS
    CURSOR c_consumo IS
        SELECT DISPOSITIVO, CONSUMO_KWH, CUSTO, DATA_CONSUMO
        FROM CONSUMO_ENERGIA
        WHERE USUARIO_ID = p_usuario_id
        AND (p_mes_ano IS NULL OR MES_ANO = p_mes_ano)
        ORDER BY DATA_CONSUMO DESC;
    
    v_total_consumo NUMBER(10,3) := 0;
    v_total_custo NUMBER(10,2) := 0;
    v_count_registros NUMBER := 0;
    v_usuario_nome VARCHAR2(100);
    v_mes_filtro VARCHAR2(7);
BEGIN
    -- Busca nome do usuário
    SELECT NOME INTO v_usuario_nome
    FROM USUARIO WHERE ID = p_usuario_id;
    
    -- Define período do relatório
    v_mes_filtro := NVL(p_mes_ano, TO_CHAR(SYSDATE, 'MM/YYYY'));
    
    DBMS_OUTPUT.PUT_LINE('=== RELATÓRIO DE CONSUMO ENERGÉTICO ===');
    DBMS_OUTPUT.PUT_LINE('Usuário: ' || v_usuario_nome);
    DBMS_OUTPUT.PUT_LINE('Período: ' || v_mes_filtro);
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    
    -- Loop através dos consumos
    FOR rec IN c_consumo LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(rec.DISPOSITIVO, 20) || ' | ' ||
            LPAD(TO_CHAR(rec.CONSUMO_KWH, '999.99'), 8) || ' kWh | R$ ' ||
            LPAD(TO_CHAR(rec.CUSTO, '999.99'), 8) || ' | ' ||
            TO_CHAR(rec.DATA_CONSUMO, 'DD/MM/YYYY')
        );
        
        v_total_consumo := v_total_consumo + rec.CONSUMO_KWH;
        v_total_custo := v_total_custo + rec.CUSTO;
        v_count_registros := v_count_registros + 1;
    END LOOP;
    
    IF v_count_registros = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum registro encontrado para o período');
    ELSE
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        DBMS_OUTPUT.PUT_LINE('TOTAL: ' || TO_CHAR(v_total_consumo, '9999.99') || ' kWh | R$ ' || TO_CHAR(v_total_custo, '9999.99'));
        DBMS_OUTPUT.PUT_LINE('MÉDIA: ' || TO_CHAR(v_total_consumo/v_count_registros, '999.99') || ' kWh por dispositivo');
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Usuário não encontrado');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao gerar relatório: ' || SQLERRM);
        RAISE;
END SP_RELATORIO_CONSUMO_USUARIO;
/