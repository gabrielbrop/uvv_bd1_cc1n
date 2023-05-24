/**
 * Universidade Vila Velha - CC1N - 1/23
 * Banco de Dados - PSET 01
 * Gabriel Bruno
 * @gabrielbrop
 */

-- Apaga o usuário e o banco de dados caso existam
DROP DATABASE IF EXISTS uvv;
DROP USER IF EXISTS gabriel;

-- Cria o usuário
CREATE USER gabriel
ENCRYPTED PASSWORD 'password'
CREATEDB
CREATEROLE;

-- Cria o banco de dados
CREATE DATABASE uvv
OWNER gabriel
TEMPLATE template0
ENCODING UTF8
LC_COLLATE 'pt_BR.UTF-8'
LC_CTYPE 'pt_BR.UTF-8'
ALLOW_CONNECTIONS true;

-- Comentário para o banco de dados UVV
COMMENT ON DATABASE uvv IS 'Banco de dados das lojas UVV.';

-- Conecta-se ao banco de dados com o usuário criado
\c "dbname=uvv user=gabriel password=password"

-- Cria um schema
CREATE SCHEMA lojas
AUTHORIZATION gabriel;

-- Altera o usuário para usar o schema criado por padrão
ALTER USER gabriel
SET SEARCH_PATH TO lojas, "$user", public;

-- Cria a relação produtos
CREATE TABLE lojas.produtos (
    produto_id NUMERIC(38) NOT NULL,
    nome VARCHAR(255) NOT NULL,
    preco_unitario NUMERIC(10,2),
    detalhes BYTEA,
    imagem BYTEA,
    imagem_mime_type VARCHAR(512),
    imagem_arquivo VARCHAR(512),
    imagem_charset VARCHAR(512),
    imagem_ultima_atualizacao DATE
);

-- Adiciona a chave primária produtos_pk à relação produtos com atributo produto_id
ALTER TABLE lojas.produtos
ADD CONSTRAINT produtos_pk
PRIMARY KEY (produto_id);

-- O preço deve ser positivo
ALTER TABLE lojas.produtos
ADD CONSTRAINT preco_check
CHECK (preco_unitario >= 0);

-- Se uma imagem for definida, todos seus atributos também deve ser definidos 
ALTER TABLE lojas.produtos
ADD CONSTRAINT imagem_check
CHECK (
    (
        imagem IS NOT NULL AND
        imagem_mime_type IS NOT NULL AND
        imagem_arquivo IS NOT NULL AND
        imagem_charset IS NOT NULL AND
        imagem_ultima_atualizacao IS NOT NULL
    )
    OR
    (
        imagem IS NULL AND
        imagem_mime_type IS NULL AND
        imagem_arquivo IS NULL AND
        imagem_charset IS NULL AND
        imagem_ultima_atualizacao IS NULL
    )
);

-- Comentários para a relação produtos e seus atributos
COMMENT ON TABLE lojas.produtos IS 'Relação que representa um produto comercial.';
COMMENT ON COLUMN lojas.produtos.produto_id IS 'Atributo que representa o ID (Identificador Único) de um produto. Faz parte da chave primária.';
COMMENT ON COLUMN lojas.produtos.nome IS 'Atributo que representa o nome de um produto.';
COMMENT ON COLUMN lojas.produtos.preco_unitario IS 'Atributo que representa o preço por unidade de um produto.';
COMMENT ON COLUMN lojas.produtos.detalhes IS 'Atributo que representa os detalhes de um produto em formato JSON.';
COMMENT ON COLUMN lojas.produtos.imagem IS 'Atributo que representa a imagem do produto em codificação binária.';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type IS 'Atributo que representa o tipo de mídia da imagem, de acordo com o padrão MIME.';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo IS 'Atributo que representa o caminho físico para a imagem.';
COMMENT ON COLUMN lojas.produtos.imagem_charset IS 'Atributo que representa o formato de codificação dos caracteres da imagem.';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'Atributo que representa a data da última atualização de imagem.';

