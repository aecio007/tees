-- Classificação de documentos

SELECT pid, p_title
FROM (SELECT post.id as pid,
         	post.title as p_title,
         	setweight(to_tsvector(post.language::regconfig, post.title), 'A') ||
         	setweight(to_tsvector(post.language::regconfig, post.content), 'B') ||
         	setweight(to_tsvector('simple', author.name), 'C') ||
         	setweight(to_tsvector('simple', coalesce(string_agg(tag.name, ' '))), 'B') as document
  	FROM post
  	JOIN author ON author.id = post.author_id
  	JOIN posts_tags ON posts_tags.post_id = posts_tags.tag_id
  	JOIN tag ON tag.id = posts_tags.tag_id
  	GROUP BY post.id, author.id) p_search
WHERE p_search.document @@ to_tsquery('english', 'Endangered & Species')
ORDER BY ts_rank(p_search.document, to_tsquery('english', 'Endangered & Species')) DESC;


-- Com base nos pesos atribuídos às partes do documento de exemplo, a função ts_rank() retorna um número flutuante que representa a relevância deste documento em relação a consulta.

SELECT ts_rank(to_tsvector('This is an example of document'),
           	to_tsquery('example | document')) as relevancy;


SELECT ts_rank(to_tsvector('This is an example of document'),
           	to_tsquery('example ')) as relevancy;




SELECT ts_rank(to_tsvector('This is an example of document'),
           	to_tsquery('example | unkown')) as relevancy;


SELECT ts_rank(to_tsvector('This is an example of document'),
           	to_tsquery('example & document')) as relevancy;



SELECT ts_rank(to_tsvector('This is an example of document'),
           	to_tsquery('example & unknown')) as relevancy;

