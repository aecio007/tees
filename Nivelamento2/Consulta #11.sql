-- Trabalhando com caracteres acentuados

CREATE EXTENSION unaccent;
SELECT unaccent('èéêë');


-- Como exemplo, pode-se adicionar algum conteúdo acentuado à tabela de publicações.

INSERT INTO post (id, title, content, author_id, language)
VALUES (4, 'il était une fois', 'il était une fois un hôtel ...', 2,'french')


-- Para ignorar os acentos ao construir um documento, é possível simplesmente fazer a seguinte consulta SQL:

SELECT to_tsvector(post.language, unaccent(post.title)) ||
   	to_tsvector(post.language, unaccent(post.content)) ||
   	to_tsvector('simple', unaccent(author.name)) ||
   	to_tsvector('simple', unaccent(coalesce(string_agg(tag.name, ' '))))
FROM post
JOIN author ON author.id = post.author_id
JOIN posts_tags ON posts_tags.post_id = posts_tags.tag_id
JOIN tag ON author.id = post.author_id
GROUP BY p.id


-- construir uma nova configuração de busca textual com suporte a caracteres não acentuados é possível e simplificado como no exemplo abaixo:
CREATE TEXT SEARCH CONFIGURATION fr ( COPY = french );
ALTER TEXT SEARCH CONFIGURATION fr ALTER MAPPING
FOR hword, hword_part, word WITH unaccent, french_stem;




-- Ao utilizar esta nova configuração de busca textual, é possível visualizar os lexemas

SELECT to_tsvector('french', 'il était une fois');


SELECT to_tsvector('fr', 'il était une fois');


-- Esta nova configuração devolve o mesmo resultado de quando é aplicado a extensão unaccent na primeira vez e constrói o tsvector do resultado.


SELECT to_tsvector('french', unaccent('il était une fois'));


-- O número de lexemas é diferente porque il était une são stop words (palavras irrelevantes) em francês. Seria um problema manter estas stop words no documento de exemplo? É um caso a se pensar, uma vez que etait não é realmente uma stop word pois está escrito de forma incorreta.

SELECT to_tsvector('fr', 'Hôtel') @@ to_tsquery('hotels') as RESULT;

-- Ao criar uma configuração de busca não acentuada para cada idioma que uma publicação(post) possa ser escrito e ao manter este valor em post.language, então pode-se manter a mesma consulta do documento anterior.



SELECT 
  to_tsvector(post.language::regconfig, post.title) ||
  to_tsvector(post.language::regconfig, post.content) ||
  to_tsvector('simple', author.name) ||
  to_tsvector('simple', coalesce(string_agg(tag.name, ' '), '')) AS document

FROM post
JOIN author ON author.id = post.author_id
JOIN posts_tags ON posts_tags.post_id = post.id
JOIN tag ON tag.id = posts_tags.tag_id

GROUP BY post.id, author.id, post.language;