-- Cria a relação lojas
CREATE TABLE lojas.lojas (
    loja_id NUMERIC(38) NOT NULL,
    nome VARCHAR(255) NOT NULL,
    endereco_web VARCHAR(100),
    endereco_fisico VARCHAR(512),
    latitude NUMERIC,
    longitude NUMERIC,
    logo BYTEA,
    logo_mime_type VARCHAR(512),
    logo_arquivo VARCHAR(512),
    logo_charset VARCHAR(512),
    logo_ultima_atualizacao DATE
);

-- Adiciona a chave primária lojas_pk à relação lojas com atributo loja_id
ALTER TABLE lojas.lojas
ADD CONSTRAINT lojas_pk
PRIMARY KEY (loja_id);

-- Uma loja precisa ter pelo menos 1 tipo de endereço definido 
ALTER TABLE lojas.lojas
ADD CONSTRAINT endereco_check
CHECK (endereco_web IS NOT NULL OR endereco_fisico IS NOT NULL);

-- Latitude não pode ser definida se longitude for definida e vice-versa
ALTER TABLE lojas.lojas
ADD CONSTRAINT coordenadas_check
CHECK (
    latitude IS NULL AND longitude IS NULL
    OR latitude IS NOT NULL AND longitude IS NOT NULL 
);

-- Se uma logo for definida, todos os atributos também deve ser definidos 
ALTER TABLE lojas.lojas
ADD CONSTRAINT logo_check
CHECK (
    (
        logo IS NOT NULL AND
        logo_mime_type IS NOT NULL AND
        logo_arquivo IS NOT NULL AND
        logo_charset IS NOT NULL AND
        logo_ultima_atualizacao IS NOT NULL
    )
    OR
    (
        logo IS NULL AND
        logo_mime_type IS NULL AND
        logo_arquivo IS NULL AND
        logo_charset IS NULL AND
        logo_ultima_atualizacao IS NULL
    )
);

-- Comentários para a relação lojas e seus atributos
COMMENT ON TABLE lojas.lojas IS 'Relação que representa uma loja física e/ou comercial.';
COMMENT ON COLUMN lojas.lojas.loja_id IS 'Atributo que representa o ID (Identificador Único) de uma loja. Faz parte da chave primária.';
COMMENT ON COLUMN lojas.lojas.nome IS 'Atributo que representa o nome de uma loja.';
COMMENT ON COLUMN lojas.lojas.endereco_web IS 'Atributo que representa o URL da loja, caso ela tenha presença online.';
COMMENT ON COLUMN lojas.lojas.endereco_fisico IS 'Atributo que representa o endereço físico de uma loja, caso ela seja uma loja física.';
COMMENT ON COLUMN lojas.lojas.latitude IS 'Atributo que representa a latitude das coordenadas da loja, caso ela seja física.';
COMMENT ON COLUMN lojas.lojas.longitude IS 'Atributo que representa a longitude das coordenadas da loja, caso ela seja física.';
COMMENT ON COLUMN lojas.lojas.logo IS 'Atributo que representa a logo de uma loja em codificação binária.';
COMMENT ON COLUMN lojas.lojas.logo_mime_type IS 'Atributo que representa o tipo de mídia da logo, de acordo com o padrão MIME.';
COMMENT ON COLUMN lojas.lojas.logo_arquivo IS 'Atributo que representa o caminho físico para a logo.';
COMMENT ON COLUMN lojas.lojas.logo_charset IS 'Atributo que representa o formato de codificação dos caracteres da logo.';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'Atributo que representa a data da última atualização da logo.';

-- Cria a relação estoques
CREATE TABLE lojas.estoques (
    estoque_id NUMERIC(38) NOT NULL,
    loja_id NUMERIC(38) NOT NULL,
    produto_id NUMERIC(38) NOT NULL,
    quantidade NUMERIC(38) NOT NULL
);

-- Adiciona a chave primária estoques_pk à relação estoques com atributo estoque_id
ALTER TABLE lojas.estoques
ADD CONSTRAINT estoques_pk
PRIMARY KEY (estoque_id);

-- Adiciona a chave estrangeira produtos_estoques_fk ao atributo produto_id que referencia lojas.produtos.produto_id
ALTER TABLE lojas.estoques
ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id);

-- Adiciona a chave estrangeira lojas_estoques_fk ao atributo loja_id que referencia lojas.lojas.loja_id
ALTER TABLE lojas.estoques
ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id);

