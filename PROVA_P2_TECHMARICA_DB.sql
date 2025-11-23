DROP DATABASE IF EXISTS techmarica_industria;

CREATE DATABASE techmarica_industria;

USE techmarica_industria;

-- ---------------------------------------------------------
-- 1. CRIAÇÃO DAS TABELAS (DDL)
-- ---------------------------------------------------------

-- Tabela Funcionarios
-- Regra: Identificação, área e situação (ativo/inativo)
CREATE TABLE funcionarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    area_atuacao VARCHAR(100),
    ativo ENUM("ATIVO", "INATIVO") DEFAULT "ATIVO",
    data_admissao DATE
);

-- Tabela Maquinas
-- Regra: Código, modelo e status
CREATE TABLE maquinas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo_maquina VARCHAR(50) UNIQUE,
    modelo VARCHAR(100),
    status_maquina ENUM("OPERANDO", "MANUTENCAO", "PARADA") DEFAULT "OPERANDO"
);

-- Tabela Produtos
-- Regra: Código interno (id), nome, custo, responsável
CREATE TABLE produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_comercial VARCHAR(100),
    custo_producao DECIMAL(10,2),
    responsavel_tecnico VARCHAR(100),
    data_criacao_catalogo DATE
);

-- Tabela Ordens de Produção
-- Regra: Relaciona produto, funcionario, maquina e datas
CREATE TABLE ordens_producao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT,
    id_funcionario INT, -- Quem autorizou
    id_maquina INT,
    data_inicio DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_conclusao DATETIME,
    status_ordem ENUM("EM PRODUCAO", "FINALIZADA", "CANCELADA") DEFAULT "EM PRODUCAO",
    FOREIGN KEY (id_produto) REFERENCES produtos(id),
    FOREIGN KEY (id_funcionario) REFERENCES funcionarios(id),
    FOREIGN KEY (id_maquina) REFERENCES maquinas(id)
);

-- ---------------------------------------------------------
-- 2. INSERÇÃO DE DADOS (DML)
-- ---------------------------------------------------------

INSERT INTO funcionarios (nome, area_atuacao, ativo, data_admissao)
VALUES
("Carlos Mendes", "Montagem", "ATIVO", "2023-01-15"),
("Fernanda Souza", "Qualidade", "ATIVO", "2022-05-20"),
("Roberto Alves", "Manutenção", "INATIVO", "2020-03-10"),
("Juliana Lima", "Engenharia", "ATIVO", "2024-02-01"),
("Marcos Paulo", "Logística", "ATIVO", "2023-11-10");

INSERT INTO maquinas (codigo_maquina, modelo, status_maquina)
VALUES
("MAQ-001", "Soldadora Automática X200", "OPERANDO"),
("MAQ-002", "Injetora de Plástico Pro", "MANUTENCAO"),
("MAQ-003", "Braço Robótico Montador", "OPERANDO");

INSERT INTO produtos (nome_comercial, custo_producao, responsavel_tecnico, data_criacao_catalogo)
VALUES
("Sensor de Presença WiFi", 45.50, "Juliana Lima", "2022-01-10"),
("Placa Controladora IoT", 120.00, "Juliana Lima", "2023-06-15"),
("Modulo Bluetooth 5.0", 30.25, "Carlos Mendes", "2021-08-20"),
("Kit Arduino TechMarica", 85.90, "Carlos Mendes", "2020-05-05"),
("Fonte Chaveada 12V", 25.00, "Fernanda Souza", "2024-01-10");

-- Inserindo ordens manuais para histórico
INSERT INTO ordens_producao (id_produto, id_funcionario, id_maquina, data_inicio, data_conclusao, status_ordem)
VALUES
(1, 4, 1, "2025-10-01 08:00:00", "2025-10-01 12:00:00", "FINALIZADA"),
(2, 4, 3, "2025-10-02 09:00:00", NULL, "EM PRODUCAO"),
(3, 1, 1, "2025-10-03 10:00:00", "2025-10-03 11:30:00", "FINALIZADA"),
(4, 2, 3, "2025-10-04 14:00:00", NULL, "EM PRODUCAO"),
(5, 4, 2, "2025-10-05 08:00:00", NULL, "CANCELADA");

