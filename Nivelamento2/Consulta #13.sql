-- Otimização e indexação

ALTER TABLE post ADD COLUMN IF NOT EXISTS content_vector tsvector;

UPDATE post
SET content_vector =
	setweight(to_tsvector(language::regconfig, title), 'A') || 
	setweight(to_tsvector(language::regconfig, content), 'B');
	
CREATE INDEX idx_fts_post1 ON post USING GIN(content_vector);


SELECT * FROM post
WHERE content_vector @@ TO_TSQUERY('english', 'star');


-- Se for aceitável que se tenha algum atraso antes que um documento possa ser encontrado em uma busca, então este pode ser um bom caso de uso para uma visão materializada e com isto, seja possível construir um índice extra sobre esta visão.


CREATE MATERIALIZED VIEW search_index AS
SELECT post.id,
   	post.title,
   	setweight(to_tsvector(post.language::regconfig, post.title), 'A') ||
   	setweight(to_tsvector(post.language::regconfig, post.content), 'B') ||
   	setweight(to_tsvector('simple', author.name), 'C') ||
   	setweight(to_tsvector('simple', coalesce(string_agg(tag.name, ' '))), 'A') as document
FROM post
JOIN author ON author.id = post.author_id
JOIN posts_tags ON posts_tags.post_id = posts_tags.tag_id
JOIN tag ON tag.id = posts_tags.tag_id
GROUP BY post.id, author.id


-- Diante disto, é possível adicionar um índice na visão materializada.


CREATE INDEX idx_fts_search ON search_index USING gin(document);


-- E a consulta vai se tornar muito mais simples conforme o exemplo abaixo:

SELECT id as post_id, title
FROM search_index AS p_search
WHERE p_search.document @@ to_tsquery('english', 'Endangered & Species')
ORDER BY ts_rank(p_search.document, to_tsquery('english', 'Endangered & Species')) DESC;