-- A quantidade de um item deve ser positiva
ALTER TABLE lojas.estoques
ADD CONSTRAINT quantidade_check
CHECK (quantidade > 0);

-- Comentários para a relação estoques e seus atributos
COMMENT ON TABLE lojas.estoques IS 'Relação que representa um produto em estoque em uma loja.';
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'Atributo que representa o ID (Identificador Único) de um produto em estoque. Faz parte da chave primária.';
COMMENT ON COLUMN lojas.estoques.loja_id IS 'Atributo que representa a loja em que o produto está estocado.';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'Atributo que representa o produto que está em estoque.';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'Atributo que representa a quantidade do produto em estoque.';

-- Cria a relação clientes
CREATE TABLE lojas.clientes (
    cliente_id NUMERIC(38) NOT NULL,
    email VARCHAR(255) NOT NULL,
    nome VARCHAR(255) NOT NULL,
    telefone1 VARCHAR(20),
    telefone2 VARCHAR(20),
    telefone3 VARCHAR(20)
);

-- Adiciona a chave primária clientes_pk à relação clientes com atributo cliente_id
ALTER TABLE lojas.clientes
ADD CONSTRAINT clientes_pk
PRIMARY KEY (cliente_id);

-- Garante que um telefone não seja definido caso um telefone de maior prioridade ainda não esteja definido
ALTER TABLE lojas.clientes
ADD CONSTRAINT telefone_check
CHECK (
    telefone3 IS NOT NULL AND telefone2 IS NOT NULL AND telefone1 IS NOT NULL
    OR telefone3 IS NULL AND telefone2 IS NOT NULL AND telefone1 IS NOT NULL
    OR telefone3 IS NULL AND telefone2 IS NULL AND telefone1 IS NOT NULL
    OR telefone3 IS NULL AND telefone2 IS NULL AND telefone1 IS NULL
);

-- Comentários para a relação clientes e seus atributos
COMMENT ON TABLE lojas.clientes IS 'Relação que representa um cliente.';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'Atributo que representa o ID (Identificador Único) de um cliente. Faz parte da chave primária.';
COMMENT ON COLUMN lojas.clientes.email IS 'Atributo que representa o endereço eletrônico de um cliente.';
COMMENT ON COLUMN lojas.clientes.nome IS 'Atributo que representa o nome completo de um cliente.';
COMMENT ON COLUMN lojas.clientes.telefone1 IS 'Atributo que representa o primeiro telefone de um cliente.';
COMMENT ON COLUMN lojas.clientes.telefone2 IS 'Atributo que representa o segundo telefone de um cliente.';
COMMENT ON COLUMN lojas.clientes.telefone3 IS 'Atributo que representa o terceiro telefone de um cliente.';

-- Cria a relação pedidos
CREATE TABLE lojas.pedidos (
    pedido_id NUMERIC(38) NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    cliente_id NUMERIC(38) NOT NULL,
    status VARCHAR(15) NOT NULL,
    loja_id NUMERIC(38) NOT NULL
);

-- Adiciona a chave primária pedidos_pk à relação pedidos com atributo pedido_id
ALTER TABLE lojas.pedidos
ADD CONSTRAINT pedidos_pk
PRIMARY KEY (pedido_id);

-- Adiciona a chave estrangeira lojas_pedidos_fk ao atributo loja_id que referencia lojas.lojas.loja_id
ALTER TABLE lojas.pedidos
ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id);

-- Adiciona a chave estrangeira clientes_pedidos_fk ao atributo cliente_id que referencia lojas.clientes.cliente_id
ALTER TABLE lojas.pedidos
ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id);

