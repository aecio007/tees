-- Supondo que o post(publicação) possa ser escrito em diferentes idiomas e que o post(publicação) contenha uma coluna do tipo idioma.

ALTER TABLE post ADD language text NOT NULL DEFAULT('english');



-- Desta forma é possível reconstruir o documento para usar a nova coluna de idioma

SELECT to_tsvector(post.language::regconfig, post.title) ||
   	to_tsvector(post.language::regconfig, post.content) ||
   	to_tsvector('simple', author.name) ||
   	to_tsvector('simple', coalesce((string_agg(tag.name, ' ')), '')) as document
FROM post
JOIN author ON author.id = post.author_id
JOIN posts_tags ON posts_tags.post_id = posts_tags.tag_id
JOIN tag ON tag.id = posts_tags.tag_id
GROUP BY post.id, author.id;


SELECT to_tsvector('simple', 'We are running');