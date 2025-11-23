# 🏭 TechMaricá - Sistema de Controle de Produção

> **Disciplina:** Banco de Dados / Engenharia de Software
> **Professor:** Fabrício Dias
> **Aluno:** Cauan Ferreira de Almeida
> **Matrícula:** 202323031
> **Instituição:** Univassouras - Campus Maricá  
> **Período:** 4º Período  

---

## 📄 Sobre o Projeto
Este projeto consiste na modelagem e implementação de um banco de dados relacional para a **TechMaricá Indústria Eletrônica S.A.**. O objetivo é simular o controle de operações internas de uma fábrica, gerenciando produtos, funcionários, máquinas e ordens de produção.

O projeto foi desenvolvido inteiramente em **SQL**, focando na criação de estruturas robustas sem o uso de transações, conforme solicitado no enunciado da avaliação.

## 🚀 Tecnologias e Conceitos Aplicados
O código demonstra domínio das seguintes competências de Banco de Dados:

* **DDL (Data Definition Language):** Criação de tabelas com chaves primárias (`PK`), estrangeiras (`FK`), restrições `UNIQUE` e valores padrão (`DEFAULT`).
* **DML (Data Manipulation Language):** Inserção e atualização de dados realistas.
* **Consultas Avançadas:** Uso de `JOINS` (INNER), funções de agregação (`COUNT`, `GROUP BY`), manipulação de datas e filtros condicionais.
* **Views:** Criação de visão consolidada para gerência (`vw_producao_gerencia`).
* **Stored Procedures:** Automação do registro de ordens de produção (`sp_registrar_ordem`).
* **Triggers:** Gatilho para atualização automática de status (`trg_finalizar_ordem`).

## 🛠️ Estrutura do Banco de Dados

O banco `techmarica_industria` é composto pelas seguintes entidades principais:

1.  **Produtos:** Eletrônicos fabricados (ex: Sensores, Placas IoT).
2.  **Funcionários:** Equipe técnica e operacional.
3.  **Máquinas:** Equipamentos utilizados na linha de produção.
4.  **Ordens de Produção:** Tabela fato que registra o processo produtivo, vinculando quem fez, o que foi feito e em qual máquina.

## ⚙️ Como Executar

1.  Certifique-se de ter um SGBD MySQL instalado (Workbench, DBeaver, etc.).
2.  Faça o download do arquivo `PROVA_P2_TECHMARICA_DB.sql` neste repositório.
3.  Abra o arquivo no seu editor SQL.
4.  Execute o script completo (o script já contém o comando para criar e selecionar o banco de dados).

---
*Projeto desenvolvido para fins acadêmicos - 2025.*
