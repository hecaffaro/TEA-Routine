-- Dados iniciais para H2 (carregados automaticamente)

INSERT INTO USUARIO (ID, EMAIL, SENHA, NOME) VALUES 
(1, 'admin@smarthas.com', 'admin123', 'Administrador'),
(2, 'joao@email.com', 'senha123', 'João Silva'),
(3, 'maria@email.com', 'senha456', 'Maria Santos');

INSERT INTO SENSOR (ID, NOME, TIPO, LOCALIZACAO) VALUES 
(1, 'Temp Sala', 'TEMPERATURA', 'Sala de Estar'),
(2, 'Umid Quarto', 'UMIDADE', 'Quarto Principal'),
(3, 'Mov Entrada', 'MOVIMENTO', 'Entrada Principal'),
(4, 'Luz Cozinha', 'LUZ', 'Cozinha'),
(5, 'Temp Quarto', 'TEMPERATURA', 'Quarto Principal');

INSERT INTO LEITURA_SENSOR (ID, SENSOR_ID, VALOR, UNIDADE) VALUES 
(1, 1, 23.5, '°C'),
(2, 1, 24.2, '°C'),
(3, 1, 22.8, '°C'),
(4, 2, 65.0, '%'),
(5, 2, 68.5, '%'),
(6, 3, 1, 'bool'),
(7, 3, 0, 'bool'),
(8, 4, 450, 'lux'),
(9, 5, 19.2, '°C'),
(10, 5, 20.1, '°C');

INSERT INTO CONSUMO_ENERGIA (ID, USUARIO_ID, DISPOSITIVO, CONSUMO_KWH, CUSTO, DATA_CONSUMO, MES_ANO) VALUES 
(1, 2, 'Ar Condicionado', 45.5, 32.85, CURRENT_DATE - 30, '12/2024'),
(2, 2, 'Geladeira', 28.2, 20.34, CURRENT_DATE - 30, '12/2024'),
(3, 3, 'Chuveiro Elétrico', 67.8, 48.92, CURRENT_DATE - 30, '12/2024');

-- Dados carregados com sucesso