-- 7. (1,5 ponto) – Implementação de View
-- Crie uma view chamada filmes_caros que liste os seguintes campos da tabela filme:
-- filme_id, titulo, taxa_aluguel
-- Somente para os filmes com taxa de aluguel maior que 10.

CREATE VIEW filmes_caros AS
SELECT filme_id, titulo, taxa_aluguel
FROM filme
WHERE taxa_aluguel > 10;


-- 8. (2,5 pontos) – Trigger Function
-- Implemente uma trigger function e um gatilho que registram toda inserção feita na tabela filme em uma tabela chamada log_filmes, com os seguintes campos:
-- log_id (serial, PK)
-- filme_id (integer)
-- titulo (text)
-- data_log (timestamp)
-- O trigger deve ser chamado trg_log_filme e ser acionado APÓS o INSERT.

CREATE TABLE log_filmes (
    log_id SERIAL PRIMARY KEY,
    filme_id INTEGER,
    titulo TEXT,
    data_log TIMESTAMP
);


CREATE OR REPLACE FUNCTION log_insercao_filme()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO log_filmes(filme_id, titulo, data_log)
  VALUES (NEW.filme_id, NEW.titulo, CURRENT_TIMESTAMP);
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_log_filme
AFTER INSERT ON filme
FOR EACH ROW
EXECUTE FUNCTION log_insercao_filme();