-- O status do pedido deve ser CANCELADO, COMPLETO, ABERTO, PAGO, REEMBOLSADO ou ENVIADO.
ALTER TABLE lojas.pedidos
ADD CONSTRAINT status_check
CHECK (status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'));

-- Comentários para a relação pedidos e seus atributos
COMMENT ON COLUMN lojas.pedidos.pedido_id IS 'Atributo que representa o ID (Identificador Único) de um pedido. Faz parte da chave primária.';
COMMENT ON COLUMN lojas.pedidos.data_hora IS 'Atributo que representa a data e a hora do pedido.';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'Atributo que representa o cliente que realizou o pedido.';
COMMENT ON COLUMN lojas.pedidos.status IS 'Atributo que representa a condição atual do pedido. Valores permitidos: CANCELADO, COMPLETO, ABERTO, PAGO, REEMBOLSADO, ENVIADO.';
COMMENT ON COLUMN lojas.pedidos.loja_id IS 'Atributo que representa a loja em que o pedido foi feito.';

-- Cria a relação envios
CREATE TABLE lojas.envios (
    envio_id NUMERIC(38) NOT NULL,
    loja_id NUMERIC(38) NOT NULL,
    cliente_id NUMERIC(38) NOT NULL,
    endereco_entrega VARCHAR NOT NULL,
    status VARCHAR NOT NULL
);

-- Adiciona a chave primária envios_pk à relação envios com atributo envio_id
ALTER TABLE lojas.envios
ADD CONSTRAINT envios_pk
PRIMARY KEY (envio_id);

-- Adiciona a chave estrangeira lojas_envios_fk ao atributo loja_id que referencia lojas.lojas.loja_id
ALTER TABLE lojas.envios
ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id);

-- Adiciona a chave estrangeira clientes_envios_fk ao atributo cliente_id que referencia lojas.clientes.cliente_id
ALTER TABLE lojas.envios
ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id);

-- Status deve ser CRIADO, ENVIADO, TRANSIT ou ENTREGUE.
ALTER TABLE lojas.envios
ADD CONSTRAINT status_check
CHECK (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));

-- Comentários para a relação envios e seus atributos
COMMENT ON TABLE lojas.envios IS 'Relação que representa o envio de um produto.';
COMMENT ON COLUMN lojas.envios.envio_id IS 'Atributo que representa o ID (Identificador Único) de um envio. Faz parte da chave primária.';
COMMENT ON COLUMN lojas.envios.loja_id IS 'Atributo que representa a loja remetente.';
COMMENT ON COLUMN lojas.envios.cliente_id IS 'Atributo que representa o cliente destinatário.';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'Atributo que representa o endereço de entrega do destinatário.';
COMMENT ON COLUMN lojas.envios.status IS 'Atributo que representa a condição atual da entrega. Valores permitidos: CRIADO, ENVIADO, TRANSITO, ENTREGUE.';

-- Cria a relação pedidos_itens
CREATE TABLE lojas.pedidos_itens (
    pedido_id NUMERIC(38) NOT NULL,
    produto_id NUMERIC(38) NOT NULL,
    numero_da_linha NUMERIC(38) NOT NULL,
    preco_unitario NUMERIC(10,2),
    quantidade NUMERIC(38) NOT NULL,
    envio_id NUMERIC(38) NOT NULL
);

-- Adiciona a chave primária pedidos_itens_pk à relação pedidos_itens com atributos pedido_id e produto_id
ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT pedidos_itens_pk
PRIMARY KEY (pedido_id, produto_id);

-- Adiciona a chave estrangeira produtos_pedidos_itens_fk ao atributo produto_id que referencia lojas.produtos.produto_id
ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id);

-- Adiciona a chave estrangeira pedidos_pedidos_itens_fk ao atributo pedido_id que referencia lojas.pedidos.pedido_id
ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES lojas.pedidos (pedido_id);

-- Adiciona a chave estrangeira envios_pedidos_itens_fk ao atributo envio_id que referencia lojas.envios.envio_id
ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES lojas.envios (envio_id);

-- Quantidade deve ser positiva
ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT quantidade_check
CHECK (quantidade > 0);

-- O preço tem que ser positivo
ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT preco_check
CHECK (preco_unitario >= 0);

-- Comentários para a relação pedidos_itens e seus atributos
COMMENT ON TABLE lojas.pedidos_itens IS 'Relação que representa os itens de um pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id IS 'Atributo que representa um pedido. Faz parte da chave primária.';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id IS 'Atributo que representa um produto. Faz parte da chave primária.';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS 'Atributo que representa o número da linha de um item de um pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario IS 'Atributo que representa o preço por unidade de um item em um pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade IS 'Atributo que representa o número de unidades de um item em um pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id IS 'Atributo que representa as informações de envio de um item de um pedido.';