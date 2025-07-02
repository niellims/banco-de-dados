-- 7. (1,5 ponto) – View com Filtro de Texto
-- Crie uma view chamada filmes_ficcao que liste os campos filme_id, titulo e descricao da tabela filme, apenas para os filmes cujo título contenha a palavra ‘ficção’ (ignorando maiúsculas/minúsculas).
CREATE VIEW filmes_ficcao AS
SELECT filme_id, titulo, descricao
FROM filme
WHERE LOWER(titulo) LIKE '%ficção%';

-- 8. (2,5 pontos) – Trigger para UPDATE
-- Crie uma trigger chamada trg_update_filme_log e uma função associada que registre na tabela log_updates as seguintes informações sempre que um filme for atualizado:
-- log_id (serial, chave primária)
-- filme_id
-- titulo_anterior
-- titulo_novo
-- data_update

CREATE TABLE log_updates (
    log_id SERIAL PRIMARY KEY,
    filme_id INTEGER,
    titulo_anterior TEXT,
    titulo_novo TEXT,
    data_update TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_update_filme()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO log_updates(filme_id, titulo_anterior, titulo_novo, data_update)
  VALUES (OLD.filme_id, OLD.titulo, NEW.titulo, CURRENT_TIMESTAMP);
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_update_filme_log
AFTER UPDATE ON filme
FOR EACH ROW
EXECUTE FUNCTION log_update_filme();

-- 9. A tabela cliente armazena os dados de clientes de uma locadora. Crie uma função e uma trigger que, sempre que um cliente for deletado, registre as seguintes informações em uma nova tabela chamada log_deletes_cliente:
-- log_id (chave primária, serial)
-- cliente_id
-- nome_cliente
-- data_exclusao
-- A trigger deve se chamar trg_delete_cliente_log e ser acionada após a exclusão de um cliente.

CREATE TABLE log_deletes_cliente (
    log_id SERIAL PRIMARY KEY,
    cliente_id INTEGER,
    nome_cliente TEXT,
    data_exclusao TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_delete_cliente()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO log_deletes_cliente(cliente_id, nome_cliente, data_exclusao)
  VALUES (OLD.cliente_id, OLD.nome, CURRENT_TIMESTAMP);
  RETURN OLD;
END;
$$;

CREATE TRIGGER trg_delete_cliente_log
AFTER DELETE ON cliente
FOR EACH ROW
EXECUTE FUNCTION log_delete_cliente();
