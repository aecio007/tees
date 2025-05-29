-- O PostgreSQL possui internamente opções de busca textual para vários idiomas

SELECT to_tsvector('english', 'We are running');


SELECT to_tsvector('french', 'We are running');