-- ---------------------------------------------------------
-- 3. CONSULTAS SQL AVANÇADAS
-- ---------------------------------------------------------

-- 1. Listagem completa das ordens de produção com detalhes (JOINS)
SELECT 
    op.id AS "N Ordem",
    p.nome_comercial AS "Produto",
    m.modelo AS "Maquina",
    f.nome AS "Responsavel",
    op.status_ordem,
    op.data_inicio
FROM ordens_producao op
INNER JOIN produtos p ON op.id_produto = p.id
INNER JOIN maquinas m ON op.id_maquina = m.id
INNER JOIN funcionarios f ON op.id_funcionario = f.id;

-- 2. Filtragem de funcionários inativos
SELECT nome, area_atuacao 
FROM funcionarios 
WHERE ativo = "INATIVO";

-- 3. Contagem total de produtos por responsável técnico
SELECT 
    responsavel_tecnico, 
    COUNT(id) AS "Qtd Produtos"
FROM produtos
GROUP BY responsavel_tecnico;

-- 4. Seleção de produtos cujo nome começa com letra "P"
SELECT * FROM produtos
WHERE nome_comercial LIKE "P%";

-- 5. Cálculo automático da "idade" do produto (em anos)
SELECT 
    nome_comercial,
    data_criacao_catalogo,
    TIMESTAMPDIFF(YEAR, data_criacao_catalogo, CURDATE()) AS "Anos de Catalogo"
FROM produtos;

-- ---------------------------------------------------------
-- 4. VIEW (VISÃO CONSOLIDADA PARA GERENTE)
-- ---------------------------------------------------------

CREATE OR REPLACE VIEW vw_producao_gerencia AS
SELECT 
    op.id AS codigo_ordem,
    p.nome_comercial AS produto,
    f.nome AS supervisor,
    m.codigo_maquina,
    op.status_ordem
FROM ordens_producao op
JOIN produtos p ON op.id_produto = p.id
JOIN funcionarios f ON op.id_funcionario = f.id
JOIN maquinas m ON op.id_maquina = m.id;

SELECT * FROM vw_producao_gerencia;

-- ---------------------------------------------------------
-- 5. STORED PROCEDURE (REGISTRO AUTOMÁTICO)
-- ---------------------------------------------------------
-- Recebe IDs e cria a ordem com data atual e status EM PRODUCAO

DELIMITER $$

CREATE PROCEDURE sp_registrar_ordem(
    IN p_id_produto INT,
    IN p_id_funcionario INT,
    IN p_id_maquina INT
)
BEGIN
    INSERT INTO ordens_producao (id_produto, id_funcionario, id_maquina, data_inicio, status_ordem)
    VALUES (p_id_produto, p_id_funcionario, p_id_maquina, NOW(), "EM PRODUCAO");
    
    SELECT "Ordem registrada com sucesso!" AS Mensagem;
END $$

DELIMITER ;

-- Teste da Procedure:
CALL sp_registrar_ordem(1, 2, 3);

-- ---------------------------------------------------------
-- 6. TRIGGER (ATUALIZAÇÃO AUTOMÁTICA DE STATUS)
-- ---------------------------------------------------------
-- Atualiza status para FINALIZADA quando data_conclusao é preenchida

DELIMITER $$

CREATE TRIGGER trg_finalizar_ordem
BEFORE UPDATE ON ordens_producao
FOR EACH ROW
BEGIN
    IF NEW.data_conclusao IS NOT NULL AND OLD.data_conclusao IS NULL THEN
        SET NEW.status_ordem = "FINALIZADA";
    END IF;
END $$

DELIMITER ;

-- Teste do Trigger (Atualizando a ordem criada pela procedure)
-- Supondo que a ordem nova seja a de ID 6
UPDATE ordens_producao 
SET data_conclusao = NOW() 
WHERE status_ordem = "EM PRODUCAO" LIMIT 1;

-- Verificando resultado final
SELECT * FROM ordens_producao;