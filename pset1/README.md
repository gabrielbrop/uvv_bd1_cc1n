# PSET 1
## Sobre o PSET 1
O PSET é uma atividade avaliativa proposta pelo professor. Este PSET consiste em 4 tarefas:
1. Replicar o modelo físico de um banco de dados fornecido pelo professor;
2. Implementar a solução no PostgreSQL;
3. Responder às perguntas do professor;
4. Criar relatórios em linguagem SQL especificados pelo professor.
## Estrutura dos arquivos
Esta pasta contém três arquivos: `cc1n_202307871_postgresql.architect`, `cc1n_202307871_postgresql.sql` e `cc1n_202307871_postgresql.pdf`. O primeiro é um arquivo do SQL Power Architect com o modelo físico do banco de dados, o segundo é sua implementação no PostgreSQL e o terceiro é um PDF do modelo físico.
## Instalação
1. Instale a máquina virtual [DBServer 2.0](https://www.computacaoraiz.com.br/2023/01/02/dbserver-2/).
2. Clone este repositório: `git clone `
3. Acesse o diretório do script SQL: `cd ./uvv_bd1_cc1n/pset1`
4. Execute o script passando o conteúdo do arquivo do script para o stdin do psql: `psql -U postgres < cc1n_202307871_postgresql.sql`