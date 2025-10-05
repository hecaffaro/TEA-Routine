-- Melhorias de Segurança para o Banco Oracle

-- Criar índices para melhor performance
CREATE INDEX IDX_LEITURA_SENSOR_DATA ON LEITURA_SENSOR(DATA_LEITURA);
CREATE INDEX IDX_ALERTA_STATUS ON ALERTA(STATUS, DATA_ALERTA);
CREATE INDEX IDX_CONSUMO_USUARIO_DATA ON CONSUMO_ENERGIA(USUARIO_ID, DATA_CONSUMO);

-- Adicionar constraints de validação
ALTER TABLE SENSOR ADD CONSTRAINT CHK_SENSOR_TIPO 
    CHECK (TIPO IN ('TEMPERATURA', 'UMIDADE', 'MOVIMENTO', 'LUZ'));

ALTER TABLE SENSOR ADD CONSTRAINT CHK_SENSOR_STATUS 
    CHECK (STATUS IN ('ATIVO', 'INATIVO', 'MANUTENCAO'));

ALTER TABLE ALERTA ADD CONSTRAINT CHK_ALERTA_CRITICIDADE 
    CHECK (CRITICIDADE IN ('BAIXA', 'MEDIA', 'ALTA'));

ALTER TABLE ALERTA ADD CONSTRAINT CHK_ALERTA_STATUS 
    CHECK (STATUS IN ('PENDENTE', 'LIDO', 'RESOLVIDO'));

-- Procedure melhorada para processar alertas com parâmetro de usuário
CREATE OR REPLACE PROCEDURE SP_PROCESSAR_ALERTAS_USUARIO(
    p_usuario_id IN NUMBER DEFAULT NULL
)
AUTHID DEFINER
IS
    CURSOR c_leituras_criticas IS
        SELECT ls.ID, ls.SENSOR_ID, ls.VALOR, s.TIPO, s.NOME, s.LOCALIZACAO
        FROM LEITURA_SENSOR ls
        JOIN SENSOR s ON ls.SENSOR_ID = s.ID
        WHERE ls.DATA_LEITURA >= SYSDATE - 1/24 -- última hora
        AND s.STATUS = 'ATIVO'
        AND (
            (s.TIPO = 'TEMPERATURA' AND (ls.VALOR > 35 OR ls.VALOR < 10)) OR
            (s.TIPO = 'UMIDADE' AND (ls.VALOR > 80 OR ls.VALOR < 30)) OR
            (s.TIPO = 'MOVIMENTO' AND ls.VALOR = 1)
        );
    
    v_count_alertas NUMBER := 0;
    v_mensagem VARCHAR2(500);
    v_criticidade VARCHAR2(10);
    v_usuario_target NUMBER;
BEGIN
    -- Define usuário alvo
    v_usuario_target := NVL(p_usuario_id, 1);
    
    -- Loop através das leituras críticas
    FOR rec IN c_leituras_criticas LOOP
        -- Determina mensagem e criticidade
        CASE rec.TIPO
            WHEN 'TEMPERATURA' THEN
                IF rec.VALOR > 35 THEN
                    v_mensagem := 'Temperatura alta: ' || rec.VALOR || '°C em ' || rec.LOCALIZACAO;
                    v_criticidade := 'ALTA';
                ELSE
                    v_mensagem := 'Temperatura baixa: ' || rec.VALOR || '°C em ' || rec.LOCALIZACAO;
                    v_criticidade := 'MEDIA';
                END IF;
            WHEN 'UMIDADE' THEN
                IF rec.VALOR > 80 THEN
                    v_mensagem := 'Umidade alta: ' || rec.VALOR || '% em ' || rec.LOCALIZACAO;
                    v_criticidade := 'MEDIA';
                ELSE
                    v_mensagem := 'Umidade baixa: ' || rec.VALOR || '% em ' || rec.LOCALIZACAO;
                    v_criticidade := 'BAIXA';
                END IF;
            WHEN 'MOVIMENTO' THEN
                v_mensagem := 'Movimento detectado em ' || rec.LOCALIZACAO;
                v_criticidade := 'BAIXA';
        END CASE;
        
        -- Verifica se já existe alerta similar
        DECLARE
            v_existe NUMBER := 0;
        BEGIN
            SELECT COUNT(*)
            INTO v_existe
            FROM ALERTA
            WHERE SENSOR_ID = rec.SENSOR_ID
            AND USUARIO_ID = v_usuario_target
            AND TIPO = rec.TIPO
            AND DATA_ALERTA >= SYSDATE - 2/24
            AND STATUS = 'PENDENTE';
            
            -- Insere alerta se não existir similar
            IF v_existe = 0 THEN
                INSERT INTO ALERTA (SENSOR_ID, USUARIO_ID, TIPO, MENSAGEM, CRITICIDADE)
                VALUES (rec.SENSOR_ID, v_usuario_target, rec.TIPO, v_mensagem, v_criticidade);
                
                v_count_alertas := v_count_alertas + 1;
            END IF;
        END;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Processados ' || v_count_alertas || ' novos alertas para usuário ' || v_usuario_target);
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao processar alertas: ' || SQLERRM);
        RAISE;
END SP_PROCESSAR_ALERTAS_USUARIO;
/